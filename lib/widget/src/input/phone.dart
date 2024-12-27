part of 'input.dart';

/// Phone number input widget with customizable separator.
///
/// Features: `Base`, `Prefix icon`, `Error state` (refer to [BadInput] for all features).
/// Extra features: `Separator`.
class BadPhoneInput extends BadInput {
  /// Optional slot widget to display between prefix icon and input field.
  final Widget? slot;

  /// A single character to separate phone number digits for better readability.
  ///
  /// Default to `' '`
  final String separator;

  const BadPhoneInput({
    super.key,
    required super.controller,
    super.action,
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
    required Widget super.clearIcon,
    this.slot,
    this.separator = ' ',
    super.textStyle,
    super.errorStyle,
    super.placeholderStyle,
    super.errorMessageStyle,
    super.onChanged,
    super.onSubmitted,
    super.onCleared,
  }) : assert(separator.length == 1, 'separator must be a single character');

  @override
  State<BadPhoneInput> createState() => _BadPhoneInputState();
}

class _BadPhoneInputState extends State<BadPhoneInput>
    with _BadInputStateMixin<BadPhoneInput> {
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
        keyboardType: TextInputType.phone,
        textInputAction: widget.action,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: _border,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.fill,
        ),
        prefix: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: widget.slot == null
              ? widget.prefixIcon
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [widget.prefixIcon!, widget.slot!],
                ),
        ),
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
