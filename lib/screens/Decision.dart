import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwater/api/kwater_api.dart';
import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdHeader.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdScale.dart';
import 'package:kwater/id_widget/IdSpace.dart';
import 'package:kwater/id_widget/IdWaterGradiation.dart';
import 'package:kwater/id_widget/IdZoomBar.dart';
import 'package:kwater/id_widget/IdValueBar.dart';
import 'package:kwater/id_widget/IdZoomDrag.dart';
import 'package:kwater/id_widget/IdValueBox.dart';
import 'package:kwater/model/Kwater.dart';
import 'package:kwater/model/apiResultKwater.dart';
import 'package:kwater/modelVO/areaId.dart';
import 'package:kwater/popup/PopAreaPicture.dart';
import 'package:kwater/screens/Background.dart';

class Decision extends StatefulWidget {
  const Decision({super.key});

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  double _value = 0.0;
  double _value1 = 0.0;
  double _value2 = 0.0;
  double _value3 = 0.0;
  // double _value = 00.0;
  double zoomCnt = 0;
  final ZoomDragController _controller = ZoomDragController();
  final ZoomValueController _controller3 = ZoomValueController();
  final ZoomValueController _controller4 = ZoomValueController();
  final ZoomValueController _controller5 = ZoomValueController();
  int whealCnt = 0;
  int zoomActiveCnt = 0;
  List<int> zoomHistory = [0];
  bool showAreaPicture = false;
  bool setData = false;

  List<List> polygon2List = [];
  List<String> valueBoxList = [];
  List<String> valueBoxIcon = [];
  List<String> valueBoxRun = [];
  List<String> valueBoxBtn = [];
  List<String> valueImage = [];
  List<String> valueMaxList = [];
  List<String> toolTipText = [];
  List<bool> isToolTipVisible = [false, false, false];
  List<int> runType = [0, 0, 0];
  List<String> dropDownList = [];
  List<bool> dropDownListItem = [false, false, false];
  List<String> controllerIndex = [];

  int areaId = 0;
  List<String> areaNum2 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];
  List<String> areaName = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
  ];
  List<Color> areaColor = [
    IdColors.invisiable,
    IdColors.waterPolygon2Level1.withOpacity(0.5),
    IdColors.waterPolygon2Level2.withOpacity(0.5),
    IdColors.waterPolygon2Level3.withOpacity(0.5),
    IdColors.waterPolygon2Level4.withOpacity(0.5),
    IdColors.waterPolygon2Level5.withOpacity(0.5),
    IdColors.waterPolygon2Level6.withOpacity(0.5),
    IdColors.waterPolygon2Level7.withOpacity(0.5),
  ];

  //임시
  List<int> get area1List => AreaId.area1List;
  List<int> get area2List => AreaId.area2List;
  List<int> get area3List => AreaId.area3List;
  List<int> get area4List => AreaId.area4List;
  List<int> get area5List => AreaId.area5List;
  List<int> get area6List => AreaId.area6List;

  List<List<dynamic>> polygonGrupList = [
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  int _selectedIndex = 0;

  int _dataValue = 0;

  DeviceFilter filter1 = DeviceFilter.aberration;
  DeviceFilter filter2 = DeviceFilter.ship;
  DeviceFilter filter3 = DeviceFilter.amplifier;

  WaterFilter filter = WaterFilter.chl_ug_l;

  late Future<void> _dataFuture;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GV.pStrg.putXXX(key_scale_value, '1.0');
    isToolTipVisible = List.generate(valueBoxList.length, (index) => false);
    runType = [0, 0, 0];
    _dataFuture = fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void toggleTooltip(int index) {
    setState(() {
      // If the selected tooltip is already visible, hide it
      if (isToolTipVisible[index]) {
        isToolTipVisible[index] = false;
      } else {
        // Otherwise, hide all tooltips first
        for (int i = 0; i < isToolTipVisible.length; i++) {
          isToolTipVisible[i] = false;
        }
        // Then show the selected tooltip
        isToolTipVisible[index] = true;
      }
    });
  }

  Future<void> fetchData() async {
    valueBoxList = ['수면포기기', '제거선박', '수중폭기장치'];
    valueBoxIcon = ['assets/img/icon_pinwheel.png', 'assets/img/icon_boat.png', 'assets/img/icon_popcorn.png'];
    valueBoxRun = ['가동', '미가동', '미가동'];
    valueBoxBtn = ['assets/img/icon_dots.png', 'assets/img/icon_dots.png', 'assets/img/icon_down_arrow.png'];
    valueMaxList = ['15', '6', '3'];
    toolTipText = ['&gt;25', '&gt;20', '&gt;10'];
    isToolTipVisible = [false, false, false];
    dropDownList = ['가동', '미가동'];

    controllerIndex = ['15', '6', '3'];

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
          areaNum = 1;
          areaNm = "A";
        } else if (area2List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[1][1]);
          areaNum = 2;
          areaNm = "B";
        } else if (area3List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[2][1]);
          areaNum = 3;
          areaNm = "C";
        } else if (area4List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[3][1]);
          areaNum = 4;
          areaNm = "D";
        } else if (area5List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[4][1]);
          areaNum = 5;
          areaNm = "E";
        } else if (area6List.contains(idValue)) {
          geometryValue = int.parse(polygonGrupList[5][1]);
          areaNum = 6;
          areaNm = "F";
        } else {
          geometryValue = 0;
          areaNm = "";
        }
        polygon2List.add([idValue, geometryValue, areaNum, areaNm]);
      }
      polygon2List.sort((a, b) => a[2].compareTo(b[2]));
      for (var i = 0; i < polygon2List.length; i++) {
        if (polygon2List[i][0] == area1List[0]) {
          polygonGrupList[0] = [polygon2List[i][3], polygon2List[i][1].toString()];
        } else if (polygon2List[i][0] == area2List[0]) {
          polygonGrupList[1] = [polygon2List[i][3], polygon2List[i][1].toString()];
        } else if (polygon2List[i][0] == area3List[0]) {
          polygonGrupList[2] = [polygon2List[i][3], polygon2List[i][1].toString()];
        } else if (polygon2List[i][0] == area4List[0]) {
          polygonGrupList[3] = [polygon2List[i][3], polygon2List[i][1].toString()];
        } else if (polygon2List[i][0] == area5List[0]) {
          polygonGrupList[4] = [polygon2List[i][3], polygon2List[i][1].toString()];
        } else if (polygon2List[i][0] == area6List[0]) {
          polygonGrupList[5] = [polygon2List[i][3], polygon2List[i][1].toString()];
        }
      }
      setData = true;
    } else {
      setData = false;
    }

    final ApiResultKWater? ret2 = await KwaterApi.getDevicePower(filter1);
    if (ret2 != null) {
      runType[0] = ret2.state!;
      _value1 = (ret2.state ?? 0).toDouble();
    }
    final ApiResultKWater? ret3 = await KwaterApi.getDevicePower(filter2);
    if (ret3 != null) {
      runType[1] = ret3.state!;
      _value2 = (ret3.state ?? 0).toDouble();
    }
    final ApiResultKWater? ret4 = await KwaterApi.getDevicePower(filter3);
    if (ret4 != null) {
      runType[2] = ret4.state!;
      _value3 = (ret4.state ?? 0).toDouble();
    }
    setState(() {});
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

  //텍스트 버튼
  Widget _buildTextButton({required int index, required String imagePath, required String text}) {
    bool isSelected = _selectedIndex == index;

    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;

          if (_selectedIndex == 1) {
            filter = WaterFilter.bg_ppb;
          } else {
            filter = WaterFilter.chl_ug_l;
          }

          for (int i = 0; i < isToolTipVisible.length; i++) {
            isToolTipVisible[i] = false;
          }
        });

        fetchData();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IdImgBox1(
            imageWidth: 20,
            imageHeight: 20,
            imagePath: isSelected ? "assets/img/icon-check-active.png" : "assets/img/icon-check.png",
            imageFit: BoxFit.cover,
          ),
          const IdSpace(spaceWidth: 5, spaceHeight: 0),
          uiCommon.styledText(
            text,
            15,
            0,
            1,
            FontWeight.w700,
            isSelected ? IdColors.skyblue : IdColors.white40per, // Change color based on selection
            TextAlign.start,
          ),
        ],
      ),
    );
  }

  String gradationTitle(int checkNum) {
    String result = '';
    if (checkNum == 0) {
      result = '클로로필 -α';
    } else {
      result = '피코시아닌 (ppb)';
    }
    return result;
  }

  String tooltipTitle(int checkNum) {
    String result = '';
    if (checkNum == 0) {
      result = '클로로필';
    } else {
      result = '피코시아닌';
    }
    return result;
  }

  Future<bool> setDevice(DeviceFilter filter, int state) async {
    try {
      final result = KwaterApi.postDevicePowerState(filter, state);
      if (result == null) return false;
    } catch (e) {
      debugPrint('$e');
    }
    return true;
  }

  List<List<dynamic>> polygonDataList() {
    List<List<dynamic>> result = [];
    result = polygon2List;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                                      showDevice: true,
                                      robotPathHistory: [
                                        [0, 0]
                                      ],
                                      showIcon: false,
                                      polygonIdList2: polygonDataList(),
                                      polygonGrupList: polygonGrupList,
                                      setData: setData,
                                      deviceValue: _value1,
                                      onPolygonClick: () {
                                        showAreaPicture = true;
                                        /* areaImgPath */
                                        String id = GV.pStrg.getXXX(key_area_value);
                                        areaId = int.parse(id);
                                        setState(() {});
                                      },
                                    );
                                  }
                                }),
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
                      childWidget:
                          const IdImgBox1(imageWidth: 40, imageHeight: 40, imagePath: 'assets/img/icon_zoomIn.png', imageFit: BoxFit.cover),
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
            pageStateNum: 3,
            logoEvent: () {
              uiCommon.IdMovePage(context, PAGE_MORNITORING_PAGE);
            },
            menu1Event: () {
              uiCommon.IdMovePage(context, PAGE_MORNITORING_PAGE);
            },
            menu2Event: () {
              uiCommon.IdMovePage(context, PAGE_WQSTATUS_PAGE);
            },
            menu3Event: () {
              uiCommon.IdMovePage(context, PAGE_WQPREDICTION_PAGE);
            },
            menu4Event: () {},
            subMenuWidget: SizedBox(),
          ),
        ),
        //상단구역별 수질 랭크 / 구역 사진
        Positioned(
          top: 70,
          right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: IdColors.black40Per,
                    border: Border.all(width: 1, color: IdColors.black16Per),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTextButton(
                          index: 0,
                          imagePath: "assets/img/icon-check-active.png",
                          text: '클로로필 -α',
                        ),
                        const IdSpace(spaceWidth: 12, spaceHeight: 0),
                        _buildTextButton(
                          index: 1,
                          imagePath: "assets/img/icon-check.png",
                          text: '피코시아닌 (ppb)',
                        ),
                      ],
                    ),
                    const IdSpace(spaceWidth: 0, spaceHeight: 16),
                    //TODO이부분 range 문제

                    // FutureBuilder(
                    setData
                        ? Row(
                            children: List.generate(
                              polygonGrupList.length,
                              (index) => Container(
                                width: 78,
                                height: 51,
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: IdColors.black20Per))),
                                child: Center(
                                  child: uiCommon.styledText(
                                      polygonGrupList[index][0], 15, 0, 1, FontWeight.w700, IdColors.white, TextAlign.center),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    // FutureBuilder(
                    setData
                        ? Container(
                            color: IdColors.white6per,
                            child: Row(
                              children: List.generate(
                                polygonGrupList.length,
                                (index) => SizedBox(
                                  width: 78,
                                  height: 44,
                                  child: Center(
                                    child: uiCommon.styledText(
                                        polygonGrupList[index][1], 16, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.center),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              const IdSpace(spaceWidth: 0, spaceHeight: 8),
              Visibility(
                visible: showAreaPicture,
                child: Popareapicture(
                  key: ValueKey("popareapicture123"),
                  area: areaNum2[areaId],
                  wqColor: showAreaPicture ? areaColor[int.parse(polygonGrupList[areaId][1])] : areaColor[0],
                  cloesBtnEvent: () {
                    setState(() {
                      showAreaPicture = false;
                    });
                  },
                  areaId: (polygonGrupList[areaId].isEmpty) ? 1 : int.parse(polygonGrupList[areaId][1]) - 1,
                ),
              )
            ],
          ),
        ),

        Positioned(
          bottom: 60,
          right: 13,
          child: Column(
            children: List.generate(
                valueBoxList.length,
                (index) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IdValueBox(
                              text: valueBoxList[index],
                              imagePath: valueBoxIcon[index],
                              runText: (index == 0)
                                  ? (_value1 == 0 ? '미가동' : '가동')
                                  : (index == 1)
                                      ? (_value2 == 0 ? '미가동' : '가동')
                                      : (_value3 == 0 ? '미가동' : '가동'),
                              valueController: (index == 0)
                                  ? IdValueBar(
                                      controller: _controller3,
                                      onChanged: (dynamic value) async {
                                        setState(() {
                                          if (value < 0.5) {
                                            _value1 = 0;
                                          } else if (value < 1.5) {
                                            _value1 = 1;
                                          } else if (value <= 2.5 && value < 3.5) {
                                            _value1 = 2;
                                          } else if (value <= 3.5 && value < 4.5) {
                                            _value1 = 3;
                                          } else if (value <= 4.5 && value < 5.5) {
                                            _value1 = 4;
                                          } else if (value <= 5.5 && value < 6.5) {
                                            _value1 = 5;
                                          } else if (value <= 6.5 && value < 7.5) {
                                            _value1 = 6;
                                          } else if (value <= 7.5 && value < 8.5) {
                                            _value1 = 7;
                                          } else if (value <= 8.5 && value < 9.5) {
                                            _value1 = 8;
                                          } else if (value <= 9.5 && value < 10.5) {
                                            _value1 = 9;
                                          } else if (value <= 10.5 && value < 11.5) {
                                            _value1 = 10;
                                          } else if (value <= 11.5 && value < 12.5) {
                                            _value1 = 11;
                                          } else if (value <= 12.5 && value < 13.5) {
                                            _value1 = 12;
                                          } else if (value <= 13.5 && value < 14.5) {
                                            _value1 = 13;
                                          } else if (value <= 14.5 && value < 15.5) {
                                            _value1 = 14;
                                          } else {
                                            _value1 = 15;
                                          }
                                          runType[0] = int.parse(_value1.toString());
                                        });

                                        if (await setDevice(filter1, runType[0])) {
                                          fetchData();
                                        }
                                      },
                                      value: _value1,
                                      valueMax: 15,
                                      valueMin: 0,
                                      activeColor: IdColors.waterLevel2)
                                  : (index == 1)
                                      ? IdValueBar(
                                          controller: _controller4,
                                          onChanged: (dynamic value) async {
                                            setState(() {
                                              if (value < 0.5) {
                                                _value2 = 0;
                                              } else if (value < 1.5) {
                                                _value2 = 1;
                                              } else if (value <= 2.5 && value < 3.5) {
                                                _value2 = 2;
                                              } else if (value <= 3.5 && value < 4.5) {
                                                _value2 = 3;
                                              } else if (value <= 4.5 && value < 5.5) {
                                                _value2 = 4;
                                              } else if (value <= 5.5 && value < 6.5) {
                                                _value2 = 5;
                                              } else {
                                                _value2 = 6;
                                              }
                                              runType[1] = int.parse(_value2.toString());
                                            });
                                            if (await setDevice(filter2, runType[1])) {
                                              fetchData();
                                            }
                                          },
                                          value: _value2,
                                          valueMax: 6,
                                          valueMin: 0,
                                          activeColor: IdColors.waterLevel3)
                                      : IdValueBar(
                                          controller: _controller5,
                                          onChanged: (dynamic value) async {
                                            setState(() {
                                              if (value < 0.5) {
                                                _value3 = 0;
                                              } else if (value < 1.5) {
                                                _value3 = 1;
                                              } else if (value <= 2.5 && value < 3.5) {
                                                _value3 = 2;
                                              } else if (value <= 3.5 && value < 4.5) {
                                                _value3 = 3;
                                              }
                                              runType[2] = int.parse(_value3.toString());
                                            });
                                            if (await setDevice(filter3, runType[2])) {
                                              fetchData();
                                            }
                                          },
                                          value: _value3,
                                          valueMax: 3,
                                          valueMin: 0,
                                          activeColor: IdColors.waterLevel4),
                              valueMaxText: valueMaxList[index],
                              currentNum: (index == 0)
                                  ? runType[0].toString()
                                  : (index == 1)
                                      ? runType[1].toString()
                                      : runType[2].toString(),
                              currentNumColor: (index == 0)
                                  ? IdColors.waterLevel2
                                  : (index == 1)
                                      ? IdColors.waterLevel3
                                      : IdColors.waterLevel4,
                              btnWidget: (index == 0)
                                  ? IdBtn(
                                      onBtnPressed: () => toggleTooltip(0),
                                      childWidget: const IdImgBox1(
                                          imageWidth: 16, imageHeight: 16, imagePath: 'assets/img/icon_dots.png', imageFit: BoxFit.cover),
                                    )
                                  : (index == 1)
                                      ? IdBtn(
                                          onBtnPressed: () => toggleTooltip(1),
                                          childWidget: const IdImgBox1(
                                              imageWidth: 16,
                                              imageHeight: 16,
                                              imagePath: 'assets/img/icon_dots.png',
                                              imageFit: BoxFit.cover),
                                        )
                                      : IdBtn(
                                          onBtnPressed: () => toggleTooltip(2),
                                          childWidget: const IdImgBox1(
                                              imageWidth: 16,
                                              imageHeight: 16,
                                              imagePath: 'assets/img/icon_dots.png',
                                              imageFit: BoxFit.cover),
                                        ),
                            ),
                          ),
                        ),
                        if (isToolTipVisible[index])
                          Positioned(
                              top: -35,
                              right: 4,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: IdColors.white90per),
                                    child: uiCommon.styledText(tooltipTitle(_selectedIndex) + toolTipText[index], 13, 0, 1, FontWeight.w500,
                                        IdColors.black90Per, TextAlign.center),
                                  ),
                                  const Positioned(
                                    right: 0,
                                    bottom: -7,
                                    child: IdImgBox1(
                                        imageWidth: 80, imageHeight: 7, imagePath: 'assets/img/icon-triangle.png', imageFit: BoxFit.cover),
                                  )
                                ],
                              )),
                      ],
                    )),
          ),
        )
      ]),
    );
  }
}
