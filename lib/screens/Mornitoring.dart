import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwater/api/kwater_api.dart';
import 'package:kwater/common/globalvar.dart';

import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdHeader.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdScale.dart';

import 'package:kwater/id_widget/IdSpace.dart';
import 'package:kwater/id_widget/IdZoomBar.dart';
import 'package:kwater/id_widget/IdZoomDrag.dart';
import 'package:kwater/model/apiResultKwater.dart';
import 'package:kwater/popup/PopMornitoring.dart';
import 'package:kwater/screens/Background.dart';

class Mornitoring extends StatefulWidget {
  const Mornitoring({super.key});

  @override
  State<Mornitoring> createState() => _MornitoringState();
}

class _MornitoringState extends State<Mornitoring> {
  bool _isBlurred = false;
  Timer? _blurtimer;
  double _value = 0.0;
  // double _value = 60.0;
  double zoomCnt = 0;
  final ZoomDragController _controller = ZoomDragController();
  int whealCnt = 0;
  int zoomActiveCnt = 0;
  List<int> zoomHistory = [0];
  //모니터링때 나오는 차트 팝업
  bool mornitorPopupBool = false;
  List<bool> mornitorPopupBoolList = [
    false,
    false,
    false,
  ];

  bool setData = false;

  List<List<double>> robotPath = [];

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
    super.dispose();
  }

  Future<void> fetchData() async {
    final List<ApiResultKWater>? ret = await KwaterApi.getRobotPath();

    DateTime today = DateTime.now();

    String formationDate = DateFormat('yyyy-MM-dd').format(today);

    if (ret != null && ret.isNotEmpty) {
      for (var i = 0; i < ret.length; i++) {
        if (ret[i].timestampModifiedat!.split(' ')[0] == formationDate) {
          robotPath.add([ret[i].longitude!, ret[i].latitude!]);
        }
      }
      setData = true;
    } else {
      setData = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('123main0'),
      body: Stack(
        key: ValueKey('123main1'),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color.fromARGB(215, 0, 0, 0),
            child: Center(
              child: SizedBox(
                width: 1920,
                child: Listener(
                  key: ValueKey('123main2'),
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
                    key: ValueKey('123main5'),
                    windowWidth: 1920,
                    windowHeight: MediaQuery.of(context).size.height,
                    contentWidth: 1920,
                    contentHeight: 1920,
                    controller: _controller,
                    children: [
                      Center(
                        key: ValueKey('123main6'),
                        child: SizedBox(
                          key: ValueKey('123main7'),
                          width: 1920,
                          height: 1920,
                          child: Stack(
                            key: ValueKey('123main8'),
                            alignment: Alignment.center,
                            children: [
                              Visibility(
                                visible: true,
                                child: (setData)
                                    ? Background(
                                        key: ValueKey('123main9'),
                                        showPolygon: false,
                                        showDevice: false,
                                        setData: setData,
                                        showIcon: true,
                                        robotPathHistory: robotPath,
                                      )
                                    : Image.asset(
                                        'assets/img/map16x2.jpg',
                                        key: const ValueKey('polygonwidet123_map16x2_123'),
                                        width: 1920,
                                        height: 1920,
                                        fit: BoxFit.cover,
                                      ),
                              )
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
            key: ValueKey('123maincontrol1'),
            bottom: 14,
            left: 40,
            child: Column(
              key: ValueKey('123maincontrol2'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //줌컨트롤러 (버튼, 그래프)
                Row(
                  key: ValueKey('123maincontrol3'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      key: ValueKey('123maincontrol4'),
                      width: 40,
                      height: 204,
                      child: Column(
                        key: ValueKey('123maincontrol5'),
                        children: [
                          IdBtn(
                            key: ValueKey('123maincontrol6'),
                            onBtnPressed: () {
                              if (whealCnt < 6) {
                                _controller.zoomIn();
                                _increaseZoomSize();
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
                            key: ValueKey('123maincontrol8'),
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
                                key: ValueKey('123maincontrol9'),
                                imageWidth: 40,
                                imageHeight: 40,
                                imagePath: 'assets/img/icon_zoomOut.png',
                                imageFit: BoxFit.cover),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const IdSpace(spaceWidth: 0, spaceHeight: 24),

                IdScale(scaleValue: _value,),
              ],
            ),
          ),

          //모니터링 팝업
          Visibility(
            key: ValueKey('123mainpopup1'),
            visible: mornitorPopupBoolList.contains(true) ? true : false,
            child: Positioned(
              key: ValueKey('123mainpopup2'),
              top: 70,
              right: 40,
              child: RepaintBoundary(
                  child: PopMornitoring(
                key: ValueKey('123mainpopup3'),
                chartShow: mornitorPopupBoolList,
                cloeseBtn1: () {
                  setState(() {
                    mornitorPopupBoolList[0] = false;
                  });
                },
                cloeseBtn2: () {
                  setState(() {
                    mornitorPopupBoolList[1] = false;
                  });
                },
                cloeseBtn3: () {
                  setState(() {
                    mornitorPopupBoolList[2] = false;
                  });
                },
              )),
            ),
          ),

          //헤더
          Positioned(
            key: ValueKey('123mainhead1'),
            top: 0,
            left: 0,
            right: 0,
            child: Idheader(
              key: ValueKey('123mainhead2'),
              pageStateNum: 0,
              logoEvent: () {},
              menu1Event: () {},
              menu2Event: () {
                uiCommon.IdMovePage(context, PAGE_WQSTATUS_PAGE);
              },
              menu3Event: () {
                uiCommon.IdMovePage(context, PAGE_WQPREDICTION_PAGE);
              },
              menu4Event: () {
                uiCommon.IdMovePage(context, PAGE_DECISION_PAGE);
              },
              subMenuWidget: Padding(
                padding: const EdgeInsets.only(top: 6.5),
                child: IdBtn(
                  key: ValueKey('123mainhead3'),
                  onBtnPressed: () {
                    setState(() {
                      if (mornitorPopupBoolList.contains(true)) {
                        mornitorPopupBoolList = [false, false, false];
                      } else {
                        mornitorPopupBoolList = [true, true, true];
                      }
                    });
                  },
                  childWidget: const IdImgBox1(
                      key: ValueKey('123mainhead4'),
                      imageHeight: 57,
                      imageWidth: 32,
                      imagePath: 'assets/img/icon_chart.png',
                      imageFit: BoxFit.cover),
                ),
              ),
            ),
          ),
          _isBlurred
              ? Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(0), // 블러 효과만 적용
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
