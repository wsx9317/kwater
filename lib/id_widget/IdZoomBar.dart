import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdSpace.dart';

// import 'package:syncfusion_flutter_sliders/sliders.dart';

class IdZoombar extends StatefulWidget {
  final double valeu;
  final Function(int, dynamic, dynamic)? onChanged;
  const IdZoombar({
    super.key,
    required this.valeu,
    this.onChanged,
  });

  @override
  State<IdZoombar> createState() => _IdZoombarState();
}

class _IdZoombarState extends State<IdZoombar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget standardWidget() {
    return SizedBox(
      width: 5,
      height: 87,
      child: Column(
        children: [
          Container(
            width: 5,
            height: 1,
            color: IdColors.white,
          ),
          const Spacer(),
          Container(
            width: 5,
            height: 1,
            color: IdColors.white40per,
          ),
          const Spacer(),
          Container(
            width: 5,
            height: 1,
            color: IdColors.white40per,
          ),
          const Spacer(),
          Container(
            width: 5,
            height: 1,
            color: IdColors.white,
          ),
          const Spacer(),
          Container(
            width: 5,
            height: 1,
            color: IdColors.white40per,
          ),
          const Spacer(),
          Container(
            width: 5,
            height: 1,
            color: IdColors.white40per,
          ),
          const Spacer(),
          Container(
            width: 5,
            height: 1,
            color: IdColors.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: IdColors.white16per,
          ),
          right: BorderSide(
            width: 1,
            color: IdColors.white16per,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Stack(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: SizedBox(
                width: 40,
                height: 100,
                child: FlutterSlider(
                  values: [widget.valeu],
                  axis: Axis.vertical,
                  rtl: true,
                  min: 0,
                  max: 6,
                  handlerHeight: 15,
                  trackBar: FlutterSliderTrackBar(
                    inactiveTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: IdColors.white40per,
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
                        decoration: BoxDecoration(shape: BoxShape.circle, color: IdColors.skyblue),
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
            ),
            Positioned(
              top: 6,
              child: SizedBox(
                width: 40,
                child: Row(
                  children: [
                    IdSpace(spaceWidth: 7, spaceHeight: 0),
                    standardWidget(),
                    Spacer(),
                    standardWidget(),
                    IdSpace(spaceWidth: 7, spaceHeight: 0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
