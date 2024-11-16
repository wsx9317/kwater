import 'package:flutter/material.dart';
import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class IdCalendar extends StatefulWidget {
  final double calendarWidth;
  final Function() cloesFunction;
  final Function() completeFunction;
  final String savedDateTimeData;
  const IdCalendar(
      {super.key,
      required this.calendarWidth,
      required this.cloesFunction,
      required this.completeFunction,
      required this.savedDateTimeData});

  @override
  State<IdCalendar> createState() => _IdCalendarState();
}

class _IdCalendarState extends State<IdCalendar> {
  //오늘 날짜
  DateTime now = DateTime.now();
  int year = 0;
  int month = 0;
  int day = 0;
  int dailyCnt = 0;

  int weekCnt = 0;

  //달의 첫 요일 구하기
  String firstDayOfWeek = '';

  //요일 구분
  List<String> weekList = [];

  //날짜 채우기
  List<String> monthlyDayList = [];

  String yearStr = '';
  String monthStr = '';
  String dayStr = '';

  String yearCheck = '';
  String monthCheck = '';
  String dayCheck = '';

  String dateTimeStr = '';

  String savedDateTime = '';

  @override
  void initState() {
    super.initState();

    savedDateTime = widget.savedDateTimeData;
    if (savedDateTime == '') {
      year = now.year;
      month = now.month;
      day = now.day;
    } else {
      year = int.parse(savedDateTime.split('-')[0]);
      month = int.parse(savedDateTime.split('-')[1]);
      day = int.parse(savedDateTime.split('-')[2]);
    }

    weekList = [
      "SUN",
      "MON",
      "TUE",
      "WED",
      "THU",
      "FRI",
      "SAT",
    ];
    monthlyDayCnt();
    firstDay();
    monthlyDay();
  }

  void monthlyDayCnt() {
    dailyCnt = DateTime(year, month + 1, 0).day;

    if (dailyCnt % 7 == 0) {
      weekCnt = dailyCnt ~/ 7;
    } else {
      weekCnt = (dailyCnt ~/ 7) + 1;
    }
  }

  void firstDay() {
    // 해당 월의 첫날 구하기
    DateTime firstDay = DateTime(year, month, 1);
    firstDayOfWeek = weekList[(firstDay.weekday % 7)]; // 1=월요일, 7=일요일
  }

  void monthlyDay() {
    monthlyDayList = [];
    DateTime firstDay = DateTime(year, month, 1);
    //그 달의 첫날보다 앞에는 공백으로
    for (var i = 0; i < firstDay.weekday % 7; i++) {
      monthlyDayList.add("");
    }
    //날짜들 넣기
    for (var i = 0; i < dailyCnt; i++) {
      monthlyDayList.add((i + 1).toString());
    }
  }

  Widget chageMonthBtn(Function() onBtnPressed, String imgPath) {
    return IdBtn(
      onBtnPressed: onBtnPressed,
      childWidget: IdImgBox1(imageWidth: 24, imageHeight: 24, imagePath: imgPath, imageFit: BoxFit.cover),
    );
  }

  Widget flexSpace() {
    return Expanded(child: SizedBox());
  }

  Widget yearAndMonth() {
    String result = "$year년 $month월";
    return uiCommon.styledText(result, 15, 0, 1, FontWeight.w700, IdColors.white, TextAlign.center);
  }

  Widget calendarRow1(int Rowcnt) {
    return Row(
      children: List.generate(
        7,
        (index) => IdBtn(
          onBtnPressed: () {
            yearStr = year.toString();
            monthStr = month.toString();
            dayStr = monthlyDayList[index + (7 * Rowcnt)].toString();

            dateTimeStr = '$yearStr-$monthStr-$dayStr';
            GV.pStrg.putXXX(key_date_val, dateTimeStr);

            savedDateTime = '';
            setState(() {});
          },
          childWidget: Container(
            width: (widget.calendarWidth - 50) / 7,
            height: (widget.calendarWidth - 50) / 7,
            decoration: BoxDecoration(
                color: (savedDateTime == ('$year-$month-${monthlyDayList[index + (7 * Rowcnt)]}'))
                    ? IdColors.skyblue
                    : (dateTimeStr == ('$year-$month-${monthlyDayList[index + (7 * Rowcnt)]}'))
                        ? IdColors.skyblue
                        : IdColors.invisiable,
                shape: BoxShape.circle),
            child: Center(
                child: uiCommon.styledText(
                    monthlyDayList[index + (7 * Rowcnt)], 14, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.center)),
          ),
        ),
      ),
    );
  }

  Widget calendarRow2() {
    int indexCnt = 0;
    if (monthlyDayList.length - 28 <= 7) {
      indexCnt = monthlyDayList.length - 28;
    } else {
      indexCnt = 7;
    }
    return Row(
      children: List.generate(
        indexCnt,
        (index) => IdBtn(
          onBtnPressed: () {
            yearStr = year.toString();
            monthStr = month.toString();
            dayStr = monthlyDayList[index + 28].toString();

            dateTimeStr = '$yearStr-$monthStr-$dayStr';
            GV.pStrg.putXXX(key_date_val, dateTimeStr);

            savedDateTime = '';
            setState(() {});
          },
          childWidget: Container(
            width: (widget.calendarWidth - 50) / 7,
            height: (widget.calendarWidth - 50) / 7,
            decoration: BoxDecoration(
                color: (savedDateTime == ('$year-$month-${monthlyDayList[index + 28]}'))
                    ? IdColors.skyblue
                    : (dateTimeStr == ('$year-$month-${monthlyDayList[index + 28]}'))
                        ? IdColors.skyblue
                        : IdColors.invisiable,
                shape: BoxShape.circle),
            child: Center(
                child: uiCommon.styledText(monthlyDayList[index + 28], 14, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.center)),
          ),
        ),
      ),
    );
  }

  Widget calendarRow3() {
    Widget result = SizedBox();
    int indexCnt = 0;
    if (monthlyDayList.length >= 36) {
      indexCnt = monthlyDayList.length - 35;
      result = Row(
        children: List.generate(
          indexCnt,
          (index) => IdBtn(
            onBtnPressed: () {
              yearStr = year.toString();
              monthStr = month.toString();
              dayStr = monthlyDayList[index + 35].toString();

              dateTimeStr = '$yearStr-$monthStr-$dayStr';
              GV.pStrg.putXXX(key_date_val, dateTimeStr);

              savedDateTime = '';
              setState(() {});
            },
            childWidget: Container(
              width: (widget.calendarWidth - 50) / 7,
              height: (widget.calendarWidth - 50) / 7,
              decoration: BoxDecoration(
                  color: (savedDateTime == ('$year-$month-${monthlyDayList[index + 35]}'))
                      ? IdColors.skyblue
                      : (dateTimeStr == ('$year-$month-${monthlyDayList[index + 35]}'))
                          ? IdColors.skyblue
                          : IdColors.invisiable,
                  shape: BoxShape.circle),
              child: Center(
                  child: uiCommon.styledText(monthlyDayList[index + 35], 14, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.center)),
            ),
          ),
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.calendarWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: IdColors.black40Per,
          border: Border.all(
            width: 1,
            color: IdColors.white70per,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          //년, 월 셀렉
          Row(
            children: [
              chageMonthBtn(() {
                setState(() {
                  if (month == 1) {
                    month = 12;
                    year--;
                  } else {
                    month--;
                  }
                  monthlyDayCnt();
                  firstDay();
                  monthlyDay();
                });
              }, "assets/img/icon_before.png"),
              flexSpace(),
              yearAndMonth(),
              flexSpace(),
              chageMonthBtn(() {
                setState(() {
                  if (month == 12) {
                    month = 1;
                    year++;
                  } else {
                    month++;
                  }
                  monthlyDayCnt();
                  firstDay();
                  monthlyDay();
                });
              }, "assets/img/icon_after.png"),
            ],
          ),
          const IdSpace(spaceWidth: 0, spaceHeight: 24),
          //날짜 구분
          Row(
            children: List.generate(
              weekList.length,
              (index) => SizedBox(
                width: (widget.calendarWidth - 50) / 7,
                height: 24,
                child: uiCommon.styledText(weekList[index], 12, 0, 1, FontWeight.w700, IdColors.white90per, TextAlign.center),
              ),
            ),
          ),
          const IdSpace(spaceWidth: 0, spaceHeight: 24),
          //실제 날짜
          Column(children: [
            calendarRow1(0),
            calendarRow1(1),
            calendarRow1(2),
            calendarRow1(3),
            Visibility(
              visible: (dailyCnt ~/ 7 == 4) ? true : false,
              child: calendarRow2(),
            ),
            Visibility(
              visible: (monthlyDayList.length > 35) ? true : false,
              child: calendarRow3(),
            ),
          ]),
          const IdSpace(spaceWidth: 0, spaceHeight: 24),
          //하단 버튼
          Row(
            children: [
              IdBtn(
                onBtnPressed: widget.cloesFunction,
                childWidget: Container(
                  width: 53,
                  height: 32,
                  decoration: BoxDecoration(color: IdColors.white40per, borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: uiCommon.styledText('닫기', 12, 0, 1, FontWeight.w700, IdColors.white, TextAlign.center),
                  ),
                ),
              ),
              const IdSpace(spaceWidth: 8, spaceHeight: 0),
              Expanded(
                child: IdBtn(
                    onBtnPressed: widget.completeFunction,
                    childWidget: Container(
                      height: 32,
                      decoration: BoxDecoration(color: IdColors.skyblue, borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: uiCommon.styledText('확인', 12, 0, 1, FontWeight.w700, IdColors.white, TextAlign.center),
                      ),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
