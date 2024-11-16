import 'package:flutter/material.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';

class IdClosebtn extends StatelessWidget {
  final Function() onBtnPressed;
  const IdClosebtn({super.key, required this.onBtnPressed});

  @override
  Widget build(BuildContext context) {
    return IdBtn(
      onBtnPressed: onBtnPressed,
      childWidget: const IdImgBox1(imageWidth: 24, imageHeight: 24, imagePath: "assets/img/icon_close.png", imageFit: BoxFit.cover),
    );
  }
}
