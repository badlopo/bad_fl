import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BadTextInput extends StatefulWidget {
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

  /// callback when the user submits the input (e.g. press enter)
  final ValueSetter<String>? onSubmitted;

  /// type of input (mainly affects keyboard layout on mobile)
  final TextInputType inputType;

  /// action button on mobile keyboard (e.g. done, next, search)
  final TextInputAction textInputAction;

  /// input formatters to restrict input
  final List<TextInputFormatter>? formatters;

  /// text style of the input field
  final TextStyle? style;

  /// text style of the placeholder text, ignored if [placeholder] is null
  final TextStyle? placeholderStyle;

  /// space between prefix/suffix and outside of the input field
  ///
  /// Default to `8`
  final double padding;

  /// space between prefix/suffix and text of the input field
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
  /// Default to [Icons.close_rounded] with size `16` and color [Colors.grey]
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  final Widget clearWidget;

  const BadTextInput({
    super.key,
    this.width,
    required this.height,
    this.initialValue,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.inputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.formatters,
    this.style,
    this.placeholderStyle,
    this.padding = 8.0,
    this.space = 8.0,
    this.fill,
    this.border,
    this.borderRadius = 0.0,
    this.prefixWidget,
    this.suffixWidget,
    this.clearWidget = const Icon(
      Icons.close_rounded,
      size: 16,
      color: Colors.grey,
    ),
  }) : assert(inputType != TextInputType.multiline, 'Use TextField instead.');

  @override
  State<BadTextInput> createState() => _BadTextInputState();
}

class _BadTextInputState extends State<BadTextInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _controller.text = widget.initialValue!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
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
