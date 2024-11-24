import 'package:flutter/material.dart';
import 'package:tangullo/ui/common/color_extension.dart';

class Faces extends StatelessWidget {
  const Faces(
      {super.key,
      required this.title,
      required this.assetName,
      required this.colorName,
      required Color textColor});

  final String title;
  final String assetName;
  final Color colorName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 69.58,
          height: 72.95,
          decoration: BoxDecoration(
            color: colorName,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Image.asset(assetName),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: TColor.textSecondary,
          ),
        )
      ],
    );
  }
}
