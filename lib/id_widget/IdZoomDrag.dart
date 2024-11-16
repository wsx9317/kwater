import 'package:flutter/material.dart';
import 'package:kwater/common/globalvar.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'dart:math';

class ZoomDragController {
  _IdZoomdragState? _state;

  void _setState(_IdZoomdragState state) {
    _state = state;
  }

  void zoomIn() {
    _state?._handleZoom(1.1);
  }

  void zoomOut() {
    _state?._handleZoom(0.9);
  }

  //막대그래프 컨트롤러 이동으로 줌인,줌아웃
  void zoomInMulty(double multyCnt) {
    _state?._handleZoomMulty(1.1, multyCnt);
  }

  void zoomOutMulty(double multyCnt) {
    _state?._handleZoomMulty(0.9, multyCnt);
  }
}

class IdZoomdrag extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;
  final double contentWidth;
  final double contentHeight;
  final ZoomDragController controller;
  final List<Widget> children;

  const IdZoomdrag({
    Key? key,
    required this.windowWidth,
    required this.windowHeight,
    required this.contentWidth,
    required this.contentHeight,
    required this.controller,
    this.children = const [],
  }) : super(key: key);

  @override
  State<IdZoomdrag> createState() => _IdZoomdragState();
}

class _IdZoomdragState extends State<IdZoomdrag> {
  double _scale = 1.0;
  final Offset _focalPoint = Offset.zero;
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.controller._setState(this);
    // double result = pow(1.1, 3.0).toDouble();
    // _handleZoom(result);
  }

  void _handleZoom(double zoomFactor) {
    _scale *= zoomFactor;
    _scale = _scale.clamp(1.0, 2.0);
    GV.pStrg.putXXX(key_scale_value, _scale.toString());
    setState(() {
      double newOffsetX = _offset.dx;
      double newOffsetY = _offset.dy;
      double minX = widget.windowWidth - widget.contentWidth * _scale;
      double maxX = 0.0;
      double minY = widget.windowHeight - widget.contentHeight * _scale;
      double maxY = 0.0;
      _offset = Offset(
        newOffsetX.clamp(minX, maxX),
        newOffsetY.clamp(minY, maxY),
      );
    });
    // print("_scale : " + _scale.toString());
  }

  void _handleZoomMulty(double zoomFactor, double multyCnt) {
    double result = pow(zoomFactor, multyCnt).toDouble();
    _scale *= result;
    _scale = _scale.clamp(1.0, 2.0);
    GV.pStrg.putXXX(key_scale_value, _scale.toString());
    setState(() {
      double newOffsetX = _offset.dx;
      double newOffsetY = _offset.dy;
      double minX = widget.windowWidth - widget.contentWidth * _scale;
      double maxX = 0.0;
      double minY = widget.windowHeight - widget.contentHeight * _scale;
      double maxY = 0.0;
      _offset = Offset(
        newOffsetX.clamp(minX, maxX),
        newOffsetY.clamp(minY, maxY),
      );
    });
    print("_scale : " + _scale.toString());
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      double newOffsetX = _offset.dx + details.delta.dx;
      double newOffsetY = _offset.dy + details.delta.dy;

      double minX = widget.windowWidth - widget.contentWidth * _scale;
      double maxX = 0.0;

      double minY = widget.windowHeight - widget.contentHeight * _scale;
      double maxY = 0.0;

      _offset = Offset(
        newOffsetX.clamp(minX, maxX),
        newOffsetY.clamp(minY, maxY),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var stacklist = Stack(children: widget.children);

    return SizedBox(
      width: widget.windowWidth,
      height: widget.windowHeight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: widget.contentWidth,
            height: widget.contentHeight,
            child: GestureDetector(
              onPanUpdate: _handlePanUpdate,
              child: Center(
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(_offset.dx, _offset.dy)
                    ..translate(_focalPoint.dx, _focalPoint.dy)
                    ..scale(_scale)
                    ..translate(-_focalPoint.dx, -_focalPoint.dy),
                  child: Stack(
                    children: [
                      Container(
                          width: widget.contentWidth,
                          height: widget.contentHeight,
                          color: IdColors.invisiable),
                      stacklist,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
