// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';

import '../model/BoxCustom.dart';

class PolygonPainter extends CustomPainter {
  final List<BoxCustom> boxPoints;
  final Function(BoxCustom)? onBoxClick; // 클릭 이벤트 핸들러 추가

  PolygonPainter(this.boxPoints, {this.onBoxClick});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final paintFill = Paint()..style = PaintingStyle.fill;

    for (var points0 in boxPoints) {
      paint.color = points0.lineColor;
      paintFill.color = points0.color ?? Colors.transparent;

      final path = Path()..addPolygon(points0.data, true);
      canvas.drawPath(path, paintFill);
      canvas.drawPath(path, paint);
      canvas.save();
      canvas.clipPath(path);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedLinesPainter extends CustomPainter {
  final List<Offset>? robotPathHistory;

  DottedLinesPainter({this.robotPathHistory});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = IdColors.cyan.withOpacity(0.2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < robotPathHistory!.length - 1; i++) {
      canvas.drawLine(robotPathHistory![i], robotPathHistory![i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // 재페인트 필요 여부
  }
}

class IdPolygonWidget extends StatefulWidget {
  final Map<int, Map<int, BoxCustom>>? boxMapMap;
  final double topLeftLat;
  final double topLeftLng;
  final double bottomRightLat;
  final double bottomRightLng;
  final double imageWidth;
  final double imageHeight;
  final Color color;
  final bool showBackground;
  final bool showPolygon;
  final bool showDevice;
  final bool showIcon;
  final VoidCallback? onPolygonClick;
  final List<List<dynamic>>? polygonGrupList;
  final List<double>? robotPositionList;
  final List<Offset>? robotPathHistory;
  final double? deviceValue;

  IdPolygonWidget({
    Key? key,
    required this.boxMapMap,
    required this.topLeftLat,
    required this.topLeftLng,
    required this.bottomRightLat,
    required this.bottomRightLng,
    required this.imageWidth,
    required this.imageHeight,
    required this.color,
    required this.showBackground,
    required this.showPolygon,
    required this.showDevice,
    required this.showIcon,
    this.onPolygonClick,
    this.polygonGrupList,
    this.robotPositionList,
    this.robotPathHistory,
    this.deviceValue,
  }) : super(key: key);

  @override
  State<IdPolygonWidget> createState() => _IdPolygonWidgetState();
}

class _IdPolygonWidgetState extends State<IdPolygonWidget> {
  int mapLenth = 0;
  List<String> areaNmList = [];
  @override
  void initState() {
    super.initState();
  }

  String _generateAreaName(int index) {
    if (index < 26) {
      // A부터 Z까지
      return String.fromCharCode('A'.codeUnitAt(0) + index);
    } else {
      // AA, AB, AC, ... 형식으로 계속
      int firstChar = (index ~/ 26) - 1;
      int secondChar = index % 26;
      return '${String.fromCharCode('A'.codeUnitAt(0) + firstChar)}${String.fromCharCode('A'.codeUnitAt(0) + secondChar)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    mapLenth = widget.boxMapMap != null ? widget.boxMapMap![0]!.length : 0;
    areaNmList.clear();
    for (var i = 0; i < mapLenth; i++) {
      String areaName = _generateAreaName(i);
      areaNmList.add(areaName);
    }

    return Stack(
      key: ValueKey('polygonwidet123_stack'),
      children: [
        if (widget.showBackground)
          Positioned(
            key: ValueKey('polygonwidet123_positionbase'),
            left: 0,
            top: 0,
            child: Image.asset(
              'assets/img/map16x2.jpg',
              key: const ValueKey('polygonwidet123_map16x2_123'),
              width: widget.imageWidth,
              height: widget.imageHeight,
              fit: BoxFit.cover,
            ),
          ),
        if (widget.showDevice && mapLenth > 0)
        Positioned(
            top: 130,
            left: 813,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        ...List.generate(
                          3,
                          (index) {
                            return Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: IdColors.white16per,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    color: IdColors.black40Per,
                                  ),
                                  child: IdImgBox1(
                                    imageWidth: 20,
                                    imageHeight: 20,
                                    imagePath: (widget.deviceValue??0) == 0
                                        ? 'assets/img/icon-wind.png' // 데이터가 0일 때 PNG
                                        : 'assets/img/icon-wind.gif',
                                    imageFit: BoxFit.cover,
                                  ),
                                ),
                                if (index != 2)
                                  const SizedBox(
                                    width: 8,
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(
                          2,
                          (index) {
                            return Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: IdColors.white16per,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    color: IdColors.black40Per,
                                  ),
                                  child: IdImgBox1(
                                    imageWidth: 20,
                                    imageHeight: 20,
                                    imagePath: (widget.deviceValue??0)== 0
                                        ? 'assets/img/icon-wind.png' // 데이터가 0일 때 PNG
                                        : 'assets/img/icon-wind.gif',
                                    imageFit: BoxFit.cover,
                                  ),
                                ),
                                if (index !=
                                    2) // Spacer를 마지막 아이템 이후에는 추가하지 않음
                                  const SizedBox(
                                    width: 8,
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(width: 24),
                IdImgBox1(
                    imageWidth: 36,
                    imageHeight: 36,
                    imagePath:  (widget.deviceValue??0) == 0
                        ? 'assets/img/icon-block.png' // 데이터가 0일 때 PNG
                        : 'assets/img/icon-block.gif',
                    imageFit: BoxFit.cover),
              ],
            )),
        //수류 방향, 기기 아이콘
        if (widget.showIcon && mapLenth > 0)
          const Positioned(
            top: 718,
            left: 850,
            child: IdImgBox1(
                imageWidth: 32,
                imageHeight: 32,
                imagePath: "assets/img/icon_rising.png",
                imageFit: BoxFit.cover),
          ),
        CustomPaint(
          size: Size(widget.imageWidth, widget.imageHeight),
          painter:
              DottedLinesPainter(robotPathHistory: widget.robotPathHistory),
        ),
        (widget.robotPositionList != null && mapLenth > 0)
            ? Positioned(
                top: widget.robotPositionList![1] - 16,
                left: widget.robotPositionList![0] - 29,
                child: IdImgBox1(
                    imageWidth: 58,
                    imageHeight: 32,
                    imagePath: "assets/img/icon_robot.png",
                    imageFit: BoxFit.cover),
              )
            : SizedBox(),
        if (widget.showIcon && mapLenth > 0)
          const Positioned(
              key: ValueKey('polygonwidet123_position_flowicon'),
              top: 413,
              left: 1080,
              child: IdImgBox1(
                  key: ValueKey('polygonwidet123_flowicon'),
                  imageWidth: 32,
                  imageHeight: 32,
                  imagePath: "assets/img/icon_descent.png",
                  imageFit: BoxFit.cover)),
        if (widget.showPolygon && mapLenth > 0)
          CustomPaint(
            size: Size(widget.imageWidth, widget.imageHeight),
            painter: PolygonPainter(widget.boxMapMap![1]!.values.toList()),
          ),
        if (widget.showPolygon && mapLenth > 0)
          CustomPaint(
            size: Size(widget.imageWidth, widget.imageHeight),
            painter: PolygonPainter(widget.boxMapMap![0]!.values.toList()),
          ),

        if (widget.showPolygon && mapLenth > 0) ..._generatePolygonLabels1(),
        if (mapLenth > 0) ..._generatePolygonLabels2(),
        GestureDetector(
          key: ValueKey('polygonwidet123_gesture'),
          onTapUp: _handleTap,
          child: Container(
            key: ValueKey('polygonwidet123_gesture_container'),
            width: widget.imageWidth,
            height: widget.imageHeight,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  List<Widget> _generatePolygonLabels1() {
    return widget.boxMapMap![0]!.values.map((box) {
      Offset center = _calculatePolygonCenter(box.data);
      String labelText = '';
      if (widget.polygonGrupList != null &&
          box.id >= 0 &&
          box.id < widget.polygonGrupList!.length) {
        labelText = widget.polygonGrupList![box.id][1];
      }
      return Positioned(
        left: center.dx, // 텍스트 중앙 정렬을 위해 약간의 오프셋 적용
        top: center.dy,
        child: uiCommon.styledText(
            labelText,
            16, // 글자 크기를 조정
            0,
            1,
            FontWeight.w700,
            IdColors.white,
            TextAlign.center),
      );
    }).toList();
  }

  List<Widget> _generatePolygonLabels2() {
    return widget.boxMapMap![0]!.values.map((box) {
      // 폴리곤의 좌측 상단 좌표 찾기
      Offset topLeft = _findTopLeftCorner(box.data);
      String labelText = '';
      if (widget.polygonGrupList != null &&
          box.id >= 0 &&
          box.id < widget.polygonGrupList!.length) {
        labelText = widget.polygonGrupList![box.id][0];
      }
      return (labelText != '')
          ? Positioned(
              left: (box.id == 0) ? topLeft.dx + 16 : topLeft.dx,
              top: (box.id == 0) ? topLeft.dy + 30 : topLeft.dy,
              child: Container(
                width: 24,
                height: 24,
                color: IdColors.black70Per,
                child: Center(
                  child: uiCommon.styledText(
                      labelText,
                      16, // 글자 크기를 조정
                      0,
                      1,
                      FontWeight.w700,
                      IdColors.white,
                      TextAlign.center),
                ),
              ),
            )
          : SizedBox();
    }).toList();
  }

  Offset _calculatePolygonCenter(List<Offset> points) {
    double centerX =
        points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    double centerY =
        points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;
    return Offset(centerX, centerY);
  }

  Offset _findTopLeftCorner(List<Offset> points) {
    if (points.isEmpty) return Offset.zero;

    double minX = points[0].dx;
    double minY = points[0].dy;

    for (var point in points) {
      if (point.dx < minX) minX = point.dx;
      if (point.dy < minY) minY = point.dy;
    }

    return Offset(minX, minY);
  }

  void _handleTap(TapUpDetails details) {
    for (var box in widget.boxMapMap![0]!.values) {
      final path = Path()..addPolygon(box.data, true);
      if (path.contains(details.localPosition)) {
        GV.pStrg.putXXX(key_area_value, "${box.id}");
        widget.onPolygonClick?.call();
        break;
      }
    }
  }
}
