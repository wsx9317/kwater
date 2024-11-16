import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart';
import 'package:kwater/api/kwater_api.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdChart.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSpace.dart';
import 'package:kwater/model/Kwater.dart';
import 'package:kwater/model/apiResultKwater.dart';

class PopMornitoring extends StatefulWidget {
  final List<bool> chartShow;
  final Function() cloeseBtn1;
  final Function() cloeseBtn2;
  final Function() cloeseBtn3;

  const PopMornitoring({
    super.key,
    required this.chartShow,
    required this.cloeseBtn1,
    required this.cloeseBtn2,
    required this.cloeseBtn3,
  });

  @override
  State<PopMornitoring> createState() => _PopMornitoringState();
}

class _PopMornitoringState extends State<PopMornitoring> {
  List<bool> dropDownBoolList = [false, false, false]; // 드롭다운 상태
  List<String> dropHintList = []; // 드롭다운 값

  List<String> _items1 = [];
  List<String> _items2 = [];
  List<String> _items3 = [];

  List<FlSpot> chart1Data = [];
  List<FlSpot> chart2Data = [];
  List<FlSpot> chart3Data = [];

  List<String> chartTitleList = [];
  List<Widget> chartList = [];

  List _itemList = [];
  List<List<FlSpot>> chartDataList = [];

  List<List<double>> chartMinMaxAverList = [
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0]
  ];

  double max = 0;
  double min = 0;

  bool showChart = false;

  List<Color> chartColorList = [
    IdColors.waterLevel6,
    IdColors.waterLevel5,
    IdColors.waterLevel4,
  ];

  List<WaterFilter> filterList = [];
  WaterFilter selectedFilter1 = WaterFilter.temp_deg_c;
  WaterFilter selectedFilter2 = WaterFilter.ph_units;
  WaterFilter selectedFilter3 = WaterFilter.spcond_us_cm;

  @override
  void initState() {
    super.initState();
    itemList();
    _itemList = [_items1, _items2, _items3];
    dropHintList = [
      _items1[0],
      _items2[1],
      _items3[2],
    ];
    chartTitleList.add('수온(℃)');
    chartTitleList.add('pH');
    chartTitleList.add('전기전도도');
    updateFilterList(selectedFilter1, selectedFilter2, selectedFilter3);
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateFilterList(
    WaterFilter filter1,
    WaterFilter filter2,
    WaterFilter filter3,
  ) {
    setState(() {
      filterList = [filter1, filter2, filter3];
    });
  }

  Future<void> fetchData() async {
    chartDataList = [[], [], []];
    itemList();

    try {
      if (filterList.isNotEmpty) {
        final List<ApiResultKWater>? ret1 = await KwaterApi.getWaterQuality(filterList[0]);

        setData(ret1!, 0, chart1Data, filterList[0]);
        final List<ApiResultKWater>? ret2 = await KwaterApi.getWaterQuality(filterList[1]);
        setData(ret2!, 1, chart2Data, filterList[1]);
        final List<ApiResultKWater>? ret3 = await KwaterApi.getWaterQuality(filterList[2]);
        setData(ret3!, 2, chart3Data, filterList[2]);
      }
    } catch (e) {
      debugPrint('$e');
    }
    setState(() {});
  }

  void setData(List<ApiResultKWater>? ret, int dataNum, List<FlSpot> dataList, WaterFilter filter) {
    dataList = [];
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String date;
    String hour;
    String minute;
    String time;
    double indexNum = 0;

    double max = double.negativeInfinity;
    double? min;

    if (ret != null && ret.isNotEmpty) {
      for (var i = 0; i < ret.length; i++) {
        date = ret[i].timestampModifiedat!.split(' ')[0];
        hour = ret[i].timestampModifiedat!.split(' ')[1].split(':')[0];
        minute = ret[i].timestampModifiedat!.split(' ')[1].split(':')[1];

        time = '$hour:$minute';

        if (date == today && int.parse(hour) >= 10) {
          showChart = true;
          if (int.parse(hour) >= 10 && int.parse(hour) <= 16) {
            dataList.add(FlSpot(indexNum, ret[i].envData!));
            indexNum++;
          }
          if (ret[i].envData! > max) {
            max = ret[i].envData!;
          }
          if (min == null || ret[i].envData! < min) {
            min = ret[i].envData!;
          }
        }
      }

      // 유효한 데이터가 없을 경우 기본값 설정
      if (min == null) {
        min = 0; // 또는 다른 적절한 기본값
      }

      chartDataList[dataNum] = dataList;
    } else {
      chartDataList[dataNum] = [];
    }
    chartDataList[dataNum].toSet().toList();

    if (filter == WaterFilter.temp_deg_c) {
      chartMinMaxAverList[0] = [min!, max];
    } else if (filter == WaterFilter.ph_units) {
      chartMinMaxAverList[1] = [min!, max];
    } else if (filter == WaterFilter.spcond_us_cm) {
      chartMinMaxAverList[2] = [min!, max];
    } else if (filter == WaterFilter.turb_ntu) {
      chartMinMaxAverList[3] = [min!, max];
    } else if (filter == WaterFilter.hdo_mg_l) {
      chartMinMaxAverList[4] = [min!, max];
    } else if (filter == WaterFilter.ph_mv) {
      chartMinMaxAverList[5] = [min!, max];
    } else if (filter == WaterFilter.chl_ug_l) {
      chartMinMaxAverList[6] = [min!, max];
    } else if (filter == WaterFilter.bg_ppb) {
      chartMinMaxAverList[7] = [min!, max];
    }

    debugPrint('check1 : ${chartDataList[0]}');
    debugPrint('check2 : $max');
    debugPrint('check2 : $max');
    debugPrint('check3 : $min');
  }

  void itemList() {
    _items1 = [
      '수온(℃)',
      'pH',
      '전기전도도',
      '탁도(NTU)',
      '광학DO (mg/L)',
      '용존산소(mg/L)',
      '클로로필-a',
      '피코시아닌',
    ];
    _items2 = List.from(_items1);
    _items3 = List.from(_items1);
    setState(() {});
  }

  Widget dropBox(Function() onBtnPressed, double width1, double width2, double height, String hint2, bool boxStatus, List<String> itemList,
      WaterFilter filter, int chartNum) {
    // '수온(℃)'을 제거한 새로운 리스트 생성
    List<String> filteredItemList = List.from(itemList);
    //수온
    if (filterList[0] == WaterFilter.temp_deg_c) {
      filteredItemList.remove('수온(℃)');
    }
    if (filterList[1] == WaterFilter.temp_deg_c) {
      filteredItemList.remove('수온(℃)');
    }
    if (filterList[2] == WaterFilter.temp_deg_c) {
      filteredItemList.remove('수온(℃)');
    }
    //pH
    if (filterList[0] == WaterFilter.ph_units) {
      filteredItemList.remove('pH');
    }
    if (filterList[1] == WaterFilter.ph_units) {
      filteredItemList.remove('pH');
    }
    if (filterList[2] == WaterFilter.ph_units) {
      filteredItemList.remove('pH');
    }
    //전기전도도
    if (filterList[0] == WaterFilter.spcond_us_cm) {
      filteredItemList.remove('전기전도도');
    }
    if (filterList[1] == WaterFilter.spcond_us_cm) {
      filteredItemList.remove('전기전도도');
    }
    if (filterList[2] == WaterFilter.spcond_us_cm) {
      filteredItemList.remove('전기전도도');
    }
    //탁도(NTU)
    if (filterList[0] == WaterFilter.turb_ntu) {
      filteredItemList.remove('탁도(NTU)');
    }
    if (filterList[1] == WaterFilter.turb_ntu) {
      filteredItemList.remove('탁도(NTU)');
    }
    if (filterList[2] == WaterFilter.turb_ntu) {
      filteredItemList.remove('탁도(NTU)');
    }
    //광학DO (mg/L)
    if (filterList[0] == WaterFilter.hdo_mg_l) {
      filteredItemList.remove('광학DO (mg/L)');
    }
    if (filterList[1] == WaterFilter.hdo_mg_l) {
      filteredItemList.remove('광학DO (mg/L)');
    }
    if (filterList[2] == WaterFilter.hdo_mg_l) {
      filteredItemList.remove('광학DO (mg/L)');
    }
    //용존산소(mg/L)
    if (filterList[0] == WaterFilter.ph_mv) {
      filteredItemList.remove('용존산소(mg/L)');
    }
    if (filterList[1] == WaterFilter.hdo_mg_l) {
      filteredItemList.remove('용존산소(mg/L)');
    }
    if (filterList[2] == WaterFilter.hdo_mg_l) {
      filteredItemList.remove('용존산소(mg/L)');
    }
    //클로로필-a
    if (filterList[0] == WaterFilter.chl_ug_l) {
      filteredItemList.remove('클로로필-a');
    }
    if (filterList[1] == WaterFilter.chl_ug_l) {
      filteredItemList.remove('클로로필-a');
    }
    if (filterList[2] == WaterFilter.chl_ug_l) {
      filteredItemList.remove('클로로필-a');
    }
    //피코시아닌
    if (filterList[0] == WaterFilter.bg_ppb) {
      filteredItemList.remove('피코시아닌');
    }
    if (filterList[1] == WaterFilter.bg_ppb) {
      filteredItemList.remove('피코시아닌');
    }
    if (filterList[2] == WaterFilter.bg_ppb) {
      filteredItemList.remove('피코시아닌');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width1,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: IdBtn(
              onBtnPressed: onBtnPressed,
              childWidget: Row(
                children: [
                  uiCommon.styledText(hint2, 14, 0, 1, FontWeight.w400, IdColors.white, TextAlign.left),
                  const IdSpace(spaceWidth: 8, spaceHeight: 0),
                  IdImgBox1(
                      imageHeight: 16,
                      imageWidth: 16,
                      imagePath: (!boxStatus) ? 'assets/img/icon_down_arrow.png' : 'assets/img/icon_up_arrow.png',
                      imageFit: BoxFit.cover),
                ],
              ),
            ),
          ),
        ),
        const IdSpace(spaceWidth: 0, spaceHeight: 4),
        Visibility(
          visible: boxStatus,
          child: Container(
            width: width2,
            height: (filteredItemList.length >= 4) ? 170 : (filteredItemList.length * 38) + 34,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: IdColors.black40Per,
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(width: 1, color: IdColors.white70per),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(
                  filteredItemList.length,
                  (index) => HoverContainer(
                    width: double.infinity,
                    height: 38,
                    hoverDecoration: BoxDecoration(
                      color: IdColors.black10Per,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IdBtn(
                      onBtnPressed: () {
                        dropHintList[chartNum] = filteredItemList[index];
                        dropDownBoolList[chartNum] = false;

                        // 필터 업데이트
                        if (filteredItemList[index] == _itemList[chartNum][0]) {
                          filter = WaterFilter.temp_deg_c;
                        } else if (filteredItemList[index] == _itemList[chartNum][1]) {
                          filter = WaterFilter.ph_units;
                        } else if (filteredItemList[index] == _itemList[chartNum][2]) {
                          filter = WaterFilter.spcond_us_cm;
                        } else if (filteredItemList[index] == _itemList[chartNum][3]) {
                          filter = WaterFilter.turb_ntu;
                        } else if (filteredItemList[index] == _itemList[chartNum][4]) {
                          filter = WaterFilter.hdo_mg_l;
                        } else if (filteredItemList[index] == _itemList[chartNum][5]) {
                          filter = WaterFilter.ph_mv;
                        } else if (filteredItemList[index] == _itemList[chartNum][6]) {
                          filter = WaterFilter.chl_ug_l;
                        } else if (filteredItemList[index] == _itemList[chartNum][7]) {
                          filter = WaterFilter.bg_ppb;
                        }

                        filterList[chartNum] = filter;

                        setState(() {});

                        fetchData();
                      },
                      childWidget: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                            child:
                                uiCommon.styledText(filteredItemList[index], 14, 0, 1, FontWeight.w400, IdColors.white, TextAlign.center)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget dividerLine() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 1,
        color: IdColors.white10per,
      ),
    );
  }

  // x축
  Widget bottomTitleWidgetsEng(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text("10:00", style: style);
        break;
      case 6:
        text = const Text('11:00', style: style);
        break;
      case 12:
        text = const Text('12:00', style: style);
        break;
      case 18:
        text = const Text('13:00', style: style);
        break;
      case 24:
        text = const Text('14:00', style: style);
        break;
      case 30:
        text = const Text('15:00', style: style);
        break;
      case 36:
        text = const Text('16:00', style: style);
        break;
      case 42:
        text = const Text('17:00', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return text;
  }

  // 수온
  Widget leftTitleWidgets1(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // pH
  Widget leftTitleWidgets2(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // 전기전도도
  Widget leftTitleWidgets3(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // 탁도
  Widget leftTitleWidgets4(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // 광학
  Widget leftTitleWidgets5(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // 용존
  Widget leftTitleWidgets6(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // 클로로필
  Widget leftTitleWidgets7(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  // 피코시아닌
  Widget leftTitleWidgets8(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: IdColors.white70per,
    );

    return Text('', style: style, textAlign: TextAlign.left);
  }

  Widget chartWidget(String chartTitle, Function() onBtnPressed, List<FlSpot> chartData, Color chartColor1, WaterFilter filter) {
    return Column(
      children: [
        IdSpace(spaceWidth: 0, spaceHeight: 4),
        Container(
          child: Idchart(
            chartData: chartData,
            gridDataVisible: true,
            flGridData: FlGridData(
              show: true,
              drawHorizontalLine: false,
              drawVerticalLine: false,
              verticalInterval: 1,
              horizontalInterval: (filter == WaterFilter.temp_deg_c)
                  ? 1
                  : (filter == WaterFilter.ph_units)
                      ? 2
                      : (filter == WaterFilter.spcond_us_cm)
                          ? 20
                          : (filter == WaterFilter.turb_ntu)
                              ? 50
                              : (filter == WaterFilter.hdo_mg_l)
                                  ? 2
                                  : (filter == WaterFilter.ph_mv)
                                      ? 20
                                      : (filter == WaterFilter.chl_ug_l)
                                          ? 10
                                          : 10,
            ),
            leftSideTitlesVisible: true,
            topSideTitlesVisible: false,
            rightSideTitlesVisible: false,
            bottomSideTitlesVisible: true,
            reservedSize: const [6, 0, 0, 60],
            interval: [1, 0, 0, 1],
            leftCharSide: (filter == WaterFilter.temp_deg_c)
                ? leftTitleWidgets1
                : (filter == WaterFilter.ph_units)
                    ? leftTitleWidgets2
                    : (filter == WaterFilter.spcond_us_cm)
                        ? leftTitleWidgets3
                        : (filter == WaterFilter.turb_ntu)
                            ? leftTitleWidgets4
                            : (filter == WaterFilter.hdo_mg_l)
                                ? leftTitleWidgets5
                                : (filter == WaterFilter.ph_mv)
                                    ? leftTitleWidgets6
                                    : (filter == WaterFilter.chl_ug_l)
                                        ? leftTitleWidgets7
                                        : leftTitleWidgets8,
            topCharSide: leftTitleWidgets1,
            rightCharSide: leftTitleWidgets1,
            bottomCharSide: bottomTitleWidgetsEng,
            chartBorderVisible: true,
            chartBorder: Border(
              bottom: BorderSide(width: 1, color: IdColors.white70per),
              left: BorderSide(width: 1, color: IdColors.white70per),
            ),
            minX: 0,
            maxX: 42,
            minY: (filter == WaterFilter.temp_deg_c)
                ? chartMinMaxAverList[0][0]
                : (filter == WaterFilter.ph_units)
                    ? chartMinMaxAverList[1][0]
                    : (filter == WaterFilter.spcond_us_cm)
                        ? chartMinMaxAverList[2][0]
                        : (filter == WaterFilter.turb_ntu)
                            ? chartMinMaxAverList[3][0]
                            : (filter == WaterFilter.hdo_mg_l)
                                ? chartMinMaxAverList[4][0]
                                : (filter == WaterFilter.ph_mv)
                                    ? chartMinMaxAverList[5][0]
                                    : (filter == WaterFilter.chl_ug_l)
                                        ? chartMinMaxAverList[6][0]
                                        : chartMinMaxAverList[7][0],
            maxY: (!showChart)
                ? 0
                : (filter == WaterFilter.temp_deg_c)
                    ? chartMinMaxAverList[0][1]
                    : (filter == WaterFilter.ph_units)
                        ? chartMinMaxAverList[1][1]
                        : (filter == WaterFilter.spcond_us_cm)
                            ? chartMinMaxAverList[2][1]
                            : (filter == WaterFilter.turb_ntu)
                                ? chartMinMaxAverList[3][1]
                                : (filter == WaterFilter.hdo_mg_l)
                                    ? chartMinMaxAverList[4][1]
                                    : (filter == WaterFilter.ph_mv)
                                        ? chartMinMaxAverList[5][1]
                                        : (filter == WaterFilter.chl_ug_l)
                                            ? chartMinMaxAverList[6][1]
                                            : chartMinMaxAverList[7][1],
            chartColor1: chartColor1,
            chartColor2: IdColors.invisiable,
            isCurved: false,
            chartLineWidth: 2,
            isStrokeCapRound: false,
            dotData: false,
            belowBarData: false,
            beginGradient: Alignment.topCenter,
            endGradient: Alignment.bottomCenter,
            chartWidth: 328,
            chartHeight: 162,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IdColors.black40Per,
        border: Border.all(width: 1, color: IdColors.white16per),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: List.generate(
          chartTitleList.length,
          (index) => Visibility(
            visible: widget.chartShow[index],
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 58),
                  child: SizedBox(
                    child: Column(
                      children: [
                        (index == 0) ? SizedBox() : IdSpace(spaceWidth: 0, spaceHeight: 16),
                        chartWidget(
                          chartTitleList[index],
                          () {
                            setState(() {
                              chartTitleList.remove(chartTitleList[index]);
                            });
                          },
                          chartDataList[index],
                          chartColorList[index],
                          filterList[index],
                        ),
                        (index == chartTitleList.length - 1) ? SizedBox() : dividerLine()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: 352,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dropBox(() {
                          setState(
                            () {
                              dropDownBoolList[index] = !dropDownBoolList[index];
                            },
                          );
                        }, 140, 193, 40, dropHintList[index], dropDownBoolList[index], _items1, filterList[index], index),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: IdBtn(
                            onBtnPressed: (index == 0)
                                ? widget.cloeseBtn1
                                : (index == 1)
                                    ? widget.cloeseBtn2
                                    : widget.cloeseBtn3,
                            childWidget: const IdImgBox1(
                                imageWidth: 24, imageHeight: 24, imagePath: "assets/img/icon_close.png", imageFit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
