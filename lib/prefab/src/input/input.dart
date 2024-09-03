import 'package:bad_fl/core.dart';
import 'package:bad_fl/prefab/src/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

part 'common.dart';

part 'otp.dart';

part 'password.dart';

part 'phone.dart';

part 'simple.dart';

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
  final Widget? clearIcon;

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
    this.clearIcon,
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

  /// hold the state of the widget which is using this controller
  _BadInputStateMixin<T>? _state;

  /// runtime type of the input, more for internal use
  Type? get inputType => _state?.widget.runtimeType;

  /// current input content
  String get text {
    if (!_oncelock) {
      throw StateError('Cannot get text before attaching to a widget');
    }

    // remove all non-digit characters for phone input
    if (inputType == BadPhoneInput) {
      return _textEditingController.text.replaceAll(RegExp(r'\D'), '');
    }

    return _textEditingController.text;
  }

  /// whether the input is in error state
  bool get hasError => _state?._error != null;

  bool _oncelock = false;

  BadInputController();

  void _attach({required _BadInputStateMixin<T> state, String? defaultText}) {
    if (!_oncelock) {
      BadFl.log(
        module: 'BadInput',
        message: 'initialize TextEditingController',
      );

      _textEditingController = TextEditingController(text: defaultText);
      _oncelock = true;
    }

    _state = state;
  }

  void _detach() {
    _textEditingController.clear();
    _state = null;
  }

  /// focus on the input
  void focus() {
    if (_state == null) {
      throw StateError('Cannot focus before attaching to a widget');
    }

    _state!._focusNode.requestFocus();
  }

  /// set content
  void setText(String text) {
    // not allowed to set phone input directly
    if (inputType == BadPhoneInput) {
      throw UnsupportedError('Cannot set text for phone input');
    }

    _textEditingController.text = text;
  }

  /// set error message, pass `null` to clear the error message
  void setError([String? error]) {
    if (_state == null) {
      throw StateError('Cannot set error before attaching to a widget');
    }

    if (inputType == BadSimpleInput) {
      throw UnsupportedError('Cannot set error for simple input');
    }

    if (_state!._error != error) {
      _state!._error = error;
      _state!.update();
    }
  }

  void clear() {
    _textEditingController.clear();
  }

  void dispose() {
    _textEditingController.dispose();
  }
}
