// ignore_for_file: prefer_const_constructors


import 'package:http/http.dart' as http;
import '../model/Kwater.dart';
import '../model/apiResultKwater.dart';
import 'package:flutter/foundation.dart'; // 추가된 코드

class IdApiPreParam {
  Map<String, String>? headers;
  http.Client? client;
  Uri? uri;

  @override
  String toString() => 'IdApiPreParam(headers: $headers, client: $client, uri: $uri)';
}

class KwaterApi {
  static IdApiPreParam? authTokenHttp({String? url}) {
    IdApiPreParam prehttp = IdApiPreParam();
    prehttp.client = http.Client();
    if (url != null) {
      prehttp.uri = Uri.parse(url);
    } else
      return null;

    prehttp.headers = {
      // 'accept': '*/*',
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Content-Length': '0',
      // 'Accept': '*/*',
      // 'Accept-Encoding': 'gzip, deflate, br',
    };
    return prehttp;
  }

  /// 수질데이터조회
  static Future<dynamic> getWaterQuality(WaterFilter filter) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_mon_filter(filter));
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJsonArray(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 로봇경로조회
  static Future<dynamic> getRobotPath() async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_mon_robot());
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJsonArray(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 수질데이터이력조회
  /// 검색 일자(yyyy-MM-dd)
  static Future<dynamic> getWaterQualityHistory(WaterFilter filter, String dateStr) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_history_filter_date(filter, dateStr));
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJsonArray(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 수질데이터통계조회
  /// 검색 일자(yyyy-MM-dd)
  static Future<dynamic> getStatistics(WaterFilter filter, String dateStr) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_statistics_filter_date(filter, dateStr));
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJson(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 제거우선순위
  static Future<dynamic> getRemovePriority(WaterFilter filter) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_priority_filter(filter));
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJsonArray(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 영역별클로로필 평균이력조회
  static Future<dynamic> getChlHistory(WaterFilter filter, int id) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_chlHistory_id_filter(filter, id));
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJsonArray(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// 장치전원상태요청
  /// 장치별 유효 값 범위
  ///수면포기기: 1 or 15
  ///제거선박: 0~6
  ///주증폭기장치: 0~3
  static Future<dynamic> postDevicePowerState(DeviceFilter filter, int state) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_DEVICE_POWER_STATE_POST(filter, state));
    try {
      final response = await c1?.client!.post(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response!.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  /// 장치전원상태조회
  static Future<dynamic> getDevicePower(DeviceFilter filter) async {
    var c1 = KwaterApi.authTokenHttp(url: Kwater.kwater_DEVICE_POWER(filter));
    try {
      final response = await c1?.client!.get(c1.uri!, headers: c1.headers).timeout(Duration(seconds: 5));
      // debugPrint(response!.body);
      if (response != null && response.statusCode == 200 && response.body.isNotEmpty) {
        var result = ApiResultKWater.fromJson(response.body);
        // debugPrint(result.toString());
        return result;
      } else {
        debugPrint('Failed to load ');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
