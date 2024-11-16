import 'package:flutter/material.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdCloesBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class Popareapicture extends StatefulWidget {
  final String area;
  final Color wqColor;
  final Function() cloesBtnEvent;
  final int areaId;
  const Popareapicture({
    super.key,
    required this.area,
    required this.wqColor,
    required this.cloesBtnEvent,
    required this.areaId,
  });

  @override
  State<Popareapicture> createState() => _PopareapictureState();
}

class _PopareapictureState extends State<Popareapicture> {
  List<String> areaImgPath = [
    'assets/img/img-area1.jpg',
    'assets/img/img-area2.jpg',
    'assets/img/img-area3.png',
    'assets/img/img-area4.png',
    'assets/img/img-area5.jpg',
    'assets/img/img-area6.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: IdColors.black40Per,
          border: Border.all(
            width: 1,
            color: IdColors.white16per,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          //수질색상, 구역, 취소
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                color: widget.wqColor,
              ),
              const IdSpace(spaceWidth: 8, spaceHeight: 0),
              uiCommon.styledText('${widget.area} 구역', 15, 0, 1,
                  FontWeight.w700, IdColors.white, TextAlign.center),
              Spacer(),
              IdClosebtn(onBtnPressed: widget.cloesBtnEvent)
            ],
          ),
          IdSpace(spaceWidth: 0, spaceHeight: 16),
          IdImgBox1(
            key: ValueKey("popDesisionImg123"),
            imageWidth: double.infinity,
            imageHeight: 300,
              imagePath: areaImgPath[widget.areaId],
              imageFit: BoxFit.cover)
        ],
      ),
    );
  }
}
