// ignore_for_file: non_constant_identifier_names, prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:indexed/indexed.dart';

// import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:styled_text/styled_text.dart';

import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../constants/Theme.dart';
// import '../db_widget/db_toast.dart';
import '../id_widget/IdColor.dart';
// import '../id_widget/IdRoundedBtn.dart';
import 'globalvar.dart';
// import 'package:url_launcher/link.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_text/tags/styled_text_tag_base.dart';

enum IdUnit { none, kg, percent, star }

const String DATE_FORMAT = 'yyyy-MM-dd HH:mm';

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE
]);

T to<T>(dynamic i, {required T defaultValue}) {
  if (i == null) {
    return defaultValue;
  }
  if (i is T) {
    return i;
  }
  if (i is String) {
    switch (T) {
      case double:
        return (double.tryParse(i) ?? defaultValue) as T;
      case int:
        return (int.tryParse(i) ?? defaultValue) as T;
      case bool:
        return ((int.tryParse(i) ?? 0) > 0) as T;
      default:
        return defaultValue;
    }
  }
  if (i is num) {
    switch (T) {
      case double:
        return (i.toDouble()) as T;
      case int:
        return (i.toInt()) as T;
      case String:
        return '$i' as T;
      case bool:
        return (i > 0) as T;
      default:
        return defaultValue;
    }
  }
  return (i is T) ? i : defaultValue;
}

mixin uiCommon {
  static double standardWidth = 744;
  static double standardHeight = 1133;
  static double getScreenRatio() {
    double orgWidth = 1920;
    double curWidth = GV.screen.width;

    if (orgWidth != 1920) return 1.0;

    double ret = 1.0;
    // if (curWidth > orgWidth) {
    ret = curWidth / orgWidth;
    // }
    if (ret < 0.8) ret = 0.8;

    //GV.d(orgWidth, curWidth, ret);

    return ret;
  }

  static double rSet(double value, [double? ratio]) {
    return value;
  }

  static void setScreen(BuildContext context) {
    GV.screen = MediaQuery.of(context).size;
  }

  static bool _isNeededForceQuit(String m1) {
    return false;
  }

  static bool _isPopupWindow(String m1) {
    return false;
  }

  static Future<bool> IdMovePage(BuildContext context, String toGomenu, {String? param}) async {
    var curMenu = GV.pStrg.getPage1(n: 1);
    var pre1 = GV.pStrg.getPage1(n: 2);
    GV.d('cur $curMenu', 'pre $pre1', 'togo $toGomenu');

    if (_isNeededForceQuit(curMenu)) {
      /// html event listener를 해제하기위해 Html페이지의 dispose를 호출해야만 해서 넣은 코드.
      GV.d('forced pop', curMenu);
      // Navigator.pop(context);
    }

    if (toGomenu == '{PREV}') {
      if (pre1.isEmpty) {
        return false;
      }
      GV.pStrg.getRemovePage1();
      // if (!_isNeededForceQuit(pre1)) {
      //   Navigator.pop(context);
      //   return true;
      // }
      toGomenu = pre1;
    }

    uiCommon.IdPushPage(context, toGomenu);
    await Navigator.pushReplacementNamed(context, '/$toGomenu');
    return true;
  }

  static void IdPushPage(BuildContext context, String menu) {
    if (menu.isNotEmpty) GV.pStrg.putPage1(menu);
    GV.d('hist', GV.pStrg.getHistoryPages());
  }

  static double relWidth(double width) {
    return GV.screen.width / (standardWidth / width);
  }

  static double relHeight(double height) {
    return GV.screen.height / (standardHeight / height);
  }

  //============================================================================================================
  // static void showMsg(BuildContext context, String msg) {
  //   if (msg.isEmpty) return;
  //   DbToastContext().init(context);
  //   DbToast.show(
  //     msg,
  //     duration: 3,
  //     gravity: 0,
  //     backgroundRadius: 8,
  //     backgroundColor: HexColor.fromHex('243249'),
  //   );
  // }

  // static Future<DateTime> openDateTime(BuildContext context, String curDT) async {
  //   DateTime _dt1 = DateTime.parse(curDT).toLocal();
  //   DateTime result = await showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         return Dialog(
  //           backgroundColor: Color(0xFFf0f4c3),
  //           child: LayoutBuilder(
  //             builder: (ctx, size) {
  //               return Container(
  //                   padding: const EdgeInsets.all(15),
  //                   width: 400,
  //                   height: 300,
  //                   child: DateTimePickerWidget(
  //                     initDateTime: _dt1,
  //                     dateFormat: DATE_FORMAT,
  //                     pickerTheme: DateTimePickerTheme(
  //                       showTitle: true,
  //                       backgroundColor: Color(0xFFf0f4c3),
  //                     ),
  //                     onConfirm: (dateTime, selectedIndex) {
  //                       Navigator.pushNamed(context, '/');
  //                       Navigator.pop(ctx, dateTime);
  //                       GV.retDateTimeWindow.value = dateTime;
  //                     },
  //                   ));
  //             },
  //           ),
  //         );
  //       });
  //   result = GV.retDateTimeWindow.value;
  //   return result;
  // }

  static List<dynamic> parseInit(String inp1) {
    bool isText = false;
    List<dynamic> imsi = [];
    var jj1 = inp1.split(",");

    for (int i = 0; i < jj1.length; i++) {
      if (isText == false) {
        var v1 = double.tryParse(jj1[i]);
        if (v1 == null) {
          isText = true;
          imsi.add(jj1[i]);
        } else
          imsi.add(v1);
      } else {
        imsi.add(jj1[i]);
      }
    }
    return imsi;
  }

//   static void launchURL(Uri uri) async {
//     //  if (await canLaunchUrl(uri)) {
//     try {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } catch (e) {
//       await launchUrl(Uri.parse('https://kr.lookinbody.com/LoginV2/FindIDPWEmploy'), mode: LaunchMode.externalApplication);
//     }
//     //} else {
// //      throw 'Could not launch $uri';
//     //}
//   }

  static Widget waitProgress(BuildContext context, {bool clickable = true}) {
    return Center(
        child: TextButton(
      onPressed: () => clickable ? uiCommon.IdMovePage(context, '{PREV}') : 1 == 1,
      child: CircularProgressIndicator(strokeWidth: 5),
    ));
  }

  ///
  ///inbody
  ///

  static Widget boldText2(
      {double? fontSize,
      String? text,
      bool star = false,
      IdUnit unit = IdUnit.none,
      Color unitColor = Colors.red,
      Color starColor = Colors.red,
      Color textColor = IdColors.black,
      MainAxisAlignment? mainAxisAlignment = MainAxisAlignment.end,
      CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.end,
      bool isBold = true}) {
    String unittext = '';
    switch (unit) {
      case IdUnit.kg:
        unittext = ' ㎏';
        break;
      case IdUnit.star:
        unittext = '  ⃰';
        break;
      case IdUnit.percent:
        unittext = ' %';
        break;
      case IdUnit.none:
        break;
    }

    return Row(
        mainAxisAlignment: mainAxisAlignment!,
        crossAxisAlignment: star ? CrossAxisAlignment.center : crossAxisAlignment!,
        children: [
          RichText(
              text: TextSpan(
                  text: text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      decoration: TextDecoration.none,
                      wordSpacing: -1,
                      fontFeatures: [ui.FontFeature.enable('liga'), ui.FontFeature.enable('dlig')]))),
          (star && text != null)
              ? Text("  ⃰", //U+20F0 유니코드
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: starColor, fontSize: fontSize! + 4.0, fontWeight: FontWeight.bold, decoration: TextDecoration.none))
              : SizedBox(),
          (unit != IdUnit.none && text != null)
              ? Text(unittext, //U+338F 유니코드
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: unitColor, fontSize: fontSize! - 4.0, fontWeight: FontWeight.bold, decoration: TextDecoration.none))
              : SizedBox()
        ]);
  }

  static Widget indexedBoldText(double top, double fontsize, String text,
      {double? left, double? right, bool star = false, Color textColor = IdColors.black, bool isBold = true}) {
    return Indexed(
        child: Positioned(
            left: left,
            right: right,
            top: top,
            child: boldText2(fontSize: fontsize, text: text, star: star, textColor: textColor, isBold: isBold)));
  }

  static Widget indexedTextWrap(double top, double fontsize, String text, {double? width, double? height, double? left, double? right}) {
    return Indexed(
        child: Positioned(
            left: left,
            right: right,
            top: top,
            child: Container(
                width: width,
                height: height,
                child: RichText(
                    text: TextSpan(
                        text: text,
                        style: TextStyle(
                            color: IdColors.black,
                            fontSize: fontsize,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            letterSpacing: -0.3,
                            wordSpacing: -5,
                            fontFeatures: [ui.FontFeature.enable('liga'), ui.FontFeature.enable('dlig')]))))));
  }

  static Widget indexedText(double top, double fontsize, String text, {double? left, double? right, Color? textColor}) {
    return Indexed(
        child: Positioned(
            left: left,
            right: right,
            top: top,
            child: RichText(
                text: TextSpan(
                    text: text,
                    style: TextStyle(
                        color: (textColor == null) ? IdColors.black : textColor,
                        fontSize: fontsize,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                        letterSpacing: -0.3,
                        wordSpacing: -5,
                        fontFeatures: [ui.FontFeature.enable('liga'), ui.FontFeature.enable('dlig')])))));
  }

  // static Widget indexdIcon(double left, double top, double iconWidth, double iconHeight, String asset,
  //     {Function()? callback, Color background = Colors.transparent, Color shadowColor = Colors.transparent}) {
  //   return Indexed(
  //       child: Positioned(
  //           left: left,
  //           top: top,
  //           child: IdRoundedBtn(
  //               onBtnPressed: callback,
  //               width: iconWidth,
  //               height: iconHeight,
  //               radius: 8,
  //               backgroundColor: background,
  //               shadowColor: shadowColor,
  //               icon: Image.asset(asset, fit: BoxFit.contain, width: iconWidth, height: iconHeight))));
  // }

  static Widget indexed(Widget widget, {double? left, double? top = 0, double? right, double? bottom}) {
    return Indexed(child: Positioned(left: left, right: right, top: top, bottom: bottom, child: widget));
  }

  static Widget styledText(
    String text,
    double fontSize,
    double fontSpacing,
    double fontHeight,
    FontWeight fontWeight,
    Color fontColor,
    TextAlign textAlign,
  ) {
    return StyledText(
      text: text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: fontSize,
        letterSpacing: fontSpacing,
        fontWeight: fontWeight,
        height: fontHeight,
        color: fontColor,
      ),
      tags: {
        'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
        'i': StyledTextTag(style: TextStyle(fontStyle: FontStyle.italic)),
        'u': StyledTextTag(style: TextStyle(decoration: TextDecoration.underline)),
        'a': StyledTextActionTag((String? text, Map<String?, String?> attrs) async {
          try {
            String? link = attrs!['href'];
            print('The "$link" link is tapped.');
            final Uri _url = Uri.parse(link!);
            await launchUrl(_url, mode: LaunchMode.inAppWebView);
          } catch (e) {
            print(e);
          }
        }, style: TextStyle(decoration: TextDecoration.underline)),
      },
      softWrap: true,
    );
  }

  // static Future<Uint8List?> convertImageToJpg(ui.Image image) async {
  //   final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  //   final jpgBytes = JpegEncoder().compress(data!.buffer.asUint8List(), image.width, image.height, 90);

  //   return jpgBytes;
  // }
}

class RoundSquare extends CustomClipper<Path> {
  final double round;

  RoundSquare(this.round);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRRect(RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(round),
    ));
    return path;
  }

  @override
  bool shouldReclip(RoundSquare oldClipper) => false;
}
