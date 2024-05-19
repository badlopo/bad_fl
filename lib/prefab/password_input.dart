import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BadPasswordInput extends StatefulWidget {
  /// width of the input field
  final double? width;

  /// height of the input field
  final double height;

  /// initial visibility of the password
  ///
  /// Default to `false`
  final bool initialVisibility;

  /// placeholder text
  final String? placeholder;

  /// callback when the visibility changes
  final ValueChanged<bool>? onVisibilityChanged;

  /// callback when the value changes
  final ValueChanged<String>? onChanged;

  /// callback when the user submits the input (e.g. press enter)
  final ValueSetter<String>? onSubmitted;

  /// action button on mobile keyboard (e.g. done, next, search)
  ///
  /// Default to `TextInputAction.done`
  final TextInputAction textInputAction;

  /// input formatters to restrict input
  final List<TextInputFormatter>? formatters;

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

  /// widget to display when the password is visible
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  ///
  /// Default to `const Icon(Icons.visibility_outlined, size: 16, color: Colors.grey)`
  final Widget visibleWidget;

  /// widget to display when the password is hidden
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  ///
  /// Default to `const Icon(Icons.visibility_off_outlined, size: 16, color: Colors.grey)`
  final Widget hiddenWidget;

  const BadPasswordInput({
    super.key,
    this.width,
    required this.height,
    this.initialVisibility = false,
    this.placeholder,
    this.onVisibilityChanged,
    this.onChanged,
    this.onSubmitted,
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
    this.visibleWidget =
        const Icon(Icons.visibility_outlined, size: 16, color: Colors.grey),
    this.hiddenWidget =
        const Icon(Icons.visibility_off_outlined, size: 16, color: Colors.grey),
  });

  @override
  State<BadPasswordInput> createState() => _BadPasswordInputState();
}

class _BadPasswordInputState extends State<BadPasswordInput> {
  final TextEditingController _controller = TextEditingController();

  // default to true here, but the real initialisation is done in [initState]
  bool _obscureText = true;

  void toggleVisibility() {
    // toggle visibility
    setState(() {
      _obscureText = !_obscureText;
    });

    // call the callback if provided
    widget.onVisibilityChanged?.call(!_obscureText);
  }

  @override
  void initState() {
    super.initState();
    _obscureText = !widget.initialVisibility;
  }

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
        obscureText: _obscureText,
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
              BadClickable(
                onClick: toggleVisibility,
                child:
                    _obscureText ? widget.hiddenWidget : widget.visibleWidget,
              ),
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
