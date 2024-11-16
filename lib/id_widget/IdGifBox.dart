import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class IdGifBox extends StatefulWidget {
  final double? imageWidth;
  final double? imageHeight;
  final String imagePath;
  const IdGifBox({
    Key? key,
    this.imageWidth,
    this.imageHeight,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<IdGifBox> createState() => _IdGifBoxState();
}

class _IdGifBoxState extends State<IdGifBox> {
  final controller = GifController();
  @override
  Widget build(BuildContext context) {
    return GifView.asset(
      widget.imagePath,
      width: widget.imageWidth,
      height: widget.imageHeight,
      frameRate: 30,
      controller: controller,
    );
  }
}
