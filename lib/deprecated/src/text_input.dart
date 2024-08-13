import 'package:bad_fl/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../prefab/src/clickable.dart';

class BadTextInputLegacy extends StatefulWidget {
  /// provide a [TextEditingController] to control the input field outside of the widget
  final TextEditingController? controller;

  /// width of the input field
  final double? width;

  /// height of the input field
  final double height;

  /// initial value of the input field
  final String? initialValue;

  /// placeholder text
  final String? placeholder;

  /// callback when the value changes
  final ValueChanged<String>? onChanged;

  /// callback when the `clearWidget` is clicked
  final VoidCallback? onCleared;

  /// callback when the user submits (e.g. press enter)
  final ValueSetter<String>? onSubmitted;

  /// type of input (mainly affects keyboard layout on mobile)
  final TextInputType inputType;

  /// action button on mobile keyboard (e.g. done, next, search)
  final TextInputAction textInputAction;

  /// input formatters to restrict input
  final List<TextInputFormatter>? formatters;

  /// maximum length of the input field
  final int? maxLength;

  /// text style of the input field
  final TextStyle? style;

  /// text style of the placeholder text, ignored if [placeholder] is null
  final TextStyle? placeholderStyle;

  /// space between prefixWidget/suffixWidget and outside of the input field
  ///
  /// Default to `8`
  final double padding;

  /// space between prefixWidget/suffixWidget and text of the input field
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

  /// widget to display after the input field
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size
  final Widget? suffixWidget;

  /// widget to click to clear the input field
  ///
  /// Default to `Icon(Icons.clear, size: 16, color: Colors.grey)`
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  final Widget clearWidget;

  const BadTextInputLegacy({
    super.key,
    this.controller,
    this.width,
    required this.height,
    this.initialValue,
    this.placeholder,
    this.onChanged,
    this.onCleared,
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
    this.suffixWidget,
    this.clearWidget = const Icon(Icons.clear, size: 16, color: Colors.grey),
  }) : assert(inputType != TextInputType.multiline, 'Use TextField instead.');

  @override
  State<BadTextInputLegacy> createState() => _BadTextInputLegacyState();
}

class _BadTextInputLegacyState extends State<BadTextInputLegacy> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      BadFl.log(
        module: 'BadTextInputLegacy',
        message: 'maintains "TextEditingController" internally',
      );
    }
    if (widget.initialValue != null) _controller.text = widget.initialValue!;
  }

  @override
  void dispose() {
    // only dispose the controller maintained by the widget
    if (widget.controller == null) {
      _controller.dispose();
      BadFl.log(
        module: 'BadTextInputLegacy',
        message: 'internally maintained "TextEditingController" disposed',
      );
    }
    super.dispose();
  }

  void handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        controller: _controller,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        keyboardType: widget.inputType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.formatters,
        maxLength: widget.maxLength,
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
                padding: EdgeInsets.only(left: widget.padding),
                child: widget.prefixWidget,
              )
            : null,
        suffix: Padding(
          padding: EdgeInsets.only(right: widget.padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadClickable(onClick: handleClear, child: widget.clearWidget),
              if (widget.suffixWidget != null) widget.suffixWidget!,
            ],
          ),
        ),
        suffixMode: widget.suffixWidget == null
            ? OverlayVisibilityMode.editing
            : OverlayVisibilityMode.always,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
