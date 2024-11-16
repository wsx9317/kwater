import 'dart:async';
import 'dart:collection';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwater/api/kwater_api.dart';
import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdCloesBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdHeader.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdScale.dart';
import 'package:kwater/id_widget/IdSpace.dart';
import 'package:kwater/id_widget/IdWaterGradiation.dart';
import 'package:kwater/id_widget/IdZoomBar.dart';
import 'package:kwater/id_widget/IdZoomDrag.dart';
import 'package:kwater/model/Kwater.dart';
import 'package:kwater/model/apiResultKwater.dart';
import 'package:kwater/popup/PopWQChart.dart';
import 'package:kwater/screens/Background.dart';
import 'package:intl/intl.dart';
import 'package:kwater/modelVO/AreaId.dart';

class Waterqualityprediction extends StatefulWidget {
  const Waterqualityprediction({super.key});

  @override
  State<Waterqualityprediction> createState() => _WaterqualitypredictionState();
}

class _WaterqualitypredictionState extends State<Waterqualityprediction> {
  double _value = 0.0;
  // double _value = 60.0;
  double zoomCnt = 0;
  final ZoomDragController _controller = ZoomDragController();
  int whealCnt = 0;
  int zoomActiveCnt = 0;
  List<int> zoomHistory = [0];
  List<FlSpot> chartData = [];
  DateTime today = DateTime.now();
  int dayInMonth = 0;
  //수질예측일때 나오는 차트 팝업
  bool waterQualityPopupBool = false;
  //임시
  int waterQualityAreaNm = 0;
  List<int> waterQualityAreaNmList = [1, 2, 3, 4, 5, 6];
  //클릭한 수질색상
  Color areaWaterColor = IdColors.invisiable;
  Color polygonColor = IdColors.invisiable;

  List<List> polygon2List = [];
  List<List<dynamic>> polygonGrupList = [
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  //임시
  List<int> get area1List => AreaId.area1List;
  List<int> get area2List => AreaId.area2List;
  List<int> get area3List => AreaId.area3List;
  List<int> get area4List => AreaId.area4List;
  List<int> get area5List => AreaId.area5List;
  List<int> get area6List => AreaId.area6List;

  List<Color> gradationColors = [];

  WaterFilter filter = WaterFilter.chl_ug_l;

  List<String> chartX = [];

  int polygonId = 0;

  double waterLevel = 0;

  bool setData = false;

  late Future<void> _dataFuture;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    GV.pStrg.putXXX(key_scale_value, '1.0');
    _dataFuture = fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> fetchData() async {
    chartX = [];
    chartData = [];
    waterLevel = 0;
    gradationColors = [];
    String formationDate = DateFormat('yyyy-MM-dd').format(today);

    final List<ApiResultKWater>? ret1 = await KwaterApi.getRemovePriority(filter);
    if (ret1 != null && ret1.isNotEmpty) {
      for (var i = 0; i < ret1.length; i++) {
        polygonGrupList[int.parse(ret1[i].gridId.toString())] = ['', ret1[i].priority.toString()];
      }

      final String response = await rootBundle.loadString('assets/data/kw-status.csv');
      var d = const FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
      final List<List<dynamic>> rows = CsvToListConverter(csvSettingsDetector: d).convert(response);

      for (var row in rows.skip(1)) {
        var idValue = int.parse(row[0].toString());

        //수질 등급, 구역이름
        int geometryValue = 0;
        int areaNum = 0;
        String areaNm = '';
        if (area1List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[0][1]);
        } else if (area2List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[1][1]);
        } else if (area3List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[2][1]);
        } else if (area4List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[3][1]);
        } else if (area5List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[4][1]);
        } else if (area6List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[5][1]);
        } else {
          geometryValue = 0;
        }
        polygon2List.add([idValue, geometryValue, areaNum]);
      }
      polygon2List.sort((a, b) => a[2].compareTo(b[2]));
      setData = true;
    } else {
      polygonGrupList = [
        [],
        [],
        [],
        [],
        [],
        [],
      ];
      setData = false;
    }

    final List<ApiResultKWater>? ret2 = await KwaterApi.getChlHistory(filter, polygonId);
    if (ret2 != null) {
      dayInMonth = ret2.length;
      for (var i = 0; i < ret2.length; i++) {
        chartX.add(ret2[i].timestamp!.split('-')[1] + '/' + ret2[i].timestamp!.split('-')[2]);
        chartData.add(FlSpot(i.toDouble(), ret2[i].chlUgLMean!));
      }

      if (ret2[ret2.length - 1].chlUgLMean! <= 5) {
        waterLevel = 1;
      } else if (ret2[ret2.length - 1].chlUgLMean! > 5 && ret2[ret2.length - 1].chlUgLMean! <= 9) {
        waterLevel = 2;
      } else if (ret2[ret2.length - 1].chlUgLMean! > 9 && ret2[ret2.length - 1].chlUgLMean! <= 14) {
        waterLevel = 3;
      } else if (ret2[ret2.length - 1].chlUgLMean! > 14 && ret2[ret2.length - 1].chlUgLMean! <= 20) {
        waterLevel = 4;
      } else if (ret2[ret2.length - 1].chlUgLMean! > 20 && ret2[ret2.length - 1].chlUgLMean! <= 35) {
        waterLevel = 5;
      } else if (ret2[ret2.length - 1].chlUgLMean! > 35 && ret2[ret2.length - 1].chlUgLMean! <= 70) {
        waterLevel = 6;
      } else {
        waterLevel = 7;
      }

      polygonColor = IdColors.invisiable;

      gradationColors = [waterLevelColor(waterLevel), IdColors.invisiable];
      final uniqueChartData = LinkedHashSet<FlSpot>.from(chartData);
      chartData = uniqueChartData.toList();
      chartData.sort((a, b) => a.x.compareTo(b.x));
      setState(() {});
    } else {
      chartX = [];
      chartData = [];
      waterLevel = 0;
    }

  }

  int getDaysInMonth(DateTime date) {
    // 다음 달의 첫 번째 날을 구합니다.
    DateTime firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    // 마지막 날을 구하기 위해 하루를 빼줍니다.
    DateTime lastDayCurrentMonth = firstDayNextMonth.subtract(Duration(days: 1));

    return lastDayCurrentMonth.day;
  }

  //줌사이즈 int증가
  void _increaseZoomSize() {
    setState(() {
      if (_value < 6) {
        _value = _value + 1;
      } else {
        _value = 6;
      }
    });
  }

//줌사이즈 int감소
  void _decreaseZoomSize() {
    setState(() {
      if (_value > 0) {
        _value = _value - 1;
      } else {
        _value = 0;
      }
    });
  }

  //막대그래프로 줌조절
  void changeChart() {
    zoomHistory.add(whealCnt);
    int zommHistoryLength = zoomHistory.length;

    if (zoomHistory.length == 2) {
      int currentZoomCnt = zoomHistory[zommHistoryLength - 1];
      int initZoomCnt = zoomHistory[0];
      double zoomScale = (currentZoomCnt - initZoomCnt).toDouble();
      zoomCnt = zoomScale;
      if (zoomCnt > 0) {
        _controller.zoomInMulty(zoomCnt);
      } else {
        _controller.zoomOutMulty(zoomCnt * -1);
      }
    } else if (zoomHistory.length > 2) {
      int currentZoomCnt = zoomHistory[zommHistoryLength - 1];
      int beforeZoomCnt = zoomHistory[zommHistoryLength - 2];
      double zoomScale = (currentZoomCnt - beforeZoomCnt).toDouble();
      zoomCnt = zoomScale;
      if (zoomCnt > 0) {
        _controller.zoomInMulty(zoomCnt);
      } else {
        _controller.zoomOutMulty(zoomCnt * -1);
      }
    }
    setState(() {});
  }

  void onPolygonClick() {
    setState(() {
      String id = GV.pStrg.getXXX(key_area_value);
      polygonId = int.tryParse(id) ?? 0;
      if (int.tryParse(GV.pStrg.getXXX(key_area_value)) != null) {
        waterQualityAreaNm = waterQualityAreaNmList[int.tryParse(GV.pStrg.getXXX(key_area_value)) ?? 0];

        if (waterQualityAreaNm == 1) {
          filterFunction(area1List);
        } else if (waterQualityAreaNm == 2) {
          filterFunction(area2List);
        } else if (waterQualityAreaNm == 3) {
          filterFunction(area3List);
        } else if (waterQualityAreaNm == 4) {
          filterFunction(area4List);
        } else if (waterQualityAreaNm == 5) {
          filterFunction(area5List);
        } else {
          filterFunction(area6List);
        }
      } else {
        waterQualityAreaNm = 0;
      }
    });
    fetchData();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        waterQualityPopupBool = true;
      });
    });
  }

  void filterFunction(List<int> areaList) {
    if (polygon2List.any((innerList) => innerList.isNotEmpty && areaList.contains(innerList[0]))) {
      var matchingList = polygon2List.firstWhere((innerList) => innerList.isNotEmpty && areaList.contains(innerList[0]));
      if (matchingList.length > 1) {
        graphColor(matchingList[1]);
      }
    }
  }

  Color graphColor(int areaList) {
    areaWaterColor = IdColors.invisiable;

    if (areaList == 1) {
      areaWaterColor = IdColors.waterLevel1;
    } else if (areaList == 2) {
      areaWaterColor = IdColors.waterLevel2;
    } else if (areaList == 3) {
      areaWaterColor = IdColors.waterLevel3;
    } else if (areaList == 4) {
      areaWaterColor = IdColors.waterLevel4;
    } else if (areaList == 5) {
      areaWaterColor = IdColors.waterLevel5;
    } else if (areaList == 6) {
      areaWaterColor = IdColors.waterLevel6;
    } else if (areaList == 7) {
      areaWaterColor = IdColors.waterLevel7;
    } else {
      areaWaterColor = IdColors.waterLevel8;
    }

    return areaWaterColor;
  }

  Color waterLevelColor(double waterLevel) {
    polygonColor = IdColors.invisiable;

    if (waterLevel == 1) {
      polygonColor = IdColors.waterLevel8;
    } else if (waterLevel == 2) {
      polygonColor = IdColors.waterLevel6;
    } else if (waterLevel == 3) {
      polygonColor = IdColors.waterLevel5;
    } else if (waterLevel == 4) {
      polygonColor = IdColors.waterLevel4;
    } else if (waterLevel == 5) {
      polygonColor = IdColors.waterLevel3;
    } else if (waterLevel == 6) {
      polygonColor = IdColors.waterLevel2;
    } else if (waterLevel == 7) {
      polygonColor = IdColors.waterLevel1;
    }

    return polygonColor;
  }

  List<List<dynamic>> polygonDataList() {
    List<List<dynamic>> result = [];
    result = polygon2List;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color.fromARGB(215, 0, 0, 0),
            child: Center(
              child: SizedBox(
                width: 1920,
                child: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      setState(() {
                        if (pointerSignal.scrollDelta.dy < 0) {
                          // 마우스 휠을 내릴릴 때
                          if (whealCnt < 6) {
                            _controller.zoomIn();
                            _increaseZoomSize();
                            whealCnt++;
                          } else {
                            whealCnt = 6;
                          }
                        } else {
                          // 마우스 휠을 올릴 때
                          if (whealCnt > 0) {
                            _controller.zoomOut();
                            _decreaseZoomSize();
                            whealCnt--;
                          } else {
                            whealCnt = 0;
                          }
                        }
                        zoomHistory.add(whealCnt);
                      });
                    }
                  },
                  child: Center(
                    child: IdZoomdrag(
                      windowWidth: 1920,
                      windowHeight: MediaQuery.of(context).size.height,
                      contentWidth: 1920,
                      contentHeight: 1920,
                      controller: _controller,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 1920,
                            height: 1920,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                FutureBuilder(
                                  future: _dataFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      // 데이터 로딩 중에는 아무것도 표시하지 않음
                                      return Image.asset(
                                        'assets/img/map16x2.jpg',
                                        key: const ValueKey('polygonwidet123_map16x2_123'),
                                        width: 1920,
                                        height: 1920,
                                        fit: BoxFit.cover,
                                      );
                                    } else if (snapshot.hasError) {
                                      // 오류 발생 시 오류 메시지 표시
                                      return Center(child: Text('오류: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                                    } else {
                                      // 데이터 로딩 완료 후 Background 위젯 표시
                                      return Background(
                                        showPolygon: true,
                                        showDevice: false,
                                        robotPathHistory: [
                                          [0, 0]
                                        ],
                                        showIcon: false,
                                        polygonIdList2: polygonDataList(),
                                        onPolygonClick: onPolygonClick,
                                        polygonGrupList: polygonGrupList,
                                        setData: setData,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //하단
          Positioned(
            bottom: 14,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //줌컨트롤러 (버튼, 그래프)
                SizedBox(
                  width: 40,
                  height: 204,
                  child: Column(
                    children: [
                      IdBtn(
                        onBtnPressed: () {
                          if (whealCnt < 6) {
                            _controller.zoomIn();
                            _increaseZoomSize();
                            // _controller2.zoomIn();
                            whealCnt++;
                          } else {
                            whealCnt = 6;
                          }
                          zoomHistory.add(whealCnt);
                        },
                        childWidget: const IdImgBox1(
                            imageWidth: 40, imageHeight: 40, imagePath: 'assets/img/icon_zoomIn.png', imageFit: BoxFit.cover),
                      ),
                      IdZoombar(
                        valeu: _value,
                        onChanged: (p0, p1, p2) {
                          _value = double.parse(p1.toString());
                          whealCnt = int.parse(p1.toString());
                          setState(() {});
                          changeChart();
                        },
                      ),
                      IdBtn(
                        onBtnPressed: () {
                          if (whealCnt > 0) {
                            _controller.zoomOut();
                            _decreaseZoomSize();
                            whealCnt--;
                          } else {
                            whealCnt = 0;
                          }
                          zoomHistory.add(whealCnt);
                        },
                        childWidget: const IdImgBox1(
                            imageWidth: 40, imageHeight: 40, imagePath: 'assets/img/icon_zoomOut.png', imageFit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                const IdSpace(spaceWidth: 0, spaceHeight: 24),
                IdScale(),
              ],
            ),
          ),
          //헤더
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Idheader(
              pageStateNum: 2,
              logoEvent: () {
                uiCommon.IdMovePage(context, PAGE_MORNITORING_PAGE);
              },
              menu1Event: () {
                uiCommon.IdMovePage(context, PAGE_MORNITORING_PAGE);
              },
              menu2Event: () {
                uiCommon.IdMovePage(context, PAGE_WQSTATUS_PAGE);
              },
              menu3Event: () {},
              menu4Event: () {
                uiCommon.IdMovePage(context, PAGE_DECISION_PAGE);
              },
              subMenuWidget: SizedBox(),
            ),
          ),
          //수질예측 팝업

          Visibility(
            visible: waterQualityPopupBool,
            child: Positioned(
              top: 70,
              right: 40,
              child: PopWQchart(
                key: ValueKey('pqchart123'),
                areaNum: waterQualityAreaNm,
                cloesWidget: IdClosebtn(
                  onBtnPressed: () {
                    setState(() {
                      waterQualityPopupBool = false;
                    });
                  },
                ),
                chartData: chartData,
                areaColor: waterLevelColor(waterLevel),
                gradationColors: gradationColors,
                dayOfMonthLength: (chartX.length - 1).toDouble(),
                chartX: chartX,
                filter: (filter == WaterFilter.chl_ug_l) ? 1 : 2,
                filterBtn1: () {
                  setState(() {
                    filter = WaterFilter.chl_ug_l;
                  });
                  fetchData();
                },
                filterBtn2: () {
                  setState(() {
                    filter = WaterFilter.bg_ppb;
                  });
                  fetchData();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
