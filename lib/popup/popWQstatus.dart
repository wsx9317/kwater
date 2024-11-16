import 'package:flutter/material.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class PopWqStatus extends StatelessWidget {
  final String title;
  final double averageWq;
  final double maxWq;
  final double minWq;
  final Widget slideWidget;
  final Widget standartWidget;

  PopWqStatus(
      {super.key,
      required this.title,
      required this.averageWq,
      required this.maxWq,
      required this.minWq,
      required this.slideWidget,
      required this.standartWidget});

  List<String> wqStandardList = ['평균', '최대', '최소'];

  Widget sliderStandard(Function() onBtnPressed, Color standardColor) {
    return IdBtn(
        onBtnPressed: onBtnPressed,
        childWidget: Container(
          width: 1,
          height: 5,
          color: standardColor,
        ));
  }

  String wqLevelStr(String standardStr, double standartDouble) {
    String result = '';
    String envStr = standartDouble.toString();
    double env = 0;
      if (envStr.split('.').isNotEmpty) {
        if (envStr.split('.').length > 2) {
          env = double.parse(standartDouble.toStringAsFixed(2));
        } else {
          env = standartDouble;
        }
      } else {
        env = standartDouble;
      }
    if (standartDouble >= 10) {
      result = '$standardStr $env';
    } else {
      result = '$standardStr $env';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 316,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: IdColors.black40Per,
          border: Border.all(
            width: 1,
            color: IdColors.white16per,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          uiCommon.styledText(
              title, 15, 0, 1, FontWeight.w700, IdColors.white, TextAlign.left),
         IdSpace(spaceWidth: 0, spaceHeight: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: slideWidget,
          ),
          IdSpace(spaceWidth: 0, spaceHeight: 8),
          //슬라이드바 기준점
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                standartWidget,
                IdSpace(spaceWidth: 0, spaceHeight: 4),
                Row(
                  children: [
                    uiCommon.styledText('-3', 12, 0, 2, FontWeight.w700,
                        IdColors.white, TextAlign.center),
                    const Spacer(),
                    uiCommon.styledText('0', 12, 0, 2, FontWeight.w700,
                        IdColors.white, TextAlign.center),
                    const Spacer(),
                    uiCommon.styledText('+3', 12, 0, 2, FontWeight.w700,
                        IdColors.white, TextAlign.center),
                  ],
                )
              ],
            ),
          ),
          IdSpace(spaceWidth: 0, spaceHeight: 8),
          Row(
            children: [
              uiCommon.styledText(wqLevelStr(wqStandardList[0], averageWq), 15,
                  0, 1, FontWeight.w400, IdColors.white, TextAlign.left),
              const IdSpace(spaceWidth: 6, spaceHeight: 0),
              uiCommon.styledText(wqLevelStr(wqStandardList[1], maxWq), 15, 0,
                  1, FontWeight.w400, IdColors.red, TextAlign.left),
              const IdSpace(spaceWidth: 6, spaceHeight: 0),
              uiCommon.styledText(wqLevelStr(wqStandardList[2], minWq), 15, 0,
                  1, FontWeight.w400, IdColors.blue, TextAlign.left),
            ],
          )
        ],
      ),
    );
  }
}
