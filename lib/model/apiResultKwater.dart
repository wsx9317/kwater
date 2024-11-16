// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';

import '../constants/constants.dart';

class ApiResultKWater {
  double? chlData;
  double? envData;
  double? envMax;
  double? envMin;
  double? envMean;
  double? latitude;
  double? longitude;
  double? envDataPerCell;
  double? gridId;
  double? chlUgLMean;
  int? priority;
  int? state;
  String? timestamp;
  String? timestampModifiedat;
  ApiResultKWater({
    this.chlData,
    this.envData,
    this.envMax,
    this.envMin,
    this.envMean,
    this.latitude,
    this.longitude,
    this.envDataPerCell,
    this.gridId,
    this.chlUgLMean,
    this.priority,
    this.state,
    this.timestamp,
    this.timestampModifiedat,
  });

  ApiResultKWater copyWith({
    double? chlData,
    double? envData,
    double? envMax,
    double? envMin,
    double? envMean,
    double? latitude,
    double? longitude,
    double? envDataPerCell,
    double? gridId,
    double? chlUgLMean,
    int? priority,
    int? state,
    String? timestamp,
    String? timestampModifiedat,
  }) {
    return ApiResultKWater(
      chlData: chlData ?? this.chlData,
      envData: envData ?? this.envData,
      envMax: envMax ?? this.envMax,
      envMin: envMin ?? this.envMin,
      envMean: envMean ?? this.envMean,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      envDataPerCell: envDataPerCell ?? this.envDataPerCell,
      gridId: gridId ?? this.gridId,
      chlUgLMean: chlUgLMean ?? this.chlUgLMean,
      priority: priority ?? this.priority,
      state: state ?? this.state,
      timestamp: timestamp ?? this.timestamp,
      timestampModifiedat: timestampModifiedat ?? this.timestampModifiedat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chlData': chlData,
      'env_data': envData,
      'env_max': envMax,
      'env_min': envMin,
      'env_mean': envMean,
      'latitude': latitude,
      'longitude': longitude,
      'envDataPerCell': envDataPerCell,
      'grid_id': gridId,
      'chl_ug_l_mean': chlUgLMean,
      'priority': priority,
      'state': state,
      'timestamp': timestamp,
      'timestamp_modifiedat': timestampModifiedat,
    };
  }

  factory ApiResultKWater.fromMap(Map<String, dynamic> map) {
    return ApiResultKWater(
      chlData: map['chlData'] != null && map['chlData'] != 'NaN' ? map['chlData'] as double : null,
      envData: map['env_data'] != null && map['env_data'] != 'NaN' ? map['env_data'] as double : null,
      envMax: map['env_max'] != null && map['env_max'] != 'NaN' ? map['env_max'] as double : null,
      envMin: map['env_min'] != null && map['env_min'] != 'NaN' ? map['env_min'] as double : null,
      envMean: map['env_mean'] != null && map['env_mean'] != 'NaN' ? map['env_mean'] as double : null,
      latitude: map['latitude'] != null && map['latitude'] != 'NaN' ? map['latitude'] as double : null,
      longitude: map['longitude'] != null && map['longitude'] != 'NaN' ? map['longitude'] as double : null,
      envDataPerCell: map['envDataPerCell'] != null && map['envDataPerCell'] != 'NaN' ? map['envDataPerCell'] as double : null,
      gridId: map['grid_id'] != null && map['grid_id'] != 'NaN' ? map['grid_id'] as double : null,
      chlUgLMean: map['chl_ug_l_mean'] != null && map['chl_ug_l_mean'] != 'NaN' ? map['chl_ug_l_mean'] as double : null,
      priority: map['priority'] != null && map['priority'] != 'NaN' ? map['priority'] as int : null,
      state: map['state'] != null && map['state'] != 'NaN' ? map['state'] as int : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] as String : null,
      timestampModifiedat: map['timestamp_modifiedat'] != null ? map['timestamp_modifiedat'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResultKWater.fromJson(String source) {
    return ApiResultKWater.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  static List<ApiResultKWater> fromJsonArray(String source) {
    final List<dynamic> jsonArray = json.decode(source) as List<dynamic>;
    return jsonArray.map((json) => ApiResultKWater.fromMap(json as Map<String, dynamic>)).toList();
  }

  @override
  String toString() {
    return 'ApiResultKWater(chlData: $chlData, envData: $envData, envMax: $envMax, envMin: $envMin, envMean: $envMean, latitude: $latitude, longitude: $longitude, envDataPerCell: $envDataPerCell, gridId: $gridId, chlUgLMean: $chlUgLMean, priority: $priority, state: $state, timestamp: $timestamp, timestampModifiedat: $timestampModifiedat)';
  }

  @override
  bool operator ==(covariant ApiResultKWater other) {
    if (identical(this, other)) return true;

    return other.chlData == chlData &&
        other.envData == envData &&
        other.envMax == envMax &&
        other.envMin == envMin &&
        other.envMean == envMean &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.envDataPerCell == envDataPerCell &&
        other.gridId == gridId &&
        other.chlUgLMean == chlUgLMean &&
        other.priority == priority &&
        other.state == state &&
        other.timestamp == timestamp &&
        other.timestampModifiedat == timestampModifiedat;
  }

  @override
  int get hashCode {
    return chlData.hashCode ^
        envData.hashCode ^
        envMax.hashCode ^
        envMin.hashCode ^
        envMean.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        envDataPerCell.hashCode ^
        gridId.hashCode ^
        chlUgLMean.hashCode ^
        priority.hashCode ^
        state.hashCode ^
        timestamp.hashCode ^
        timestampModifiedat.hashCode;
  }

  static List<Offset> parseRobotPath(List<ApiResultKWater> srcList) {
    List<Offset> result = [];
    srcList.forEach((src1) {
      final adjustedX = (src1.longitude! - XYtopLeftLng) * (XYimageWidth / ((XYbottomRightLng - XYtopLeftLng) * 1));
      final adjustedY = (XYtopLeftLat - src1.latitude!) * (XYimageHeight / ((XYtopLeftLat - XYbottomRightLat) * 1));
      result.add(Offset(adjustedX, adjustedY));
    });

    return result;
  }
}
