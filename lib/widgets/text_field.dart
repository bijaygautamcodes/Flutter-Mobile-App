import 'package:flutter/material.dart';

enum TextFieldTypes<TextInputType> { email, password }

class RootNodeTextField extends StatefulWidget {
  const RootNodeTextField({
    Key? key,
    required this.controller,
    required this.type,
    required this.hintText,
    this.validator,
    this.autovalidateMode,
    this.compact = false,
  }) : super(key: key);

  final Future<String?> Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController controller;
  final TextFieldTypes type;
  final String hintText;
  final bool compact;

  @override
  State<RootNodeTextField> createState() => _RootNodeTextFieldState();
}

class _RootNodeTextFieldState extends State<RootNodeTextField> {
  bool _passVisible = false;
  String? asyncStringValidatorData;
  late bool _compact;
  late double _iconSize;
  late double _fontSize;
  @override
  void initState() {
    _compact = widget.compact;
    _iconSize = _compact ? 16 : 20;
    _fontSize = _compact ? 12 : 16;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: _compact ? 10 : 20, vertical: _compact ? 5 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        autovalidateMode: widget.autovalidateMode,
        scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20 * 8),
        controller: widget.controller,
        onChanged: (value) {
          if (widget.validator != null) _handleAsync(value);
        },
        style: TextStyle(color: Colors.white70, fontSize: _fontSize),
        keyboardType: widget.type == TextFieldTypes.email
            ? TextInputType.emailAddress
            : TextInputType.visiblePassword,
        obscureText:
            widget.type != TextFieldTypes.email ? !_passVisible : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return asyncStringValidatorData;
        },
        textInputAction: widget.type == TextFieldTypes.email
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white10,
            border: InputBorder.none,
            contentPadding: _compact
                ? const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 0)
                : const EdgeInsets.only(
                    top: 16, bottom: 16, left: 20, right: 0),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            labelStyle: const TextStyle(
              color: Colors.white54,
            ),
            errorStyle: TextStyle(color: Colors.red[400]!),
            suffixIcon: widget.type == TextFieldTypes.password && !_compact
                ? IconButton(
                    color: Colors.white70,
                    padding: EdgeInsets.zero,
                    splashRadius: _iconSize,
                    iconSize: _iconSize,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      _passVisible ? Icons.visibility : Icons.visibility_off,
                      size: _iconSize,
                    ),
                    onPressed: () {
                      setState(() {
                        _passVisible = !_passVisible;
                      });
                    },
                  )
                : null),
      ),
    );
  }

  _handleAsync(String value) async {
    asyncStringValidatorData = await widget.validator!(value);
    setState(() {});
  }
}
