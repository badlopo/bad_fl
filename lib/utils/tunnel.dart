import 'dart:async';

import 'package:flutter/material.dart';

/// A simple `mpmc` implementation based on `StreamController.broadcast`.
///
/// NOTE:
///
/// This implementation is very crude!
/// No RC, No Lock ...
/// It's obviously unsafe across threads, even the implementation of [cleanup] within the same thread is fragile.
class Tunnel {
  /// name => stream controller
  static final _tunnels = <String, StreamController>{};

  /// Cleanup unused tunnels.
  static void cleanup() {
    for (final tunnel in _tunnels.entries) {
      if (!tunnel.value.hasListener) {
        tunnel.value.close();
        _tunnels.remove(tunnel.key);
      }
    }
  }

  /// Get all active tunnel names.
  ///
  /// NOTE: This will also trigger a cleanup.
  static Set<String> get activeTunnels {
    cleanup();
    return _tunnels.keys.toSet();
  }

  final String name;

  StreamController get _controller => _tunnels[name]!;

  const Tunnel._(this.name);

  /// Find a tunnel by custom name, create one if not exists.
  ///
  /// NOTE: custom name may conflict with name of pre-defined tunnel, use with caution.
  factory Tunnel(String name) {
    // Create a new tunnel if not exists
    if (!_tunnels.containsKey(name)) {
      _tunnels[name] = StreamController.broadcast();
    }

    return Tunnel._(name);
  }

  /// Subscribe to event of a specific type, return a function to cancel the subscription
  VoidCallback listen<T>(void Function(T) handler) {
    final sub = _controller.stream.listen((event) {
      if (event is T) handler(event);
    });

    // We need more than just returning `sub.cancel` since we need to do some cleanup work.
    return () {
      sub.cancel();

      // Cleanup if no more listeners on this tunnel.
      //
      // OPTIMIZE:
      // This may reduce performance if the tunnel is frequently used (created and destroyed).
      // If so, we can use a counter to reduce the frequency of cleanup.
      if (!_controller.hasListener) {
        // No more listeners, close the controller and remove the tunnel
        _controller.close();
        _tunnels.remove(name);
      }
    };
  }

  /// You can send any data through the tunnel, only subscribers of the same type will receive it.
  void send(Object? data) {
    _controller.add(data);
  }
}

mixin SingleTunnelListenerMixin<T extends StatefulWidget, EventType>
    on State<T> {
  VoidCallback? _unlistenTunnel;

  /// The name of the tunnel to listen to.
  abstract final String tunnelName;

  /// Handler for tunnel events.
  void onTunnelEvent(EventType event);

  @override
  void initState() {
    super.initState();
    _unlistenTunnel = Tunnel(tunnelName).listen<EventType>((ev) {
      if (mounted) onTunnelEvent(ev);
    });
  }

  @override
  void dispose() {
    _unlistenTunnel?.call();
    super.dispose();
  }
}
