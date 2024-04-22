import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadTextInput extends StatefulWidget {
  final double? width;
  final double height;
  final String? initialValue;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueSetter<String>? onSubmitted;

  final TextInputType inputType;
  final TextInputAction textInputAction;
  final TextStyle? style;
  final TextStyle? placeholderStyle;

  final double space;
  final Color? fill;
  final BoxBorder? border;
  final double borderRadius;

  final Widget? prefixWidget;
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
    this.style,
    this.placeholderStyle,
    this.space = 8.0,
    this.fill,
    this.border,
    this.borderRadius = 0.0,
    this.prefixWidget,
    this.clearWidget = const Icon(
      Icons.close_rounded,
      size: 16,
      color: Colors.grey,
    ),
  })  : assert(inputType != TextInputType.multiline, 'Use TextField instead.'),
        assert(
          placeholderStyle == null || placeholder != null,
          'Placeholder style requires placeholder.',
        );

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
          child: Clickable(onClick: handleClear, child: widget.clearWidget),
        ),
        suffixMode: OverlayVisibilityMode.editing,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
