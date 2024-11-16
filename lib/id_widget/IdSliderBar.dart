import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:kwater/id_widget/IdColor.dart';

class SliderBarController {
  _IdsliderbarState? _state;

  void _setState(_IdsliderbarState state) {
    _state = state;
  }
}

class Idsliderbar extends StatefulWidget {
  // final SliderBarController controller;
  final double valeu;
  final Axis axis;
  final double max;
  final double min;
  // final double interval;
  // final Color activeColor;
  // final Color inactiveColor;
  // final int minorTicksPerInterval;
  final Function(int, dynamic, dynamic)? onChanged;
  const Idsliderbar({
    super.key,
    // required this.controller,
    required this.valeu,
    required this.axis,
    required this.max,
    required this.min,
    // required this.interval,
    // required this.activeColor,
    // required this.inactiveColor,
    // required this.minorTicksPerInterval,
    this.onChanged,
  });

  @override
  State<Idsliderbar> createState() => _IdsliderbarState();
}

class _IdsliderbarState extends State<Idsliderbar> {
  @override
  // void initState() {
  //   super.initState();
  //   widget.controller._setState(this);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        child: FlutterSlider(
          values: [widget.valeu],
          axis: widget.axis,
          min: widget.min,
          max: widget.max,
          handlerHeight: 10,
          trackBar: FlutterSliderTrackBar(
            inactiveTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: IdColors.white16per,
              border: Border.all(width: 1),
            ),
            activeTrackBar: BoxDecoration(color: IdColors.skyblue),
          ),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Material(
              type: MaterialType.canvas,
              color: IdColors.invisiable,
              elevation: 3,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: IdColors.skyblue
                ),
              ),
            ),
          ),
          onDragging: widget.onChanged,
          tooltip: FlutterSliderTooltip(
            disabled: true,
          ),
          jump: true,
          touchSize: 22,
        ),
      ),
    );
  }
}
