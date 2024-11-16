import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart';
import 'package:kwater/api/kwater_api.dart';
import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdCalendar.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdHeader.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdScale.dart';
import 'package:kwater/id_widget/IdSliderBar.dart';
import 'package:kwater/id_widget/IdSpace.dart';
import 'package:kwater/id_widget/IdWaterGradiation.dart';
import 'package:kwater/id_widget/IdZoomBar.dart';
import 'package:kwater/id_widget/IdZoomDrag.dart';
import 'package:kwater/model/Kwater.dart';
import 'package:kwater/model/apiResultKwater.dart';
import 'package:kwater/popup/popWQstatus.dart';
import 'package:kwater/screens/Background.dart';

class Waterqualitystatus extends StatefulWidget {
  const Waterqualitystatus({super.key});

  @override
  State<Waterqualitystatus> createState() => _WaterqualitystatusState();
}

class _WaterqualitystatusState extends State<Waterqualitystatus> {
  double _value = 0.0;
  double zoomCnt = 0;
  final ZoomDragController _controller = ZoomDragController();
  int whealCnt = 0;
  int zoomActiveCnt = 0;
  List<int> zoomHistory = [0];
  //드롭다운, 캘린더 상태
  bool item1Bool = false;
  bool calendarEvent = false;
  bool futureBuilderShow = false;
  String savedDateTime = '';
  String searchDateTime = GV.pStrg.getXXX(key_date_val);
  //드롭다운 필수 변수
  String drop1Hint = ''; //드롭다운1 값
  List<String> _items1 = [
    '수온(℃)',
    'pH',
    '전기전도도',
    '탁도(NTU)',
    '광학DO (mg/L)',
    '용존산소(mg/L)',
    '클로로필-a',
    '피코시아닌',
  ];
  //수질확인일때 나오는 차트 팝업
  bool waterQualityCheckBool = false;
  bool setData1 = false;
  bool setData2 = false;
  bool setData3 = false;
  bool setData4 = false;
  bool setData5 = false;
  bool setData6 = false;
  bool setData7 = false;

  bool showPolygon = false;

  double max = 0;
  double min = 0;
  double mean = 0;

  double scale = 1.0;

  double sliderValue = 0;
  SliderBarController _controller3 = SliderBarController();

  List<List<List>> polygonDataList = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  int selectNum = 0;

  List<List<int>> colorPoint1List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint2List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint3List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint4List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint5List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint6List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint7List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint8List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint9List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint10List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint11List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint12List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint13List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint14List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint15List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint16List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint17List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint18List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint19List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint20List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint21List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint22List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint23List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint24List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint25List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint26List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint27List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint28List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint29List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];
  List<List<int>> colorPoint30List = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  List<int> colorPoint1 = [];
  List<int> colorPoint2 = [];
  List<int> colorPoint3 = [];
  List<int> colorPoint4 = [];
  List<int> colorPoint5 = [];
  List<int> colorPoint6 = [];
  List<int> colorPoint7 = [];
  List<int> colorPoint8 = [];
  List<int> colorPoint9 = [];
  List<int> colorPoint10 = [];
  List<int> colorPoint11 = [];
  List<int> colorPoint12 = [];
  List<int> colorPoint13 = [];
  List<int> colorPoint14 = [];
  List<int> colorPoint15 = [];
  List<int> colorPoint16 = [];
  List<int> colorPoint17 = [];
  List<int> colorPoint18 = [];
  List<int> colorPoint19 = [];
  List<int> colorPoint20 = [];
  List<int> colorPoint21 = [];
  List<int> colorPoint22 = [];
  List<int> colorPoint23 = [];
  List<int> colorPoint24 = [];
  List<int> colorPoint25 = [];
  List<int> colorPoint26 = [];
  List<int> colorPoint27 = [];
  List<int> colorPoint28 = [];
  List<int> colorPoint29 = [];
  List<int> colorPoint30 = [];

  List<List<double>> numericalValueList = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ];

  WaterFilter selectedFilter = WaterFilter.temp_deg_c;

  double checkNumericalValueList() {
    double result = 0;
    numericalValueList.forEach((subList) {
      subList.forEach((value) {
        result += value;
      });
    });
    return result;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    GV.pStrg.putXXX(key_scale_value, '1.0');
    GV.pStrg.putXXX(key_category_str, _items1[0]);
    drop1Hint = _items1[0];
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
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

  Widget arrowIcon(bool boxStatus) {
    return IdImgBox1(
        imageHeight: 16,
        imageWidth: 16,
        imagePath: (!boxStatus) ? 'assets/img/icon_down_arrow.png' : 'assets/img/icon_up_arrow.png',
        imageFit: BoxFit.cover);
  }

  //드롭다운 (type - c:달력, d:일반 드롭다운)
  Widget dropBox(
      Function() onBtnPressed, double width, double height, String hint1, String hint2, bool boxStatus, String type, Widget childWidget) {
    return Column(
      children: [
        IdBtn(
          onBtnPressed: onBtnPressed,
          childWidget: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(width: 1, color: boxStatus ? IdColors.white70per : IdColors.black16Per),
              color: IdColors.black40Per,
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    uiCommon.styledText(hint1, 14, 0, 1, FontWeight.w700, IdColors.white, TextAlign.left),
                    const IdSpace(spaceWidth: 9, spaceHeight: 0),
                    Container(width: 1, height: 10, color: IdColors.black40Per),
                    const IdSpace(spaceWidth: 8, spaceHeight: 0),
                    uiCommon.styledText(hint2, 14, 0, 1, FontWeight.w400, (type == 'd' && boxStatus) ? IdColors.white : IdColors.white40per,
                        TextAlign.left),
                    const Expanded(child: SizedBox()),
                    arrowIcon(boxStatus)
                  ],
                )),
          ),
        ),
        const IdSpace(spaceWidth: 0, spaceHeight: 4),
        Visibility(visible: boxStatus, child: childWidget)
      ],
    );
  }

  Widget dropDownItem(double width, List<String> itemList, List<Widget> childrenWidget) {
    return Container(
      width: width,
      height: (itemList.length >= 4) ? 330 : (itemList.length * 38) + 34,
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
          children: childrenWidget,
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    showPolygon = false;
    final String response = await rootBundle.loadString('assets/data/kw-status.csv');
    var d = const FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
    final List<List<dynamic>> rows = CsvToListConverter(csvSettingsDetector: d).convert(response);
    DateTime searchDate = DateFormat('yyyy-MM-dd').parse(GV.pStrg.getXXX(key_date_val));

    // 3일 전부터 3일 후까지의 날짜 계산
    DateTime threeDaysBefore = searchDate.subtract(const Duration(days: 3));
    DateTime twoDaysBefore = searchDate.subtract(const Duration(days: 2));
    DateTime oneDayBefore = searchDate.subtract(const Duration(days: 1));
    DateTime pickupDate = DateFormat('yyyy-MM-dd').parse(GV.pStrg.getXXX(key_date_val));
    DateTime oneDayAfter = searchDate.add(const Duration(days: 1));
    DateTime twoDaysAfter = searchDate.add(const Duration(days: 2));
    DateTime threeDaysAfter = searchDate.add(const Duration(days: 3));

    // 계산된 날짜들을 yyyy-MM-dd 형식의 문자열로 변환
    String threeDaysBeforeStr = DateFormat('yyyy-MM-dd').format(threeDaysBefore);
    String twoDaysBeforeStr = DateFormat('yyyy-MM-dd').format(twoDaysBefore);
    String oneDayBeforeStr = DateFormat('yyyy-MM-dd').format(oneDayBefore);
    String pickupDateStr = DateFormat('yyyy-MM-dd').format(pickupDate);
    String oneDayAfterStr = DateFormat('yyyy-MM-dd').format(oneDayAfter);
    String twoDaysAfterStr = DateFormat('yyyy-MM-dd').format(twoDaysAfter);
    String threeDaysAfterStr = DateFormat('yyyy-MM-dd').format(threeDaysAfter);

    if (sliderValue == 0) {
      searchDateTime = threeDaysBeforeStr;
    } else if (sliderValue == 1) {
      searchDateTime = twoDaysBeforeStr;
    } else if (sliderValue == 2) {
      searchDateTime = oneDayBeforeStr;
    } else if (sliderValue == 3) {
      searchDateTime = pickupDateStr;
    } else if (sliderValue == 4) {
      searchDateTime = oneDayAfterStr;
    } else if (sliderValue == 5) {
      searchDateTime = twoDaysAfterStr;
    } else {
      searchDateTime = threeDaysAfterStr;
    }
// //TODO test를 위해서 임시 필터 설정
//     selectedFilter = WaterFilter.chl_ug_l;

    if (selectNum == 0) {
      selectedFilter = WaterFilter.temp_deg_c;
    } else if (selectNum == 1) {
      selectedFilter = WaterFilter.ph_units;
    } else if (selectNum == 2) {
      selectedFilter = WaterFilter.spcond_us_cm;
    } else if (selectNum == 3) {
      selectedFilter = WaterFilter.turb_ntu;
    } else if (selectNum == 4) {
      selectedFilter = WaterFilter.hdo_mg_l;
    } else if (selectNum == 5) {
      selectedFilter = WaterFilter.ph_mv;
    } else if (selectNum == 6) {
      selectedFilter = WaterFilter.chl_ug_l;
    } else if (selectNum == 7) {
      selectedFilter = WaterFilter.bg_ppb;
    }

    final List<ApiResultKWater>? ret1 = await KwaterApi.getWaterQualityHistory(selectedFilter, threeDaysBeforeStr);

    final List<ApiResultKWater>? ret2 = await KwaterApi.getWaterQualityHistory(selectedFilter, twoDaysBeforeStr);

    final List<ApiResultKWater>? ret3 = await KwaterApi.getWaterQualityHistory(selectedFilter, oneDayBeforeStr);

    final List<ApiResultKWater>? ret4 = await KwaterApi.getWaterQualityHistory(selectedFilter, pickupDateStr);

    final List<ApiResultKWater>? ret5 = await KwaterApi.getWaterQualityHistory(selectedFilter, oneDayAfterStr);

    final List<ApiResultKWater>? ret6 = await KwaterApi.getWaterQualityHistory(selectedFilter, twoDaysAfterStr);

    final List<ApiResultKWater>? ret7 = await KwaterApi.getWaterQualityHistory(selectedFilter, threeDaysAfterStr);

    putListData(0, ret1, setData1);
    putListData(1, ret2, setData2);
    putListData(2, ret3, setData3);
    putListData(3, ret4, setData4);
    putListData(4, ret5, setData5);
    putListData(5, ret6, setData6);
    putListData(6, ret7, setData7);

    final ApiResultKWater? ret8 = await KwaterApi.getStatistics(selectedFilter, threeDaysBeforeStr);
    final ApiResultKWater? ret9 = await KwaterApi.getStatistics(selectedFilter, twoDaysBeforeStr);
    final ApiResultKWater? ret10 = await KwaterApi.getStatistics(selectedFilter, oneDayBeforeStr);
    final ApiResultKWater? ret11 = await KwaterApi.getStatistics(selectedFilter, pickupDateStr);
    final ApiResultKWater? ret12 = await KwaterApi.getStatistics(selectedFilter, oneDayAfterStr);
    final ApiResultKWater? ret13 = await KwaterApi.getStatistics(selectedFilter, twoDaysAfterStr);
    final ApiResultKWater? ret14 = await KwaterApi.getStatistics(selectedFilter, threeDaysAfterStr);

    setMinMaxNumber(ret8, 0);
    setMinMaxNumber(ret9, 1);
    setMinMaxNumber(ret10, 2);
    setMinMaxNumber(ret11, 3);
    setMinMaxNumber(ret12, 4);
    setMinMaxNumber(ret13, 5);
    setMinMaxNumber(ret14, 6);

    for (var i = 0; i < polygonDataList.length; i++) {
      for (var row in rows.skip(1)) {
        var idValue = int.parse(row[0].toString());
        int geometryValue = 0;
        if (colorPoint1List[i].contains(idValue)) {
          geometryValue = 1;
        } else if (colorPoint2List[i].contains(idValue)) {
          geometryValue = 2;
        } else if (colorPoint3List[i].contains(idValue)) {
          geometryValue = 3;
        } else if (colorPoint4List[i].contains(idValue)) {
          geometryValue = 4;
        } else if (colorPoint5List[i].contains(idValue)) {
          geometryValue = 5;
        } else if (colorPoint6List[i].contains(idValue)) {
          geometryValue = 6;
        } else if (colorPoint7List[i].contains(idValue)) {
          geometryValue = 7;
        } else if (colorPoint8List[i].contains(idValue)) {
          geometryValue = 8;
        } else if (colorPoint9List[i].contains(idValue)) {
          geometryValue = 9;
        } else if (colorPoint10List[i].contains(idValue)) {
          geometryValue = 10;
        } else if (colorPoint11List[i].contains(idValue)) {
          geometryValue = 11;
        } else if (colorPoint12List[i].contains(idValue)) {
          geometryValue = 12;
        } else if (colorPoint13List[i].contains(idValue)) {
          geometryValue = 13;
        } else if (colorPoint14List[i].contains(idValue)) {
          geometryValue = 14;
        } else if (colorPoint15List[i].contains(idValue)) {
          geometryValue = 15;
        } else if (colorPoint16List[i].contains(idValue)) {
          geometryValue = 16;
        } else if (colorPoint17List[i].contains(idValue)) {
          geometryValue = 17;
        } else if (colorPoint18List[i].contains(idValue)) {
          geometryValue = 18;
        } else if (colorPoint19List[i].contains(idValue)) {
          geometryValue = 19;
        } else if (colorPoint20List[i].contains(idValue)) {
          geometryValue = 20;
        } else if (colorPoint21List[i].contains(idValue)) {
          geometryValue = 21;
        } else if (colorPoint22List[i].contains(idValue)) {
          geometryValue = 22;
        } else if (colorPoint23List[i].contains(idValue)) {
          geometryValue = 23;
        } else if (colorPoint24List[i].contains(idValue)) {
          geometryValue = 24;
        } else if (colorPoint25List[i].contains(idValue)) {
          geometryValue = 25;
        } else if (colorPoint26List[i].contains(idValue)) {
          geometryValue = 26;
        } else if (colorPoint27List[i].contains(idValue)) {
          geometryValue = 27;
        } else if (colorPoint28List[i].contains(idValue)) {
          geometryValue = 28;
        } else if (colorPoint29List[i].contains(idValue)) {
          geometryValue = 29;
        } else if (colorPoint30List[i].contains(idValue)) {
          geometryValue = 30;
        }
        polygonDataList[i].add([idValue, geometryValue]);
      }
      polygonDataList[i].sort((a, b) => a[0].compareTo(b[0]));
    }

    sliderValue = 3;

    setState(() {});
  }

  void putListData(int apiNum, List<ApiResultKWater>? ret, bool setData) {
    colorPoint1 = [];
    colorPoint2 = [];
    colorPoint3 = [];
    colorPoint4 = [];
    colorPoint5 = [];
    colorPoint6 = [];
    colorPoint7 = [];
    colorPoint8 = [];
    colorPoint9 = [];
    colorPoint10 = [];
    colorPoint11 = [];
    colorPoint12 = [];
    colorPoint13 = [];
    colorPoint14 = [];
    colorPoint15 = [];
    colorPoint16 = [];
    colorPoint17 = [];
    colorPoint18 = [];
    colorPoint19 = [];
    colorPoint20 = [];
    colorPoint21 = [];
    colorPoint22 = [];
    colorPoint23 = [];
    colorPoint24 = [];
    colorPoint25 = [];
    colorPoint26 = [];
    colorPoint27 = [];
    colorPoint28 = [];
    colorPoint29 = [];
    colorPoint30 = [];
    setState(() {
      if (ret != null && ret.isNotEmpty) {
        for (var i = 0; i < ret.length; i++) {
          if (ret[i].envDataPerCell! == 1) {
            colorPoint1.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 2) {
            colorPoint2.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 3) {
            colorPoint3.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 4) {
            colorPoint4.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 5) {
            colorPoint5.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 6) {
            colorPoint6.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 7) {
            colorPoint7.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 8) {
            colorPoint8.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 9) {
            colorPoint9.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 10) {
            colorPoint10.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 11) {
            colorPoint11.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 12) {
            colorPoint12.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 13) {
            colorPoint13.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 14) {
            colorPoint14.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 15) {
            colorPoint15.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 16) {
            colorPoint16.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 17) {
            colorPoint17.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 18) {
            colorPoint18.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 19) {
            colorPoint19.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 20) {
            colorPoint20.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 21) {
            colorPoint21.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 22) {
            colorPoint22.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 23) {
            colorPoint23.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 24) {
            colorPoint24.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 25) {
            colorPoint25.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 26) {
            colorPoint26.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 27) {
            colorPoint27.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 28) {
            colorPoint28.add(int.parse(ret[i].gridId!.toString()));
          } else if (ret[i].envDataPerCell! == 29) {
            colorPoint29.add(int.parse(ret[i].gridId!.toString()));
          } else {
            colorPoint30.add(int.parse(ret[i].gridId!.toString()));
          }
        }
        setData = true;
      } else {
        setData = true;
      }

      colorPoint1List[apiNum] = colorPoint1;
      colorPoint2List[apiNum] = colorPoint2;
      colorPoint3List[apiNum] = colorPoint3;
      colorPoint4List[apiNum] = colorPoint4;
      colorPoint5List[apiNum] = colorPoint5;
      colorPoint6List[apiNum] = colorPoint6;
      colorPoint7List[apiNum] = colorPoint7;
      colorPoint8List[apiNum] = colorPoint8;
      colorPoint9List[apiNum] = colorPoint9;
      colorPoint10List[apiNum] = colorPoint11;
      colorPoint11List[apiNum] = colorPoint11;
      colorPoint12List[apiNum] = colorPoint12;
      colorPoint13List[apiNum] = colorPoint13;
      colorPoint14List[apiNum] = colorPoint14;
      colorPoint15List[apiNum] = colorPoint15;
      colorPoint16List[apiNum] = colorPoint16;
      colorPoint17List[apiNum] = colorPoint17;
      colorPoint18List[apiNum] = colorPoint18;
      colorPoint19List[apiNum] = colorPoint19;
      colorPoint20List[apiNum] = colorPoint20;
      colorPoint21List[apiNum] = colorPoint21;
      colorPoint22List[apiNum] = colorPoint22;
      colorPoint23List[apiNum] = colorPoint23;
      colorPoint24List[apiNum] = colorPoint24;
      colorPoint25List[apiNum] = colorPoint25;
      colorPoint26List[apiNum] = colorPoint26;
      colorPoint27List[apiNum] = colorPoint27;
      colorPoint28List[apiNum] = colorPoint28;
      colorPoint29List[apiNum] = colorPoint29;
      colorPoint30List[apiNum] = colorPoint30;
    });
  }

  void setMinMaxNumber(ApiResultKWater? ret, int apiNum) {
    double envMean = 0;
    double envMax = 0;
    double envMin = 0;
    if (ret != null) {
      if (ret.envMean != null) {
        envMean = double.parse(ret.envMean!.toStringAsFixed(1));
      }
      if (ret.envMax != null) {
        envMax = double.parse(ret.envMax!.toStringAsFixed(1));
      }
      if (ret.envMin != null) {
        envMin = double.parse(ret.envMin!.toStringAsFixed(1));
      }

      numericalValueList[apiNum] = [envMean, envMax, envMin];
    } else {
      numericalValueList[apiNum] = [0, 0, 0];
    }
  }

  Widget sliderStandard(Function() onBtnPressed, Color standardColor) {
    return IdBtn(
        onBtnPressed: onBtnPressed,
        childWidget: Container(
          width: 1,
          height: 5,
          color: standardColor,
        ));
  }

  @override
  Widget build(BuildContext context) {
    scale = double.parse(GV.pStrg.getXXX(key_scale_value));
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
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                checkNumericalValueList() == 0
                                    ? Image.asset(
                                        'assets/img/map16x2.jpg',
                                        key: const ValueKey('polygonwidet123_map16x2_123'),
                                        width: 1920,
                                        height: 1920,
                                        fit: BoxFit.cover,
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: (sliderValue == 0) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[0],
                                            ),
                                          ),
                                          Visibility(
                                            visible: (sliderValue == 1) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[1],
                                            ),
                                          ),
                                          Visibility(
                                            visible: (sliderValue == 2) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[2],
                                            ),
                                          ),
                                          Visibility(
                                            visible: (sliderValue == 3) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[3],
                                            ),
                                          ),
                                          Visibility(
                                            visible: (sliderValue == 4) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[4],
                                            ),
                                          ),
                                          Visibility(
                                            visible: (sliderValue == 5) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[5],
                                            ),
                                          ),
                                          Visibility(
                                            visible: (sliderValue == 6) ? true : false,
                                            child: Background(
                                              key: ValueKey('kwater_back2'),
                                              showPolygon: showPolygon,
                                              showDevice: false,
                                              showIcon: true,
                                              setData: true,
                                              robotPathHistory: const [
                                                [0, 0]
                                              ],
                                              polygonIdList: polygonDataList[6],
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    // 수질색상 표시
                    Visibility(
                      visible: showPolygon,
                      child: Row(
                        children: [
                          const IdSpace(spaceWidth: 8, spaceHeight: 0),
                          IdWatergradiation(
                            width: 70,
                            gradiationHeight: 170,
                            padding: const EdgeInsets.fromLTRB(14, 16, 13, 16),
                            showTitle: false,
                            max: max,
                            min: min,
                            mean: mean,
                          ),
                        ],
                      ),
                    ),
                  ],
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
              pageStateNum: 1,
              logoEvent: () {
                uiCommon.IdMovePage(context, PAGE_MORNITORING_PAGE);
              },
              menu1Event: () {
                uiCommon.IdMovePage(context, PAGE_MORNITORING_PAGE);
              },
              menu2Event: () {},
              menu3Event: () {
                uiCommon.IdMovePage(context, PAGE_WQPREDICTION_PAGE);
              },
              menu4Event: () {
                uiCommon.IdMovePage(context, PAGE_DECISION_PAGE);
              },
              subMenuWidget: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dropBox(
                      () {
                        waterQualityCheckBool = false;
                        showPolygon = false;
                        if (item1Bool) {
                          item1Bool = false;
                        } else {
                          item1Bool = true;
                          if (calendarEvent) {
                            calendarEvent = false;
                          }
                        }
                        setState(() {});
                      },
                      193,
                      40,
                      '항목',
                      drop1Hint,
                      item1Bool,
                      'd',
                      dropDownItem(
                        193,
                        _items1,
                        List.generate(
                          _items1.length,
                          (index) => HoverContainer(
                            width: double.infinity,
                            height: 38,
                            hoverDecoration: BoxDecoration(
                              color: IdColors.black10Per,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IdBtn(
                              onBtnPressed: () {
                                setState(() {
                                  drop1Hint = _items1[index];
                                  item1Bool = false;
                                  selectNum = index;
                                  GV.pStrg.putXXX(key_category_str, _items1[index]);
                                });
                              },
                              childWidget: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                    child:
                                        uiCommon.styledText(_items1[index], 14, 0, 1, FontWeight.w400, IdColors.white, TextAlign.center)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const IdSpace(spaceWidth: 8, spaceHeight: 0),
                    dropBox(() {
                      waterQualityCheckBool = false;
                      showPolygon = false;
                      if (calendarEvent) {
                        calendarEvent = false;
                      } else {
                        calendarEvent = true;
                        if (item1Bool) {
                          item1Bool = false;
                        }
                      }
                      setState(() {});
                    }, 204, 40, '날짜선택', GV.pStrg.getXXX(key_date_val), calendarEvent, 'c', const SizedBox()),
                    const IdSpace(spaceWidth: 15, spaceHeight: 0),
                    IdBtn(
                      onBtnPressed: (calendarEvent || item1Bool)
                          ? () {}
                          : () {
                              setState(() {
                                if (!waterQualityCheckBool) {
                                  polygonDataList = [
                                    [],
                                    [],
                                    [],
                                    [],
                                    [],
                                    [],
                                    [],
                                  ];
                                  sliderValue = 0;
                                  fetchData();
                                  waterQualityCheckBool = true;
                                  showPolygon = true;
                                  futureBuilderShow = true;
                                } else {
                                  waterQualityCheckBool = false;
                                  showPolygon = false;
                                }
                              });
                            },
                      childWidget: Stack(
                        children: [
                          Container(
                            width: 73,
                            height: 40,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: IdColors.black,
                            ),
                          ),
                          Container(
                            width: 73,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: (calendarEvent || item1Bool) ? IdColors.white40per : IdColors.skyblue,
                            ),
                          ),
                          SizedBox(
                              width: 73,
                              height: 40,
                              child: Center(
                                child: uiCommon.styledText('확인', 14, 0, 1, FontWeight.w700, IdColors.white, TextAlign.center),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //달력
          Visibility(
            visible: calendarEvent,
            child: Positioned(
              top: 59,
              right: 121,
              child: IdCalendar(
                calendarWidth: 328,
                cloesFunction: () {
                  setState(() {
                    calendarEvent = false;
                  });
                },
                completeFunction: () {
                  setState(() {
                    savedDateTime = GV.pStrg.getXXX(key_date_val);
                    String yearStr = savedDateTime.split('-')[0];
                    String monthStr = "";
                    String dayStr = "";

                    if (int.parse(savedDateTime.split('-')[1]) >= 10) {
                      monthStr = savedDateTime.split('-')[1];
                    } else {
                      monthStr = "0${int.parse(savedDateTime.split('-')[1])}";
                    }
                    if (int.parse(savedDateTime.split('-')[2]) >= 10) {
                      dayStr = savedDateTime.split('-')[2];
                    } else {
                      dayStr = "0${int.parse(savedDateTime.split('-')[2])}";
                    }

                    searchDateTime = '$yearStr-$monthStr-$dayStr';

                    calendarEvent = false;
                    futureBuilderShow = true;
                  });
                },
                savedDateTimeData: savedDateTime,
              ),
            ),
          ),

          //수질현황 팝업
          Visibility(
            visible: waterQualityCheckBool,
            child: Positioned(
              top: 70,
              right: 40,
              child: PopWqStatus(
                title: GV.pStrg.getXXX(key_category_str),
                averageWq: numericalValueList[int.parse(sliderValue.toString())][0],
                maxWq: numericalValueList[int.parse(sliderValue.toString())][1],
                minWq: numericalValueList[int.parse(sliderValue.toString())][2],
                slideWidget: Idsliderbar(
                  valeu: sliderValue,
                  axis: Axis.horizontal,
                  min: 0,
                  max: 6,
                  onChanged: (p0, p1, p2) {
                    sliderValue = p1.toDouble();
                    max = numericalValueList[sliderValue.toInt()][1];
                    min = numericalValueList[sliderValue.toInt()][2];
                    mean = numericalValueList[sliderValue.toInt()][0];
                    setState(() {});
                  },
                ),
                standartWidget: Row(
                  children: [
                    IdSpace(spaceWidth: 8, spaceHeight: 0),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 0;
                      });
                    }, IdColors.white),
                    const Spacer(),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 1;
                      });
                    }, IdColors.white40per),
                    const Spacer(),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 2;
                      });
                    }, IdColors.white40per),
                    const Spacer(),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 3;
                      });
                    }, IdColors.white),
                    const Spacer(),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 4;
                      });
                    }, IdColors.white40per),
                    const Spacer(),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 5;
                      });
                    }, IdColors.white40per),
                    const Spacer(),
                    sliderStandard(() {
                      setState(() {
                        sliderValue = 6;
                      });
                    }, IdColors.white),
                    IdSpace(spaceWidth: 8, spaceHeight: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
