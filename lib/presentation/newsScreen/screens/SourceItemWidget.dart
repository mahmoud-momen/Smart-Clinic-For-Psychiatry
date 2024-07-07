import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';



class SourceItemWidget extends StatelessWidget {
  SourceItemWidget({
    super.key,
    required this.isSelected,
    required this.txt,
  });
  String txt;
  bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? MyTheme.primaryLight : Colors.white,
        border: Border.all(color: MyTheme.primaryLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        txt,
        style: GoogleFonts.exo(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.green,
        ),
      ),
    );
  }
}
