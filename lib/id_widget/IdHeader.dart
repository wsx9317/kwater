import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class Idheader extends StatefulWidget {
  final int pageStateNum;
  final Function() logoEvent;
  final Function() menu1Event;
  final Function() menu2Event;
  final Function() menu3Event;
  final Function() menu4Event;
  final Widget subMenuWidget;

  const Idheader({
    Key? key,
    required this.pageStateNum,
    required this.logoEvent,
    required this.menu1Event,
    required this.menu2Event,
    required this.menu3Event,
    required this.menu4Event,
    required this.subMenuWidget,
  }) : super(key: key);

  @override
  State<Idheader> createState() => _IdheaderState();
}

class _IdheaderState extends State<Idheader> {
  String searchDateTime = GV.pStrg.getXXX(key_date_val);

  bool vaneActive = false; //기게 작동 유무
  int vaneCnt = 0; //기기 총수

  String savedDateTime = '';

  DateTime now = DateTime.now();

  double sliderValue = 3;


  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();

    String formationDate = DateFormat('yyyy-MM-dd').format(today);

    GV.pStrg.putXXX(key_date_val, formationDate);
    vaneActive = true;
    vaneCnt = 4;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget menuBtn(String btnNm, int btnNum, Function() onBtnPressed) {
    return IdBtn(
      onBtnPressed: onBtnPressed,
      childWidget: Padding(
        padding: EdgeInsets.symmetric(vertical: (btnNum == widget.pageStateNum) ? 4 : 12, horizontal: 24),
        child:
            uiCommon.styledText(btnNm, (btnNum == widget.pageStateNum) ? 24 : 16, 0, 1, FontWeight.w700, IdColors.white, TextAlign.center),
      ),
    );
  }

  Widget arrowIcon(bool boxStatus) {
    return IdImgBox1(
        imageHeight: 16,
        imageWidth: 16,
        imagePath: (!boxStatus) ? 'assets/img/icon_down_arrow.png' : 'assets/img/icon_up_arrow.png',
        imageFit: BoxFit.cover);
  }

  Widget machineActive(Widget childWidget) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: IdColors.white16per,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: vaneActive
                ? childWidget
                : IdImgBox1(imageHeight: 20, imageWidth: 20, imagePath: "assets/img/icon_vane_none_active.png", imageFit: BoxFit.cover),
          ),
        ),
        const IdSpace(spaceWidth: 8, spaceHeight: 0),
      ],
    );
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
      height: (itemList.length >= 4) ? 184 : (itemList.length * 38) + 34,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          width: double.infinity,
          height: 500,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IdSpace(spaceWidth: 40, spaceHeight: 0),
                //로고
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: IdBtn(
                    onBtnPressed: widget.logoEvent,
                    childWidget:
                        const IdImgBox1(imageWidth: 79.64, imageHeight: 36, imagePath: 'assets/img/logo.png', imageFit: BoxFit.cover),
                  ),
                ),
                const IdSpace(spaceWidth: 24, spaceHeight: 0),
                const IdSpace(spaceWidth: 24, spaceHeight: 0),
                //메뉴
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Row(
                    children: [
                      menuBtn(
                        '모니터링',
                        0,
                        widget.menu1Event,
                      ),
                      menuBtn(
                        '수질현황',
                        1,
                        widget.menu2Event,
                      ),
                      menuBtn(
                        '수질예측',
                        2,
                        widget.menu3Event,
                      ),
                      menuBtn(
                        '의사결정',
                        3,
                        widget.menu4Event,
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                widget.subMenuWidget,
                const IdSpace(spaceWidth: 40, spaceHeight: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
