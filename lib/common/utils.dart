// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:ui';
// import 'dart:js' as js;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import '../constants/constants.dart';
import 'dart:math';

import 'globalvar.dart';
import 'dart:io';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class IdStrUtil {
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static bool isNullOrEmpty(dynamic text) {
    if (["", null].contains(text)) {
      return true;
    }
    return false;
  }

  static bool isBigger(String text, int size) {
    if (!["", null].contains(text) && text.length > size) {
      return true;
    }
    return false;
  }

  static bool isSmaller(String text, int size) {
    if (!["", null].contains(text) && text.length < size) {
      return true;
    }
    return false;
  }

  static String toDigits(int value, int length) {
    String ret = '$value';
    if (ret.length < length) {
      ret = '0' * (length - ret.length) + ret;
    }
    return ret;
  }

  static String getISO8601TZNumber(DateTime date) {
    var result = "";
    if (date.timeZoneOffset.isNegative) {
      result = sprintf("-%s:%s", [toDigits((-date.timeZoneOffset.inHours) % 24, 2), toDigits((-date.timeZoneOffset.inMinutes) % 60, 2)]);
    } else {
      result = sprintf("+%s:%s", [toDigits((date.timeZoneOffset.inHours) % 24, 2), toDigits((date.timeZoneOffset.inMinutes) % 60, 2)]);
    }
    return result;
  }

  static String getISO8601String(DateTime date) {
    return sprintf('%s%s', [
      formatDate(date, [yyyy, '-', mm, '-', dd, 'T', HH, ':', nn, ':', ss]),
      IdStrUtil.getISO8601TZNumber(date)
    ]);
  }

  static String toBase64(String src) {
    return base64.encode(utf8.encode(src));
  }

  static String fromBase64(String src) {
    var ret = utf8.decode(base64.decode(src));
    if (ret == 'null') ret = '';
    return ret;
  }

  static List<String> toArrayString(List<dynamic> items) {
    List<String> results = [];
    items.forEach((element) {
      results.add(element.toString());
    });
    return results;
  }

  static String toPassword(String orgStr) {
    String enPwd = '';
    try {
      enPwd = hex.encode(sha256.convert(utf8.encode(orgStr)).bytes);
    } catch (e) {}

    return enPwd;
  }

  static String toNetworkBeautify(double value, String format) {
    if (value >= 1000000000) {
      var v1 = value ~/ 1000000000;
      var v2 = (value % 1000000000) ~/ 100000000;
      return v1.toString() + "." + v2.toString() + "G";
    } else if (value >= 1000000) {
      var v1 = value ~/ 1000000;
      var v2 = (value % 1000000) ~/ 100000;
      return v1.toString() + "." + v2.toString() + "M";
    } else if (value >= 1000) {
      var v1 = value ~/ 1000;
      return v1.toString() + "K";
    }

    //return NumberFormat('#,###').format(value);
    return NumberFormat(format).format(value);
  }

  static String toMoneyUnitKr(String value) {
    String result = '';
    double money = double.tryParse(value.replaceAll(',', '')) ?? 0;
    GV.d(money);
    String moneyStr1 = money.toString().split('.')[0];
    if (money >= 10000) {
      if (money.toString().contains('.')) {
        String moneyStr2 = money.toString().split('.')[1];
        if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 4) {
          result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
              '억 ' +
              NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0) +
              '.' +
              moneyStr2;
        } else if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 3) {
          result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
              '억 ' +
              '0' +
              NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0) +
              '.' +
              moneyStr2;
        } else if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 2) {
          result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
              '억 ' +
              '00' +
              NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0) +
              '.' +
              moneyStr2;
        } else if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 1) {
          result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
              '억 ' +
              '000' +
              NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0) +
              '.' +
              moneyStr2;
        }
      } else {
        if (NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0) != '0') {
          if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 4) {
            result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
                '억 ' +
                NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0);
          } else if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 3) {
            result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
                '억 ' +
                '0' +
                NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0);
          } else if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 2) {
            result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
                '억 ' +
                '00' +
                NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0);
          } else if (double.tryParse(moneyStr1.substring(moneyStr1.length - 4)).toString().length == 1) {
            result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) +
                '억 ' +
                '000' +
                NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(moneyStr1.length - 4)) ?? 0);
          }
        } else {
          result = NumberFormat('#,###').format(double.tryParse(moneyStr1.substring(0, moneyStr1.length - 4)) ?? 0) + '억 ';
        }
      }
    } else {
      result = value;
    }
    return result;
  }

  static String parseUnix2Str(double value) {
    int diff1 = GV.pStrg.getTimediff();
    var date = DateTime.fromMillisecondsSinceEpoch((value.toInt() - diff1) * 1000);

    return DateFormat.y().format(date) + ' ' + DateFormat.Md().format(date) + ' ' + DateFormat.Hm().format(date);
  }

  static String unixTimeStr(int value) {
    return (DateTime.now().millisecondsSinceEpoch / 1000 + value).toInt().toString();
  }

//19800 50500 0000
  static DateTime? toDateTime4InbodyDateStr(String dateString) {
    DateTime date = DateTime.parse('0000-00-00 00:00:00');

    if (dateString == "" || dateString.length != 14) {
      return null;
    } else {
      date = DateTime.parse(dateString.substring(0, 4) +
          '-' +
          dateString.substring(4, 6) +
          '-' +
          dateString.substring(6, 8) +
          ' ' +
          dateString.substring(8, 10) +
          ':' +
          dateString.substring(10, 12) +
          ':' +
          dateString.substring(12, 14));
    }

    return date;
  }

  static String toInbodyDateStr4DateTime(DateTime date1) {
    // return DateFormat('yyyyMMddHHmmss').format(date1);
    return DateFormat('yyyyMMdd').format(date1);
  }

  static String randomBigInt(int in1) {
    final random = Random.secure();
    final state = BigInt.from(1) << in1;
    final randomBigInt = BigInt.from(random.nextInt(2 ^ 32)) * state ~/ (BigInt.from(2 ^ 32));
    return randomBigInt.toString();
  }
}

class IdUtil {
  static DateTime getExpirationTime(int timeoutMinutes) {
    DateTime expires = DateTime.now().add(Duration(minutes: timeoutMinutes));
    return expires;
  }

  static String getExpirationTimeStr(int timeoutMinutes) {
    DateTime expires = DateTime.now().add(Duration(minutes: timeoutMinutes));
    return expires.toUtc().toIso8601String();
  }

  // static void setCookieJs(String value) {
  //   var expires = getExpirationTime(60 * 24);
  //   final jsCode = '''
  //   document.cookie = 'JSESSIONID=${value}; expires=${expires.toUtc().toIso8601String()}';
  // ''';
  //   js.context.callMethod('eval', [jsCode]);
  // }

  // static void setCookie(String data) {
  //   var str = 'JSESSIONID=$data; expires=' + getExpirationTimeStr(24 * 60);
  //   html.document.cookie = str;
  //   if (ID_BASE_URI.contains('localhost')) {
  //     GV.pStrg.putXXX('sessid', data);
  //   }
  //   GV.d(str);
  // }

  // static void deleteCookie() {
  //   DateTime pastTime = DateTime.now().subtract(Duration(days: 1));
  //   String pastExpirationTime = pastTime.toUtc().toIso8601String();
  //   html.document.cookie = 'JSESSIONID=; expires=' + pastExpirationTime;
  // }

  // static String? getCookie() {
  //   if (ID_BASE_URI.contains('localhost')) {
  //     return GV.pStrg.getXXX('sessid');
  //   }

  //   final cookie = html.document.cookie!;
  //   GV.d('cookie', cookie);
  //   final entity = cookie.split("; ").map((item) {
  //     final split = item.split("=");
  //     return MapEntry(split[0], split[1]);
  //   });
  //   try {
  //     final cookieMap = Map.fromEntries(entity);
  //     // GV.d(cookieMap);
  //     return cookieMap['JSESSIONID'];
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
}
