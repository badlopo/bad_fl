part of 'input.dart';

class BadSimpleInput extends BadInput {
  final TextInputType keyboardType;

  const BadSimpleInput({
    super.key,
    required super.controller,
    this.keyboardType = TextInputType.text,
    super.action,
    super.width,
    required super.height,
    super.border,
    super.borderRadius,
    super.fill,
    super.placeholder,
    super.prefixIcon,
    required Widget super.clearIcon,
    super.textStyle,
    super.placeholderStyle,
    super.onChanged,
    super.onSubmitted,
    super.onCleared,
  }) : assert(keyboardType != TextInputType.multiline);

  @override
  State<BadSimpleInput> createState() => _BadSimpleInputState();
}

class _BadSimpleInputState extends State<BadSimpleInput>
    with _BadInputStateMixin<BadSimpleInput> {
  @override
  void initState() {
    super.initState();
    widget.controller._textEditingController = TextEditingController();
    widget.controller._state = this;
  }

  @override
  void dispose() {
    widget.controller._textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPrefix = widget.prefixIcon != null;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        focusNode: _focusNode,
        controller: widget.controller._textEditingController,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        enableInteractiveSelection: false,
        keyboardType: widget.keyboardType,
        textInputAction: widget.action,
        padding: hasPrefix
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.only(left: 12, right: 16),
        decoration: BoxDecoration(
          border: _border,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.fill,
        ),
        prefix: hasPrefix
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: widget.prefixIcon,
              )
            : null,
        suffix: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: BadClickable(onClick: handleClear, child: widget.clearIcon!),
        ),
        suffixMode: OverlayVisibilityMode.editing,
        placeholder: widget.placeholder,
        style: _error == null ? widget.textStyle : widget.errorStyle,
        placeholderStyle: widget.placeholderStyle,
        onTapOutside: (_) => _focusNode.unfocus(),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
