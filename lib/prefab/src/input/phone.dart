part of 'input.dart';

class BadPhoneInput extends BadInput {
  final String separator;

  const BadPhoneInput({
    super.key,
    required super.controller,
    super.action,
    super.width,
    required super.height,
    super.borderRadius,
    super.fill,
    super.placeholder,
    required Widget super.prefixIcon,
    required Widget super.errorIcon,
    required Widget super.clearIcon,
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
  void _reformat() {
    final text = widget.controller._textEditingController.text;

    final formatted = text
        .replaceAll(RegExp(r'\D'), '')
        .split('')
        .fold<StringBuffer>(StringBuffer(), (buffer, char) {
      // 3-3-4 (3 digits, separator, 3 digits, separator, 4 digits)
      if (buffer.length == 3 || buffer.length == 8) {
        buffer.write(widget.separator);
      }
      buffer.write(char);
      return buffer;
    }).toString();

    if (text != formatted) {
      widget.controller._textEditingController.text = formatted;
      // widget.controller._textEditingController.value = TextEditingValue(
      //   text: formatted,
      //   selection: TextSelection.collapsed(offset: formatted.length),
      // );
    }
  }

  /// recover the original text without separators
  void _onChangeDelegate(String s) {
    if (widget.onChanged != null) {
      widget.onChanged!(s.replaceAll(RegExp(r'\D'), ''));
    }
  }

  /// recover the original text without separators
  void _onSubmitDelegate(String s) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(s.replaceAll(RegExp(r'\D'), ''));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller._attach(state: this);
    widget.controller._textEditingController.addListener(_reformat);
  }

  @override
  void dispose() {
    widget.controller._textEditingController.removeListener(_reformat);
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
        enableInteractiveSelection: false,
        keyboardType: TextInputType.phone,
        textInputAction: widget.action,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 11,
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
          child: BadClickable(onClick: handleClear, child: widget.clearIcon!),
        ),
        suffixMode: OverlayVisibilityMode.editing,
        placeholder: widget.placeholder,
        style: _error == null ? widget.textStyle : widget.errorStyle,
        placeholderStyle: widget.placeholderStyle,
        onTapOutside: (_) => _focusNode.unfocus(),
        onChanged: _onChangeDelegate,
        onSubmitted: _onSubmitDelegate,
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
