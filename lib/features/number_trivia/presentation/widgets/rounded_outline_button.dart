import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberia/core/common/themes/color_palette.dart';

class RoundedOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RoundedOutlineButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      minWidth: MediaQuery.of(context).size.width * 0.5,
      height: 56,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: ColorPalette.white,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.firaCode(
          color: ColorPalette.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
