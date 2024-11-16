import '../common/utils.dart';
import '../constants/constants.dart';

import '../common/globalvar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';

const PREFS_TOKEN = "otkljdf";
const PREFS_USER = "otkljdf1";
const PREFS_FEATURES = "otkljdf2";
const PREFS_PARTNERS = "otkljdf3";
const PREFS_SERVICES = "otkljdf4";
const PREFS_FWS = "otkljdf5";
const PREFS_MAKERS = "otkljdf6";
const PREFS_ESERVER = "otkljdf7";
const PREFS_TIMEDIFF = "otkljdtiff";
//=================
const PREFS_PAGE_HIST = "otdashbd0198_";
const PREFS_DYNVAR = "otdashbd_VAR_";
const PREFS_DYNPAGES = "otdashbd1_";
const PREFS_PAGEPARAM = "otdashbd2_";
const PREFS_ALARMENV = "otdashbd3_";
const PREFS_DRAWER = "drawer";

class PrefStorage {
  String? urlParam;

  static SharedPreferences? _prefs;

  final Map<String, String> _dynMapValues = {};
  String? _dynPageParam;
  List<String> _pageHist = [];
  //================save to prefs(browser's localstorage)
  String _token = "";

  //pref에 관련한 자료 초기화는 하지 않는다.
  Future<void> init() async {
    print('session init');

    _token = "";
    urlParam = "";
    _prefs = await SharedPreferences.getInstance();

    print('session init end');
  }

  void putPageParam(String? param1) {
    if (param1 == null) {
      _dynPageParam = '';
      _prefs?.setString(PREFS_PAGEPARAM, '');
      return;
    }
    _dynPageParam = param1;
    _prefs?.setString(PREFS_PAGEPARAM, param1);
  }

  /// n : 1 : 가장 최신
  ///     2 : 그다음. 최신.
  String getPage1({int? n}) {
    String value = '';
    _pageHist = _prefs?.getStringList(PREFS_PAGE_HIST) ?? [];
    if (_pageHist.length == 0) return value;
    try {
      if (n != null)
        value = _pageHist.elementAt(_pageHist.length - n);
      else
        value = _pageHist.last;
    } catch (e) {
      GV.d(e);
    }
    return value;
  }

  String getRemovePage1() {
    _pageHist = _prefs?.getStringList(PREFS_PAGE_HIST) ?? [];
    if (_pageHist.length == 0) return "";
    String lastPage = _pageHist.removeLast();

    _prefs?.setStringList(PREFS_PAGE_HIST, _pageHist);
    return lastPage;
  }

  void putPage1(String pageName) {
    _pageHist = _prefs?.getStringList(PREFS_PAGE_HIST) ?? [];
    _pageHist.isNotEmpty
        ? _pageHist.last != pageName
            ? _pageHist.add(pageName)
            : 1 == 1
        : _pageHist.add(pageName);
    _pageHist.length > 10 ? _pageHist.removeAt(0) : 1 == 1;
    _prefs?.setStringList(PREFS_PAGE_HIST, _pageHist);
  }

  void clearPage1() {
    _prefs?.setStringList(PREFS_PAGE_HIST, []);
  }

  List<String> getHistoryPages() {
    _pageHist = _prefs?.getStringList(PREFS_PAGE_HIST) ?? [];
    return _pageHist;
  }

  Key _getEncKey() {
    return Key.fromUtf8("Y2ZxpZW50X2luZm9ybWF0aW9uX3VuaW9u".substring(0, 32));
  }

  IV _getEncIV() {
    return IV.fromUtf8("YZ2xpZW50X2luZm9ybWF0aW9uX3VuaW9u".substring(0, 8));
  }

  String getXXX(String key) {
    var value = _dynMapValues[key];
    if (value != null && value.length > 0) return value;
    final encrypter = Encrypter(Salsa20(_getEncKey()));
    var encryptedstr = _prefs?.getString(key) ?? "";
    if (encryptedstr.isEmpty) return "";
    Encrypted encrypted = Encrypted.fromBase64(encryptedstr);
    final decryptedstr = encrypter.decrypt(encrypted, iv: _getEncIV());
    return decryptedstr;
  }

  void putXXX(String key, String value) {
    _dynMapValues[key] = value;
    final encrypter = Encrypter(Salsa20(_getEncKey()));
    final encrypted = encrypter.encrypt(value, iv: _getEncIV());
    _prefs?.setString(key, encrypted.base64);
  }

  // /// 마지막사용시간을 넣는다.
  // void putLastUsed() {
  //   GV.pStrg.putXXX(key_gv_lastused, IdStrUtil.unixTimeStr(0));
  // }

  // /// 마지막 사용시간을 넘긴다
  // int getLastUsed() {
  //   try {
  //     return int.parse(GV.pStrg.getXXX(key_gv_lastused));
  //   } catch (e) {}
  //   return 0;
  // }

////////////////////////////////////

  String getToken() {
    if (_token.length > 0) return _token;
    return _prefs?.getString(PREFS_TOKEN) ?? "";
  }

  void putToken(String tkn1) {
    _token = tkn1;
    _prefs?.setString(PREFS_TOKEN, tkn1);
  }

  int getTimediff() {
    return _prefs?.getInt(PREFS_TIMEDIFF) ?? 0;
  }

  void putTimediff(int t1) {
    _prefs?.setInt(PREFS_TIMEDIFF, t1);
  }
}
