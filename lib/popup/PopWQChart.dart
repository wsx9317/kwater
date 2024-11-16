import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSlideChart.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class PopWQchart extends StatefulWidget {
  final int areaNum;
  final Widget cloesWidget;
  final List<FlSpot> chartData;
  final Color areaColor;
  final List<Color> gradationColors;
  final double dayOfMonthLength;
  final List<String> chartX;
  final int filter;
  final Function() filterBtn1;
  final Function() filterBtn2;
  const PopWQchart({
    super.key,
    required this.areaNum,
    required this.cloesWidget,
    required this.chartData,
    required this.areaColor,
    required this.gradationColors,
    required this.dayOfMonthLength,
    required this.chartX,
    required this.filter,
    required this.filterBtn1,
    required this.filterBtn2,
  });

  @override
  State<PopWQchart> createState() => _PopWQchartState();
}

class _PopWQchartState extends State<PopWQchart> {
  
  @override
  void initState() {
    super.initState();
  }

  int getLastDayOfCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayCurrentMonth =
        firstDayNextMonth.subtract(Duration(days: 1));
    return lastDayCurrentMonth.day;
  }

  //클로로필
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );
    String text;
    switch (value.toInt()) {
      case -10:
        text = "-10";
        break;
      case 0:
        text = "0";
        break;
      case 10:
        text = "10";
        break;
      case 20:
        text = "20";
        break;
      case 30:
        text = "30";
        break;
      case 40:
        text = "40";
        break;
      case 50:
        text = "50";
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  //x축 글귀
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(widget.chartX[0], style: style);
        break;
      case 1:
        text = Text(widget.chartX[1], style: style);
        break;
      case 2:
        text = Text(widget.chartX[2], style: style);
        break;
      case 3:
        text = Text(widget.chartX[3], style: style);
        break;
      case 4:
        text = Text(widget.chartX[4], style: style);
        break;
      case 5:
        text = Text(widget.chartX[5], style: style);
        break;
      case 6:
        text = Text(widget.chartX[6], style: style);
        break;
      case 7:
        text = Text(widget.chartX[7], style: style);
        break;
      case 8:
        text = Text(widget.chartX[8], style: style);
        break;
      case 9:
        text = Text(widget.chartX[9], style: style);
        break;
      case 10:
        text = Text(widget.chartX[10], style: style);
        break;
      case 11:
        text = Text(widget.chartX[11], style: style);
        break;
      case 12:
        text = Text(widget.chartX[12], style: style);
        break;
      case 13:
        text = Text(widget.chartX[13], style: style);
        break;
      case 14:
        text = Text(widget.chartX[14], style: style);
        break;
      case 15:
        text = Text(widget.chartX[15], style: style);
        break;
      case 16:
        text = Text(widget.chartX[16], style: style);
        break;
      case 17:
        text = Text(widget.chartX[17], style: style);
        break;
      case 18:
        text = Text(widget.chartX[18], style: style);
        break;
      case 19:
        text = Text(widget.chartX[19], style: style);
        break;
      case 20:
        text = Text(widget.chartX[20], style: style);
        break;
      case 21:
        text = Text(widget.chartX[21], style: style);
        break;
      case 22:
        text = Text(widget.chartX[22], style: style);
        break;
      case 23:
        text = Text(widget.chartX[23], style: style);
        break;
      case 24:
        text = Text(widget.chartX[24], style: style);
        break;
      case 25:
        text = Text(widget.chartX[25], style: style);
        break;
      case 26:
        text = Text(widget.chartX[26], style: style);
        break;
      case 27:
        text = Text(widget.chartX[27], style: style);
        break;
      case 28:
        text = Text(widget.chartX[28], style: style);
        break;
      case 29:
        text = Text(widget.chartX[29], style: style);
        break;
      case 30:
        text = Text(widget.chartX[30], style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget changeFilter(
    String title,
    Function() onBtnPressed,
    int filterNum,
  ) {
    return IdBtn(
      onBtnPressed: onBtnPressed,
      childWidget: Row(
        children: [
          IdImgBox1(
              imageWidth: 20,
              imageHeight: 20,
              imagePath: (widget.filter == filterNum)
                  ? 'assets/img/icon-check-active.png'
                  : 'assets/img/icon-check.png',
              imageFit: BoxFit.cover),
          IdSpace(spaceWidth: 5, spaceHeight: 0),
          uiCommon.styledText(
              title,
              15,
              0,
              1,
              FontWeight.w700,
              (widget.filter == filterNum) ? IdColors.skyblue : IdColors.white40per,
              TextAlign.left)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 540,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: IdColors.black40Per,
          border: Border.all(
            width: 1,
            color: IdColors.black16Per,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          Row(
            children: [
              changeFilter("클로로필 -α", widget.filterBtn1, 1),
              const IdSpace(spaceWidth: 8, spaceHeight: 0),
              changeFilter("피코시아닌 (ppb)", widget.filterBtn2, 2),
              const Expanded(child: SizedBox()),
              widget.cloesWidget
            ],
          ),
          const IdSpace(spaceWidth: 0, spaceHeight: 16),
          //차트
          Idslidechart(
              chartData: widget.chartData,
              areaColor: widget.areaColor,
              gradationColors: widget.gradationColors,
              getBottomTitlesWidget: bottomTitleWidgets,
              getLeftTitlesWidget: leftTitleWidgets,
              minX: 0,
              maxX: widget.dayOfMonthLength,
              minY: -10,
              maxY: 60,
              contentWidth: 437,
              contentHeight: 186,
              thumbColor: IdColors.white70per,
              trackColor: IdColors.white10per,
              thumbVisibility: true,
              trackVisibility: true,
              chartWidth: 1200,
              chartHeight: 164),
          //차트
        ],
      ),
    );
  }
}
