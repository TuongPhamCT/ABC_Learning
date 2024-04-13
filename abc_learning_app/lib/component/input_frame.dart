import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:flutter/material.dart';

class InputFrame extends StatefulWidget {
  final String? hintText;
  final bool? isPassword;
  final TextAlign? textAlign;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? obscureCharacter;
  const InputFrame({
    super.key,
    this.hintText,
    this.isPassword = false,
    this.controller,
    this.textAlign,
    this.keyboardType,
    this.obscureCharacter,
  });

  @override
  State<InputFrame> createState() => _InputFrameState();
}

class _InputFrameState extends State<InputFrame> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscuringCharacter: widget.obscureCharacter ?? '•',
      keyboardType: widget.keyboardType,
      textAlign: widget.textAlign ?? TextAlign.start,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      controller: widget.controller,
      obscureText: isObscure,
      cursorColor: ColorPalette.logintitle,
      style: TextStyles.loginText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: ColorPalette.logintitle),
        ),
        suffixIcon: widget.isPassword ?? false
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
    );
  }
}
