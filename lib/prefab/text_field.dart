import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BadTextField extends StatefulWidget {
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

  /// action button on mobile keyboard (e.g. done, next, search)
  final TextInputAction textInputAction;

  /// input formatters to restrict input
  final List<TextInputFormatter>? formatters;

  /// maximum count of characters
  final int? maxLength;

  /// text style of the input field
  final TextStyle? style;

  /// text style of the placeholder text, ignored if [placeholder] is null
  final TextStyle? placeholderStyle;

  /// space between content and outside of the input field
  ///
  /// Default to `EdgeInsets.all(8)`
  final EdgeInsets padding;

  /// space between text and clear/count widget
  ///
  /// Default to `8`
  final double space;

  /// background color of the input field
  final Color? fill;

  /// border of the input field
  final BoxBorder? border;

  /// border radius of the input field
  final double borderRadius;

  /// widget to click to clear the input field
  ///
  /// Default to [Icons.close_rounded] with size `16` and color [Colors.grey]
  ///
  /// Note: there is no constraint on the size of the widget, be careful to its size if you provide a custom widget
  final Widget clearWidget;

  const BadTextField({
    super.key,
    this.width,
    required this.height,
    this.initialValue,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
    this.formatters,
    this.maxLength,
    this.style,
    this.placeholderStyle,
    this.padding = const EdgeInsets.all(8),
    this.space = 8,
    this.fill,
    this.border,
    this.borderRadius = 0.0,
    this.clearWidget = const Icon(
      Icons.close_rounded,
      size: 16,
      color: Colors.grey,
    ),
  }) : assert(maxLength == null || maxLength > 0, 'maxLength must be positive');

  @override
  State<BadTextField> createState() => _BadTextFieldState();
}

class _BadTextFieldState extends State<BadTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _controller.text = widget.initialValue!;
  }

  void handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget inner = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.fill,
        border: widget.border,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _controller,
              magnifierConfiguration: TextMagnifierConfiguration.disabled,
              expands: true,
              minLines: null,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.formatters,
              style: widget.style,
              decoration: null,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ),
          SizedBox(height: widget.space),
          // TODO: clear/count
        ],
      ),
    );

    return inner;
  }
}
