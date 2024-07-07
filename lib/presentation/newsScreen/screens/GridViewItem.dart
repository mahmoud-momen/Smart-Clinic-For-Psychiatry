import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/categoriesModel/CategoriesModel.dart';



// ignore: must_be_immutable
class GridViewItemWidget extends StatelessWidget {
  GridViewItemWidget(
      {super.key,
      // required this.onSaved,
      required this.catergorieModel,
      required this.index,
      required this.OnClick});
  CatergorieModel? catergorieModel;
  int index;
  Function OnClick;
  // Function onSaved;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OnClick(
          catergorieModel,
        );

      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 7),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomRight: index.isEven
                ? const Radius.circular(0)
                : const Radius.circular(20),
            bottomLeft: index.isEven ? const Radius.circular(20) : Radius.zero,
          ),
          color: catergorieModel!.color,

        ),
        child: Text(
          catergorieModel!.name,
          style: GoogleFonts.exo(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
