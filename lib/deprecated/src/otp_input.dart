import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../prefab/src/clickable.dart';

class BadOTPInputLegacy extends StatefulWidget {
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

  /// type of input (mainly affects keyboard layout on mobile)
  ///
  /// Default to `TextInputType.text`
  final TextInputType inputType;

  /// action button on mobile keyboard (e.g. done, next, search)
  ///
  /// Default to `TextInputAction.done`
  final TextInputAction textInputAction;

  /// input formatters to restrict input
  final List<TextInputFormatter>? formatters;

  /// maximum length of the input field
  final int? maxLength;

  /// text style of the input field
  final TextStyle? style;

  /// text style of the placeholder text, ignored if [placeholder] is null
  final TextStyle? placeholderStyle;

  /// space between prefixWidget/sendWidget and outside of the input field
  ///
  /// Default to `8`
  final double padding;

  /// space between prefixWidget/sendWidget and text of the input field
  ///
  /// Default to `8`
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

  /// widget to display as role of send button
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  ///
  /// Default to `Icon(Icons.send, size: 16, color: Colors.blue)`
  final Widget sendWidget;

  /// callback when the user taps on the send widget
  final VoidCallback onSendTapped;

  const BadOTPInputLegacy({
    super.key,
    this.width,
    required this.height,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.inputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.formatters,
    this.maxLength,
    this.style,
    this.placeholderStyle,
    this.padding = 8.0,
    this.space = 8.0,
    this.fill,
    this.border,
    this.borderRadius = 0.0,
    this.prefixWidget,
    this.sendWidget = const Icon(Icons.send, size: 16, color: Colors.blue),
    required this.onSendTapped,
  }) : assert(inputType != TextInputType.multiline, 'Use TextField instead.');

  @override
  State<BadOTPInputLegacy> createState() => _BadOTPInputLegacyState();
}

class _BadOTPInputLegacyState extends State<BadOTPInputLegacy> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        keyboardType: widget.inputType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.formatters,
        style: widget.style,
        maxLength: widget.maxLength,
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
                padding: EdgeInsets.only(left: widget.padding),
                child: widget.prefixWidget,
              )
            : null,
        suffix: Padding(
          padding: EdgeInsets.only(right: widget.padding),
          child: BadClickable(
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
