import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';

typedef Validator = String? Function(String?);

class CustomFormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool secureText;
  final TextEditingController? controller;
  final int lines;
  final Validator? validator;
  final List<TextInputFormatter> inputFormatters;

  const CustomFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.secureText = false,
    this.controller,
    this.lines = 1,
    this.validator,
    this.inputFormatters = const [],
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;
  String? _errorText;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validateField(String? value) {
    setState(() {
      _errorText = widget.validator?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: MyTheme.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: _validateField,
            validator: widget.validator,
            cursorHeight: 25,
            cursorWidth: 1,
            cursorRadius: const Radius.circular(20),
            cursorErrorColor: MyTheme.redColor,
            obscureText: widget.secureText && _obscureText,
            minLines: widget.lines,
            maxLines: widget.lines,
            keyboardType: widget.keyboardType,
            inputFormatters: [
              ...widget.inputFormatters,
              if (widget.keyboardType == TextInputType.emailAddress)
                FilteringTextInputFormatter.allow(RegExp(
                    r'[@a-zA-Z0-9.]')), // Allow @, alphabetic characters, numbers, and "."
              LengthLimitingTextInputFormatter(
                  widget.keyboardType == TextInputType.emailAddress
                      ? 64
                      : 32), // Limit characters based on type
            ],
            style: TextStyle(
              color: MyTheme.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
            cursorColor: MyTheme.whiteColor,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: MyTheme.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: MyTheme.whiteColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: MyTheme.whiteColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: MyTheme.whiteColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: MyTheme.redColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: MyTheme.redColor,
                ),
              ),
              errorText: _errorText,
              suffixIcon: widget.secureText
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              )
                  : null,
            ),
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}
