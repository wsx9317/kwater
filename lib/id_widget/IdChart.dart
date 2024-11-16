import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdColor.dart';

class Idchart extends StatefulWidget {
  final List<FlSpot> chartData;
  final bool gridDataVisible;
  final FlGridData? flGridData;
  final bool leftSideTitlesVisible;
  final bool topSideTitlesVisible;
  final bool rightSideTitlesVisible;
  final bool bottomSideTitlesVisible;
  final List<double> reservedSize;
  final List<double> interval;
  final Widget Function(double, TitleMeta) leftCharSide;
  final Widget Function(double, TitleMeta) topCharSide;
  final Widget Function(double, TitleMeta) rightCharSide;
  final Widget Function(double, TitleMeta) bottomCharSide;
  final bool chartBorderVisible;
  final Border chartBorder;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final Color chartColor1;
  final Color chartColor2;
  final bool isCurved;
  final double chartLineWidth;
  final bool isStrokeCapRound;
  final bool dotData;
  final bool belowBarData;
  final AlignmentGeometry? beginGradient;
  final AlignmentGeometry? endGradient;
  final double chartWidth;
  final double chartHeight;
  const Idchart({
    super.key,
    required this.chartData,
    required this.gridDataVisible,
    this.flGridData,
    required this.leftSideTitlesVisible,
    required this.topSideTitlesVisible,
    required this.rightSideTitlesVisible,
    required this.bottomSideTitlesVisible,
    required this.leftCharSide,
    required this.topCharSide,
    required this.rightCharSide,
    required this.bottomCharSide,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.chartColor1,
    required this.chartColor2,
    required this.isCurved,
    required this.chartLineWidth,
    required this.isStrokeCapRound,
    required this.dotData,
    required this.belowBarData,
    this.beginGradient,
    this.endGradient,
    required this.chartWidth,
    required this.chartHeight,
    required this.reservedSize,
    required this.interval,
    required this.chartBorderVisible,
    required this.chartBorder,
  });

  @override
  State<Idchart> createState() => _IdchartState();
}

class _IdchartState extends State<Idchart> {
  List<Color> chartColors = [];
  @override
  void initState() {
    super.initState();
    chartColors = [
      widget.chartColor1,
      widget.chartColor2,
    ];
  }

  LineChartData mainData() {
    return LineChartData(
      //데이터 눈금자
      gridData: widget.gridDataVisible ? widget.flGridData! : FlGridData(show: widget.gridDataVisible),
      //x축, y축 숫자 혹은 텍스트 표시
      titlesData: FlTitlesData(
        show: true,
        leftTitles: widget.leftSideTitlesVisible
            ? AxisTitles(
                sideTitles: SideTitles(
                  showTitles: widget.leftSideTitlesVisible,
                  reservedSize: 30,
                  interval: widget.interval[0],
                  getTitlesWidget: widget.leftCharSide,
                  maxIncluded: true,
                  minIncluded: true,
                ),
              )
            : AxisTitles(
                sideTitles: SideTitles(showTitles: widget.leftSideTitlesVisible),
              ),
        topTitles: widget.topSideTitlesVisible
            ? AxisTitles(
                sideTitles: SideTitles(
                  showTitles: widget.topSideTitlesVisible,
                  reservedSize: widget.reservedSize[1],
                  interval: widget.interval[1],
                  getTitlesWidget: widget.topCharSide,
                ),
              )
            : AxisTitles(
                sideTitles: SideTitles(showTitles: widget.topSideTitlesVisible),
              ),
        rightTitles: widget.rightSideTitlesVisible
            ? AxisTitles(
                sideTitles: SideTitles(
                  showTitles: widget.rightSideTitlesVisible,
                  reservedSize: widget.reservedSize[2],
                  interval: widget.interval[2],
                  getTitlesWidget: widget.rightCharSide,
                ),
              )
            : AxisTitles(
                sideTitles: SideTitles(showTitles: widget.rightSideTitlesVisible),
              ),
        bottomTitles: widget.bottomSideTitlesVisible
            ? AxisTitles(
                sideTitles: SideTitles(
                  showTitles: widget.bottomSideTitlesVisible,
                  reservedSize: widget.reservedSize[3],
                  interval: widget.interval[3],
                  getTitlesWidget: widget.bottomCharSide,
                ),
              )
            : AxisTitles(
                sideTitles: SideTitles(showTitles: widget.bottomSideTitlesVisible),
              ),
      ),
      //껍데기 border
      borderData: FlBorderData(show: widget.chartBorderVisible, border: widget.chartBorder),
      //xy 최소, 최대값
      minX: widget.minX,
      maxX: widget.maxX,
      minY: widget.minY,
      maxY: widget.maxY,
      //데이터
      lineBarsData: [
        //데이터 들어갈곳
        LineChartBarData(
          //데이터 값
          spots: widget.chartData,
          //곡선 유무(false 이면 꺾은선 그래프가 됨)
          isCurved: widget.isCurved,
          //선 굵기
          barWidth: widget.chartLineWidth,
          //선 색상
          color: widget.chartColor1,
          //꺽은선 round하게 할껀지에 대한 부분
          isStrokeCapRound: widget.isStrokeCapRound,
          //데이터 값마다 점찍기
          dotData: FlDotData(
            show: widget.dotData,
          ),
          //데이터 값까지의 범위영역
          belowBarData: widget.belowBarData
              ? BarAreaData(
                  show: widget.belowBarData,
                  gradient: LinearGradient(
                    begin: widget.beginGradient!,
                    end: widget.endGradient!,
                    colors: chartColors,
                  ),
                )
              : BarAreaData(
                  show: widget.belowBarData,
                ),
        ),
      ],
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: widget.chartWidth,
              height: widget.chartHeight,
              child: LineChart(
                mainData(),
                duration: Duration.zero,
              ),
            ),
            //최소
            Positioned(
              bottom: 60,
              child:uiCommon.styledText('${widget.minY.toStringAsFixed(1)}', 10, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.right) 
            ),
            Positioned(
              top: 0,
              child:uiCommon.styledText('${widget.maxY.toStringAsFixed(1)}', 10, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.right) 
            ),
          ],
        ),
      ],
    );
  }
}
