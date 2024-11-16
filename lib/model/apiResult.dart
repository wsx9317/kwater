// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ApiResult {
  ApiResult({
    required this.code,
    this.message,
    required this.data,
    this.serviceCode,
  });
  String? code;
  dynamic message;
  dynamic data;
  String? serviceCode;

  ApiResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
    serviceCode = json['serviceCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data;
    _data['serviceCode'] = serviceCode;
    return _data;
  }

  @override
  String toString() {
    return 'ApiResult(code: $code, message: $message, data: $data, serviceCode: $serviceCode)';
  }
}
