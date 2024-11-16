import 'package:flutter/material.dart';
import 'package:kwater/id_widget/IdColor.dart';

class IdGradiationbar extends StatefulWidget {
  final double width;
  final double height;
  final List<Color> colorList;
  const IdGradiationbar({super.key, required this.width, required this.height, required this.colorList});

  @override
  State<IdGradiationbar> createState() => _IdGradiationbarState();
}

class _IdGradiationbarState extends State<IdGradiationbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.colorList,
        ),
        border: Border.all(width: 1, color: IdColors.white16per),
      ),
    );
  }
}
