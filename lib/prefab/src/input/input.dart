import 'package:bad_fl/prefab/src/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

part 'common.dart';

part 'phone.dart';

sealed class BadInput extends StatefulWidget {
  final BadInputController controller;
  final TextInputAction action;

  final double? width;
  final double height;
  final Border? border;
  final double borderRadius;
  final Color? fill;

  final Widget? prefixIcon;
  final Widget? errorIcon;
  final Widget clearIcon;

  final String? placeholder;

  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final TextStyle? placeholderStyle;
  final TextStyle? errorMessageStyle;

  final ValueChanged<String>? onChanged;
  final ValueSetter<String>? onSubmitted;
  final VoidCallback? onCleared;

  const BadInput({
    super.key,
    required this.controller,
    this.action = TextInputAction.done,
    this.width,
    required this.height,
    this.border,
    this.borderRadius = 0.0,
    this.fill,
    this.prefixIcon,
    this.errorIcon,
    required this.clearIcon,
    this.placeholder,
    this.textStyle,
    this.errorStyle,
    this.placeholderStyle,
    this.errorMessageStyle,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
  });
}

mixin _BadInputStateMixin<T extends BadInput> on State<T> {
  final FocusNode _focusNode = FocusNode();

  bool _hasFocus = false;

  void _syncFocus() {
    if (_focusNode.hasFocus != _hasFocus) {
      setState(() => _hasFocus = _focusNode.hasFocus);
    }
  }

  String? _error;

  Border? get _border {
    if (_error != null) {
      return const Border.fromBorderSide(BorderSide(color: Color(0xFFEB0555)));
    } else if (_hasFocus) {
      return const Border.fromBorderSide(BorderSide(color: Color(0xFF332CF5)));
    } else {
      return widget.border;
    }
  }

  void handleClear() {
    widget.controller.clear();
    widget.onCleared?.call();
  }

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_syncFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_syncFocus);
    _focusNode.dispose();
    super.dispose();
  }
}

class BadInputController<T extends BadInput> {
  late final TextEditingController _textEditingController;
  late final _BadInputStateMixin _state;

  BadInputController();

  /// set content
  void setText(String text) {
    // not allowed to set phone input directly
    if (T is BadPhoneInput) {
      throw UnsupportedError('Cannot set text for phone input');
    }

    _textEditingController.text = text;
  }

  /// set error message, pass `null` to clear the error message
  void setError([String? error]) {
    if (_state._error != error) {
      _state._error = error;
      _state.update();
    }
  }

  void clear() {
    _textEditingController.clear();
  }
}
