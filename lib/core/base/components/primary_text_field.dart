import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextField extends StatefulWidget {
  final String hintText;
  final bool hasSuffixIcon;
  final bool isPassword;
  final TextEditingController controller;
    final FormFieldValidator<String>? validator;



  const PrimaryTextField({
    this.validator,
    Key? key,
    required this.hintText,
    this.hasSuffixIcon = false,
    this.isPassword = false,
    required this.controller,
  }) : super(key: key);

  @override
  _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool _isObscured = true;
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                validator: widget.validator,

      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.hasSuffixIcon
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
