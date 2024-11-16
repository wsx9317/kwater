import 'package:flutter/material.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class IdMerchinestatus extends StatefulWidget {
  const IdMerchinestatus({super.key});

  @override
  State<IdMerchinestatus> createState() => _IdMerchinestatusState();
}

class _IdMerchinestatusState extends State<IdMerchinestatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 332,
      height: 40,
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      decoration: BoxDecoration(
        color: IdColors.black40Per,
        border: Border.all(
          width: 1,
          color: IdColors.white16per,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //타이틀, 아이콘
          SizedBox(
            width: 107,
            child: Row(
              children: [
                uiCommon.styledText("수면포기기", 14, 0, 1, FontWeight.w700, IdColors.white, TextAlign.start),
                Spacer(),
                IdImgBox1(imageWidth: 20, imageHeight: 20, imagePath: "assets/img/icon_vane.png", imageFit: BoxFit.cover),
                IdSpace(spaceWidth: 8, spaceHeight: 0)
              ],
            ),
          ),
          //디바이더
          Container(
            width: 1,
            height: 10,
            color: IdColors.white40per,
          ),
          IdSpace(spaceWidth: 15, spaceHeight: 0),
          //기준선, 가동/미가동
          SizedBox(
            width: 175,
            child: Row(
              children: [
                SizedBox(
                  width: 106,
                  child: Row(
                    children: [
                      uiCommon.styledText('1', 12, 0, 1, FontWeight.w500, IdColors.white70per, TextAlign.center),
                      IdSpace(spaceWidth: 2, spaceHeight: 0),
                      Spacer(),
                      uiCommon.styledText('15', 12, 0, 1, FontWeight.w500, IdColors.white70per, TextAlign.center),
                    ],
                  ),
                ),
                IdSpace(spaceWidth: 8, spaceHeight: 0),
                uiCommon.styledText('미가동', 14, 0, 1, FontWeight.w400, IdColors.white70per, TextAlign.right),
                Spacer(),
                IdBtn(
                  onBtnPressed: () {},
                  childWidget: IdImgBox1(imageWidth: 16, imageHeight: 16, imagePath: 'assets/img/icon_dots.png', imageFit: BoxFit.cover),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
