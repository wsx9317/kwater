import 'package:flutter/material.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';

class Zoom2 extends StatelessWidget {
  Zoom2({super.key});

  InteractiveViewer? zoomViewer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: InteractiveViewer(
        constrained: true, //true : zoom기능 가능, false: 줌이 안됨
        child: Stack(
          children: [
            const IdImgBox1(
                imageWidth: double.infinity, imageHeight: double.infinity, imagePath: 'assets/img/img1.jpg', imageFit: BoxFit.cover),
            Positioned(
              top: 100,
              left: 100,
              child: Container(
                width: 100,
                height: 100,
                color: IdColors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
