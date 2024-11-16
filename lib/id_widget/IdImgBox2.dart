import 'package:flutter/material.dart';

//URL 이미지 controller
class IdImgBox2 extends StatefulWidget {
  final double? imageWidth;
  final double? imageHeight;
  final double? round;
  final String imagePath;
  final BoxFit imageFit;
  const IdImgBox2({
    super.key,
    this.imageWidth,
    this.imageHeight,
    this.round,
    required this.imagePath,
    required this.imageFit,
  });

  @override
  State<IdImgBox2> createState() => _IdImgBox2State();
}

class _IdImgBox2State extends State<IdImgBox2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.imageWidth,
      height: widget.imageHeight,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.imagePath),
          fit: widget.imageFit,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.round!)),
      ),
    );
  }
}
