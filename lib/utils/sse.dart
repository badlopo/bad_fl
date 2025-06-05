import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class SSERaw {
  final Map<String, String> fields;

  const SSERaw(this.fields);

  Map<String, String> toJson() => fields;

  @override
  String toString() {
    return '[SSERaw]\n${fields.entries.map((entry) => '${entry.key}:${entry.value}').join('\n')}';
  }
}

class SSERawTransformer extends StreamTransformerBase<Uint8List, SSERaw> {
  final _fields = <String, String>{};

  @override
  Stream<SSERaw> bind(Stream<Uint8List> stream) async* {
    final lines = stream
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    await for (final line in lines) {
      // ignore comment lines
      if (line.startsWith(':')) continue;

      // chunk finished
      if (line == '') {
        yield SSERaw(_fields);
        _fields.clear();
      }

      // field lines
      else {
        final bp = line.indexOf(':');
        if (bp == -1) {
          // unreachable!
          throw FormatException('invalid chunk line: $line');
        }

        _fields[line.substring(0, bp)] = line.substring(bp + 1);
      }
    }
  }
}

class SSEEvent {
  final String? id;
  final String? event;
  final String? data;

  // ignore comments & retry fields
  // final List<String> comments;
  // final String? retry;

  const SSEEvent({
    required this.id,
    required this.event,
    required this.data,
  });

  @override
  String toString() {
    return '[SSEEvent]\nid:${id ?? ''}\nevent:${event ?? ''}\ndata:${data ?? ''}';
  }
}

class SSEEventTransformer extends StreamTransformerBase<Uint8List, SSEEvent> {
  final _fields = <String, String>{};

  @override
  Stream<SSEEvent> bind(Stream<Uint8List> stream) async* {
    final lines = stream
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    await for (final line in lines) {
      // ignore comment lines
      if (line.startsWith(':')) continue;

      // chunk finished
      if (line == '') {
        yield SSEEvent(
          id: _fields['id'],
          event: _fields['event'],
          data: _fields['data'],
        );
        _fields.clear();
      }

      // field lines
      else {
        final bp = line.indexOf(':');
        if (bp == -1) {
          // unreachable!
          throw FormatException('invalid chunk line: $line');
        }

        _fields[line.substring(0, bp).toLowerCase()] = line.substring(bp + 1);
      }
    }
  }
}
