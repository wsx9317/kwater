import 'package:flutter/material.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdSpace.dart';

// import 'package:syncfusion_flutter_sliders/sliders.dart';

class ZoomValueController {
  _IdValueBarState? _state;

  void _setState(_IdValueBarState state) {
    _state = state;
  }
}

class IdValueBar extends StatefulWidget {
  final ZoomValueController controller;
  final Function(dynamic)? onChanged;
  final double value;
  final double valueMin;
  final double valueMax;
  final Color activeColor;
  const IdValueBar({
    Key? key,
    required this.controller,
    this.onChanged,
    required this.value,
    required this.activeColor,
    required this.valueMax,
    required this.valueMin,
  }) : super(key: key);

  @override
  State<IdValueBar> createState() => _IdValueBarState();
}

class _IdValueBarState extends State<IdValueBar> {
  @override
  void initState() {
    super.initState();
    widget.controller._setState(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget barStandard() {
    return Row(
      children: [
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white40per,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white40per,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white40per,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white40per,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
        Container(
          width: 1,
          height: 5,
          color: IdColors.white,
        ),
        const IdSpace(spaceWidth: 16, spaceHeight: 0),
      ],
    );
  }

  /* Widget _valueController() {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: 70,
        height: 14,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          ...List.generate(
            15 * 2 - 1, // 아이템 수 + 간격 수를 고려
            (index) {
              if (index.isEven) {
                // 짝수 index는 실제 박스
                return Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: IdColors.waterLevel2,
                    ),
                  ),
                );
              } else {
                // 홀수 index는 간격
                return SizedBox(width: 2);
              }
            },
          ),
        ],
        ),
      ),
    ]);
  }
 */
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Column(
        children: [
          barStandard(),
          Stack(
            children: [
              const SizedBox(
                width: 150,
                height: 20,
              ),
              SizedBox(
                width: 180,
                height: 20,
                child: SfSlider(
                  max: widget.valueMax,
                  min: widget.valueMin,
                  value: widget.value,
                  interval: 20,
                  activeColor: widget.activeColor,
                  inactiveColor: IdColors.white40per,
                  minorTicksPerInterval: 1,
                  onChanged: widget.onChanged,
                ),
              ),
            ],
          ),
          barStandard(),
        ],
      ),
    );
  }

  /* Widget build(BuildContext context) {
    return Container(
      width: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              width: 70,
              height: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  widget.totalNum,
                  (index) => Row(
                    children: [
                      (index == widget.indexNum)
                          ? IdImgBox1(
                              imagePath: widget.valueIconPath,
                              imageFit: BoxFit.fitHeight)
                          : Container(
                              width: widget.valueWidth,
                              height: widget.valueHeight,
                              decoration: BoxDecoration(
                                color: widget.valueColor,
                              ),
                            ),
                      SizedBox(
                        width: (index == 14) ? 0 : 2,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
          Positioned(
            top: -3,
            right: 0,
            left: 0,
            child: SizedBox(
              width: 100,
              height: 14,
              child: SfSlider(
                max: 15,
                min: 1,
                value: widget.value,
                activeColor: IdColors.invisiable,
                inactiveColor: IdColors.red,
                minorTicksPerInterval: 1,
                onChanged: widget.onChanged,
                thumbIcon: IdImgBox1(
                    imagePath: 'assets/img/icon_value01.png',
                    imageFit: BoxFit.fitHeight),
              ),
            ),
          ),
        ],
      ),
    );
  } */
}
