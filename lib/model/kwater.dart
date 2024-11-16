String ID_BASE_URI = 'http://13.209.0.13:8070';

/////////////////////////////////
/// 수질데이터 조회용 필터 enum
/////////////////////////////////
enum WaterFilter {
  /// 온도
  temp_deg_c,

  /// pH
  ph_units,

  /// 전도도
  spcond_us_cm,

  /// 탁도
  turb_ntu,

  /// 광학DO (mg/L)
  hdo_mg_l,

  /// 클로로필
  chl_ug_l,

  /// 피코시아닌
  bg_ppb,

  /// 용존산소
  ph_mv
}

/////////////////////////////////
/// 의사결정 장치  enum
/////////////////////////////////
enum DeviceFilter {
  /// 수면포기기
  aberration,

  /// 제거선박
  ship,

  /// 주증폭기장치
  amplifier
}

class Kwater {
/////////////////////////////////////
  /// api
////////////////////////////////////
  static String _ID_API_MON_FILTER = '/water-quality/monitoring/'; //수질데이터 조회
  static String _ID_API_MON_ROBOT = '/water-quality/monitoring/robot';
  static String _ID_API_HISTORY_FILTER_DATE = '/water-quality/history/';
  static String _ID_API_STATISTICS_FILTER_DATE = '/water-quality/statistics/';
  static String _ID_API_PRIORITY_FILTER = '/water-quality/priority/';
  static String _ID_API_CHLHISTORY_ID_FILTER = '/water-quality/chlHistory/';
  static String _ID_API_DEVICE_POWER = '/water-quality/';

  /// 수질데이터 조회 api string
  static String kwater_mon_filter(WaterFilter filter) {
    return ID_BASE_URI +  _ID_API_MON_FILTER + filter.name;
  }

  ///  로봇 조회 api string
  static String kwater_mon_robot() {
    return ID_BASE_URI +  _ID_API_MON_ROBOT;
  }

  /// 수질데이터 이력조회 api string
  ///  date format yyyy-MM-dd
  static String kwater_history_filter_date(WaterFilter filter, String dateStr) {
    return ID_BASE_URI +  _ID_API_HISTORY_FILTER_DATE + filter.name + '/' + dateStr;
  }

  /// 수질데이터 통계조회 api string
  ///  date format yyyy-MM-dd
  static String kwater_statistics_filter_date(WaterFilter filter, String dateStr) {
    return ID_BASE_URI +  _ID_API_STATISTICS_FILTER_DATE + filter.name + '/' + dateStr;
  }

  /// 수질예측 제거우선순위 api string
  static String kwater_priority_filter(WaterFilter filter) {
    return ID_BASE_URI +  _ID_API_PRIORITY_FILTER + filter.name;
  }

  /// 영역별 클로로필 평균이력조회 api string   : filter값이 이상함.
  static String kwater_chlHistory_id_filter(WaterFilter filter, int id) {
    return ID_BASE_URI +  _ID_API_CHLHISTORY_ID_FILTER + id.toString() + '/' + filter.name;
  }

  /// 장치전원상태요청 api string
  static String kwater_DEVICE_POWER_STATE_POST(DeviceFilter device, int state) {
    return ID_BASE_URI +  _ID_API_DEVICE_POWER + device.name + '/power/' + state.toString();
  }

  /// 장치전원조회 api string
  static String kwater_DEVICE_POWER(DeviceFilter device) {
    return ID_BASE_URI +  _ID_API_DEVICE_POWER + device.name + '/power';
  }
}
