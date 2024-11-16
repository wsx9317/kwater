import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kwater/id_widget/IdColor.dart';

class Idslidechart extends StatefulWidget {
  final List<FlSpot> chartData;
  final Color areaColor;
  final List<Color> gradationColors;
  final Widget Function(double, TitleMeta) getLeftTitlesWidget;
  final Widget Function(double, TitleMeta) getBottomTitlesWidget;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final double contentWidth;
  final double contentHeight;
  final Color thumbColor;
  final Color trackColor;
  final bool thumbVisibility;
  final bool trackVisibility;
  final double chartWidth;
  final double chartHeight;

  const Idslidechart({
    super.key,
    required this.chartData,
    required this.areaColor,
    required this.gradationColors,
    required this.getLeftTitlesWidget,
    required this.getBottomTitlesWidget,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.contentWidth,
    required this.contentHeight,
    required this.thumbColor,
    required this.trackColor,
    required this.thumbVisibility,
    required this.trackVisibility,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  State<Idslidechart> createState() => _IdslidechartState();
}

class _IdslidechartState extends State<Idslidechart> {
  ScrollController _scrollController = ScrollController();
  List<Color> gradientColors = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  LineChartData mainData() {
    gradientColors = widget.gradationColors;
    return LineChartData(
      //데이터 눈금자
      gridData: const FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          verticalInterval: 1,
          horizontalInterval: 10),
      //x축, y축 숫자 혹은 텍스트 표시
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 31,
            interval: 1,
            getTitlesWidget: widget.getBottomTitlesWidget,
          ),
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: true,
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: widget.getLeftTitlesWidget,
          ),
        ),
      ),
      //껍데기 border
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(width: 1, color: IdColors.white70per),
          left: BorderSide(width: 1, color: IdColors.white70per),
        ),
      ),
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
          isCurved: false,
          //선 굵기
          barWidth: 3,
          //선 색상
          color: widget.areaColor,
          //꺽은선 round하게 할껀지에 대한 부분
          isStrokeCapRound: true,
          //데이터 값마다 점찍기
          dotData: const FlDotData(
            show: false,
          ),
          //데이터 값까지의 범위영역
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.contentWidth,
      height: widget.contentHeight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(widget.thumbColor), // 스크롤바 색상
            trackColor: WidgetStateProperty.all(widget.trackColor), // 트랙 색상
            radius: const Radius.circular(10),
            thickness: WidgetStateProperty.all(4),
          ),
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: widget.thumbVisibility,
                trackVisibility: widget.trackVisibility,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, bottom: 18, top: 40, right: 50),
                    child: SizedBox(
                      width: widget.chartWidth, // 충분히 넓게 설정
                      height: widget.chartHeight,
                      child: LineChart(
                        mainData(),
                        duration: Duration.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
