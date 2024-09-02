part of 'input.dart';

class BadPasswordInput extends BadInput {
  final int? maxLength;
  final String obscuringCharacter;

  final Widget visibleIcon;
  final Widget invisibleIcon;

  const BadPasswordInput({
    super.key,
    required super.controller,
    super.action,
    this.maxLength,
    super.width,
    required super.height,
    super.borderRadius,
    super.fill,
    super.placeholder,
    required Widget super.prefixIcon,
    required Widget super.errorIcon,
    required this.visibleIcon,
    required this.invisibleIcon,
    this.obscuringCharacter = '•',
    super.textStyle,
    super.errorStyle,
    super.placeholderStyle,
    super.errorMessageStyle,
    super.onChanged,
    super.onSubmitted,
  });

  @override
  State<BadPasswordInput> createState() => _BadPasswordInputState();
}

class _BadPasswordInputState extends State<BadPasswordInput>
    with _BadInputStateMixin<BadPasswordInput> {
  bool _visible = false;

  void toggleVisibility() {
    setState(() => _visible = !_visible);
  }

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
        enableInteractiveSelection: false,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.action,
        obscureText: !_visible,
        obscuringCharacter: widget.obscuringCharacter,
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
          child: BadClickable(
            onClick: toggleVisibility,
            child: _visible ? widget.visibleIcon : widget.invisibleIcon,
          ),
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
