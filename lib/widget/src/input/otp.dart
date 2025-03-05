part of 'input.dart';

/// OTP input widget with customizable suffix widget.
/// TODO: refactor to cubic style
class BadOTPInput extends BadInput {
  final int? maxLength;
  final Widget suffixWidget;

  const BadOTPInput({
    super.key,
    required super.controller,
    super.enabled = true,
    super.action,
    this.maxLength,
    super.width,
    required super.height,
    super.border,
    super.focusBorder,
    super.errorBorder,
    super.borderRadius,
    super.fill,
    super.placeholder,
    required Widget super.prefixIcon,
    required Widget super.errorIcon,
    required this.suffixWidget,
    super.textStyle,
    super.errorStyle,
    super.placeholderStyle,
    super.errorMessageStyle,
    super.onChanged,
    super.onSubmitted,
  });

  @override
  State<BadOTPInput> createState() => _BadOTPInputState();
}

class _BadOTPInputState extends State<BadOTPInput>
    with _BadInputStateMixin<BadOTPInput> {
  @override
  void initState() {
    super.initState();
    widget.controller._attach(state: this);
  }

  @override
  void dispose() {
    widget.controller._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final input = SizedBox(
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        focusNode: _focusNode,
        controller: widget.controller._textEditingController,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        // enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
        textInputAction: widget.action,
        maxLength: widget.maxLength,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: _border,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.fill,
        ),
        prefix: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: widget.prefixIcon,
        ),
        suffix: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: widget.suffixWidget,
        ),
        suffixMode: OverlayVisibilityMode.always,
        placeholder: widget.placeholder,
        style: _error == null ? widget.textStyle : widget.errorStyle,
        placeholderStyle: widget.placeholderStyle,
        onTapOutside: (_) => _focusNode.unfocus(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        input,
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                widget.errorIcon!,
                const SizedBox(width: 4),
                Expanded(child: Text(_error!, style: widget.errorMessageStyle)),
              ],
            ),
          ),
      ],
    );
  }
}
