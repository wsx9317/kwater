import 'dart:ui';

class BoxCustom {
  final int id;
  final Color? color;
  final Color lineColor;
  final List<Offset> data;
  VoidCallback? onClick;

  BoxCustom({
    required this.lineColor,
    required this.id,
    required this.data,
    this.color,
    this.onClick,
  });
}
