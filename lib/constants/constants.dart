const String PACKAGENAME = 'kwater';

/////////////////////////////////////
/// real page
////////////////////////////////////
const String PAGE_HOME_PAGE = "HOME"; //메인 홈
const String PAGE_ZOOM_PAGE = "ZOOM"; //즘 홈
const String PAGE_TEST_PAGE = "TEST"; //테스트 홈
const String PAGE_CHART_PAGE = "CHART"; //테스트 홈

//실질 화면
const String PAGE_MORNITORING_PAGE = "MONITOR"; //모니터링
const String PAGE_WQSTATUS_PAGE = "WQSTATUS"; //수질현황
const String PAGE_WQPREDICTION_PAGE = "WQPREDICTION"; //수질현황
const String PAGE_DECISION_PAGE = "DECISION"; //의사결정

const String key_menu_val = "0"; //페이지 상태 초기값(0: 모니터링, 1: 수질현황, 2: 수질예측)
const String key_date_val = "0000-00-00"; //날짜 값

const String key_drop_item1_YN = "false";
const String key_drop_item2_YN = "false";
const String key_drop_calendar_YN = "false";
const String key_category_str = 'category';

const String key_area_value = "areaValue";

const String key_scale_value = "key_scale_value";

//map16x2는 naver 16레벨 지도를 2배의 크기인  3840x3840으로 1920x1920의 2배크기의 지도임.(실제 해상도는 1920x1920)
// level  pixel  meter
// 15     50     100
// ----------------
// 16     50     50
// ----------------
// 17     60     30
// 18     80     20
// 19     80     10
/// 바탕화면에 깔리는 지도와 좌표계변환에 관련된 상수들.
const  double XYimageWidth = 1920.0;
const  double XYimageHeight = 1920.0;
const  double XYcenterLat = 36.345759;
const  double XYcenterLongi = 127.562920;
const  double XYtopLeftLat = 36.3534934;
const  double XYtopLeftLng = 127.5520527;
const  double XYbottomRightLat = 36.3441704;
const  double XYbottomRightLng = 127.5715727;
// naver 16레벨 지도는 pixel과 meter의 값이 일치한다.
const  double XYlat1m = 0.00000898; //1미터당 위도 중가.
const  double XYlongi1m = 0.00001116; //1미터당 경도 증가.


