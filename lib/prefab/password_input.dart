import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BadPasswordInput extends StatefulWidget {
  /// width of the input field
  final double? width;

  /// height of the input field
  final double height;

  /// initial value of the input field
  final String? initialValue;

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

  /// widget to display when the password is visible
  ///
  /// Default to [Icons.visibility_outlined] with size `16` and color [Colors.grey]
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  final Widget visibleWidget;

  /// widget to display when the password is hidden
  ///
  /// Default to [Icons.visibility_off_outlined] with size `16` and color [Colors.grey]
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  final Widget hiddenWidget;

  const BadPasswordInput({
    super.key,
    this.width,
    required this.height,
    this.initialValue,
    this.initialVisibility = false,
    this.placeholder,
    this.onVisibilityChanged,
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
    this.visibleWidget = const Icon(
      Icons.visibility_outlined,
      size: 16,
      color: Colors.grey,
    ),
    this.hiddenWidget = const Icon(
      Icons.visibility_off_outlined,
      size: 16,
      color: Colors.grey,
    ),
  }) : assert(
          placeholderStyle == null || placeholder != null,
          'Placeholder style requires placeholder.',
        );

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
    if (widget.initialValue != null) _controller.text = widget.initialValue!;
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
                padding: EdgeInsets.only(left: widget.space),
                child: widget.prefixWidget,
              )
            : null,
        suffix: Padding(
          padding: EdgeInsets.only(right: widget.space),
          child: Clickable(
            onClick: toggleVisibility,
            child: _obscureText ? widget.hiddenWidget : widget.visibleWidget,
          ),
        ),
        suffixMode: OverlayVisibilityMode.editing,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}