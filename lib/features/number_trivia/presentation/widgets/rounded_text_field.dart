import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberia/core/common/themes/color_palette.dart';

class RoundedTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const RoundedTextField({
    Key? key,
    required this.hint,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.93,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: ColorPalette.primaryColor,
        style: GoogleFonts.firaCode(
          color: ColorPalette.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: ColorPalette.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: ColorPalette.white, width: 2),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.firaCode(
            color: ColorPalette.light.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
