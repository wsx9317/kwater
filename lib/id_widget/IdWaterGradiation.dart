import 'package:flutter/material.dart';

import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdGradiationBar.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class IdWatergradiation extends StatefulWidget {
  final double width;
  final double gradiationHeight;
  final EdgeInsetsGeometry padding;
  final bool showTitle;
  final String? gradationStr;
  final double max;
  final double min;
  final double mean;
  const IdWatergradiation({
    Key? key,
    required this.width,
    required this.padding,
    required this.gradiationHeight,
    required this.showTitle,
    this.gradationStr,
    required this.max,
    required this.min,
    required this.mean,
  }) : super(key: key);

  @override
  State<IdWatergradiation> createState() => _IdWatergradiationState();
}

class _IdWatergradiationState extends State<IdWatergradiation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 204,
      padding: widget.padding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: IdColors.white16per),
        color: IdColors.black40Per,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Visibility(
              visible: widget.showTitle,
              child: Column(
                children: [
                  uiCommon.styledText(widget.gradationStr ?? '', 12, -0.02, 1, FontWeight.w500, IdColors.white, TextAlign.center),
                  IdSpace(spaceWidth: 0, spaceHeight: 16)
                ],
              )),
          Row(
            children: [
              const Spacer(),
              IdGradiationbar(width: 6, height: widget.gradiationHeight, colorList: const [
                IdColors.waterLevel1,
                IdColors.waterLevel2,
                IdColors.waterLevel3,
                IdColors.waterLevel4,
                IdColors.waterLevel5,
                IdColors.waterLevel6,
                IdColors.waterLevel7,
                IdColors.waterLevel8,
              ]),
              const IdSpace(spaceWidth: 8, spaceHeight: 0),
              SizedBox(
                height: widget.gradiationHeight,
                child: Column(
                  children: [
                    uiCommon.styledText(widget.max.toString(), 12, 0, 1, FontWeight.w500, IdColors.white, TextAlign.center),
                    const Spacer(),
                    uiCommon.styledText(widget.mean.toString(), 12, 0, 1, FontWeight.w500, IdColors.white, TextAlign.center),
                    const Spacer(),
                    uiCommon.styledText(widget.min.toString(), 12, 0, 1, FontWeight.w500, IdColors.white, TextAlign.center),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
