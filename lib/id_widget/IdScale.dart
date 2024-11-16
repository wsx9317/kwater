import 'package:flutter/material.dart';
import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/IdSpace.dart';

class IdScale extends StatefulWidget {
  final double? scaleValue;
  const IdScale({super.key, this.scaleValue});

  @override
  State<IdScale> createState() => _IdScaleState();
}

class _IdScaleState extends State<IdScale> {
  double sacle = 1.0;

  String scaleStr() {
    String result = '';
    if (widget.scaleValue == 0) {
      result = '30m';
    } else if(widget.scaleValue == 1) {
      result = '33.0m';
    } else if(widget.scaleValue == 2) {
      result = '36.3m';
    } else if(widget.scaleValue == 3) {
      result = '39.9m';
    } else if(widget.scaleValue == 4) {
      result = '43.9m';
    } else if(widget.scaleValue == 5) {
      result = '48.3m';
    }else if(widget.scaleValue == 6) {
      result = '53.1m';
    } 
    return result;
  }

  @override
  Widget build(BuildContext context) {
    sacle = double.parse(GV.pStrg.getXXX(key_scale_value));

    return Row(
      children: [
        IdImgBox1(imageWidth: 30, imagePath: "assets/img/icon_scale.png", imageFit: BoxFit.fitWidth),
        IdSpace(spaceWidth: 8, spaceHeight: 0),
        uiCommon.styledText(scaleStr(), 14, 0, 1, FontWeight.w700, IdColors.white, TextAlign.start),
        // uiCommon.styledText('${(30 * sacle).toStringAsFixed(1)}m', 14, 0, 1, FontWeight.w700, IdColors.white, TextAlign.start),
        IdSpace(spaceWidth: 8, spaceHeight: 0),
        IdImgBox1(imageWidth: 125, imagePath: "assets/img/icon_scale_from.png", imageFit: BoxFit.fitWidth),
      ],
    );
  }
}
