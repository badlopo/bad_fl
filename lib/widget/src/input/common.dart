part of 'input.dart';

/// Common input widget with customizable prefix icon.
///
/// Features: `Base`, `Prefix icon`, `Error state` (refer to [BadInput] for all features)
class BadCommonInput extends BadInput {
  final TextInputType keyboardType;

  const BadCommonInput({
    super.key,
    required super.controller,
    this.keyboardType = TextInputType.text,
    super.action,
    super.width,
    required super.height,
    super.border,
    super.focusBorder,
    super.errorBorder,
    super.borderRadius,
    super.fill,
    super.placeholder,
    super.prefixIcon,
    required Widget super.errorIcon,
    required Widget super.clearIcon,
    super.textStyle,
    super.errorStyle,
    super.placeholderStyle,
    super.errorMessageStyle,
    super.onChanged,
    super.onSubmitted,
    super.onCleared,
  }) : assert(keyboardType != TextInputType.multiline);

  @override
  State<BadCommonInput> createState() => _BadCommonInputState();
}

class _BadCommonInputState extends State<BadCommonInput>
    with _BadInputStateMixin<BadCommonInput> {
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
    final hasPrefix = widget.prefixIcon != null;

    final input = SizedBox(
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        focusNode: _focusNode,
        controller: widget.controller._textEditingController,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        // enableInteractiveSelection: false,
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
