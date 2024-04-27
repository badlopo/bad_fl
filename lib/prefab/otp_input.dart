import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BadOTPInput extends StatefulWidget {
  /// width of the input field
  final double? width;

  /// height of the input field
  final double height;

  /// placeholder text
  final String? placeholder;

  /// callback when the value changes
  final ValueChanged<String>? onChanged;

  /// callback when the user submits the input (e.g. press enter)
  final ValueSetter<String>? onSubmitted;

  /// action button on mobile keyboard (e.g. done, next, search)
  final TextInputAction textInputAction;

  /// input formatters to restrict input
  final List<TextInputFormatter>? formatters;

  /// text style of the input field
  final TextStyle? style;

  /// text style of the placeholder text
  final TextStyle? placeholderStyle;

  /// space between prefix, input field, and suffix
  final double space;

  /// background color of the input field
  final Color? fill;

  /// border of the input field
  final BoxBorder? border;

  /// border radius of the input field
  final double borderRadius;

  /// widget to display before the input field
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size
  final Widget? prefixWidget;

  /// widget to display when 'send' button is available
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  final Widget sendWidget;

  /// callback when the user taps on the send widget
  final VoidCallback onSendTapped;

  const BadOTPInput({
    super.key,
    this.width,
    required this.height,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
    this.formatters,
    this.style,
    this.placeholderStyle,
    this.space = 8.0,
    this.fill,
    this.border,
    this.borderRadius = 0.0,
    this.prefixWidget,
    this.sendWidget = const Icon(Icons.send, size: 16, color: Colors.blue),
    required this.onSendTapped,
  }) : assert(
          placeholderStyle == null || placeholder != null,
          'Placeholder style requires placeholder.',
        );

  @override
  State<BadOTPInput> createState() => _BadOTPInputState();
}

class _BadOTPInputState extends State<BadOTPInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        controller: _controller,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.formatters,
        style: widget.style,
        placeholder: widget.placeholder,
        placeholderStyle: widget.placeholderStyle,
        padding: EdgeInsets.symmetric(horizontal: widget.space),
        decoration: BoxDecoration(
          color: widget.fill,
          border: widget.border,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        prefix: widget.prefixWidget != null
            ? Padding(
                padding: EdgeInsets.only(left: widget.space),
                child: widget.prefixWidget,
              )
            : null,
        suffix: Padding(
          padding: EdgeInsets.only(right: widget.space),
          child: Clickable(
            onClick: widget.onSendTapped,
            child: widget.sendWidget,
          ),
        ),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
