import 'dart:ui';
import 'package:get_it/get_it.dart';
import 'package:kwater/model/prefStorage.dart';
import 'package:logger/logger.dart';
// ignore: implementation_imports
import 'package:stack_trace/src/vm_trace.dart';
import 'package:stack_trace/stack_trace.dart';

import '../constants/constants.dart';
// import '../model/prefStorage.dart';
// import '../model/dynPage.dart';

typedef _OnCall = dynamic Function(List arguments);

class RetDateTimeWindow {
  RetDateTimeWindow(this.value);

  DateTime value;
}

class VarArgsFunction {
  VarArgsFunction(this._onCall);

  final _OnCall _onCall;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod || invocation.namedArguments.isNotEmpty) super.noSuchMethod(invocation);
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }
}

class GV {
  static void printLongString(String longString) {
    const int maxLength = 800;
    int strLength = longString.length;

    if (pStrg.getXXX('loglevel').toLowerCase() != 'debug') return;
    Trace tr1 = Trace.current();
    List<Frame> newFr1 = [];
    for (var element in tr1.frames) {
      if (element.location.contains(PACKAGENAME) && !element.member!.contains("printLongString")) newFr1.add(element);
    }
    print('========');
    print(VMTrace(newFr1));
    if (strLength < maxLength) {
      print(longString);
    } else {
      int start = 0;
      int end = maxLength;
      while (strLength > end) {
        var str1 = longString.substring(start, end);
        start = end;
        end = start + maxLength;
        print(str1);
      }
      print(longString.substring(start, strLength));
    }
    print('--------');
  }

  static final d = VarArgsFunction((arguments) {
    Trace tr1 = Trace.current();
    List<Frame> newFr1 = [];
    for (var element in tr1.frames) {
      if (element.location.contains(PACKAGENAME) && !element.member!.contains("printLongString")) newFr1.add(element);
    }

    String all1 = "";
    for (final item1 in arguments) {
      var item = item1 ?? "null";
      all1 = all1.isEmpty ? item.toString() : "$all1\n$item";
    }

    logger.d(all1, null, VMTrace(newFr1.length > 2 ? newFr1.sublist(2) : []));
  }) as dynamic;

  static final i = VarArgsFunction((arguments) {
    Trace tr1 = Trace.current();
    List<Frame> newFr1 = [];
    for (var element in tr1.frames) {
      if (element.location.contains(PACKAGENAME) && !element.member!.contains("printLongString")) newFr1.add(element);
    }

    String all1 = "";
    for (final item1 in arguments) {
      var item = item1 ?? "null";
      all1 = all1.isEmpty ? item.toString() : "$all1\n$item";
    }

    logger.i(all1, null, VMTrace(newFr1.length > 2 ? newFr1.sublist(2) : []));
  }) as dynamic;

  static final e = VarArgsFunction((arguments) {
    Trace tr1 = Trace.current();
    List<Frame> newFr1 = [];
    for (var element in tr1.frames) {
      if (element.location.contains(PACKAGENAME) && !element.member!.contains("printLongString")) newFr1.add(element);
    }

    String all1 = "";
    for (final item1 in arguments) {
      var item = item1 ?? "null";
      all1 = all1.isEmpty ? item.toString() : "$all1\n$item";
    }

    logger.e(all1, null, VMTrace(newFr1.length > 2 ? newFr1.sublist(2) : []));
  }) as dynamic;

  static GetIt locator = GetIt.instance;

  static Future<void> init(String logel) async {
    print('called gv.init');
    locator.allowReassignment = true;
    retDateTimeWindow = RetDateTimeWindow(DateTime.now());
    pStrg = PrefStorage();
    await pStrg.init();

    switch (logel.toUpperCase()) {
      case 'ERROR':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.error);
        break;
      case 'DEBUG':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 4), level: Level.debug);
        break;
      case 'INFO':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.info);
        break;
      case 'VERBOSE':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.verbose);
        break;
      case 'WARNING':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.warning);
        break;
      case 'WTF':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.wtf);
        break;
      case 'NOTHING':
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.nothing);
        break;
      default:
        logger = Logger(printer: PrettyPrinter(printTime: false, lineLength: 40), level: Level.verbose);
    }

    pStrg.putXXX('loglevel', logel);
    screen = Size.zero;
    // myInfoItem = MyInfoItem();
    //===========================================
  }

//===========================================================================
  static Size get screen {
    return locator<Size>();
  }

  static set screen(Size value) {
    locator.registerLazySingleton<Size>(() => value);
  }

  static PrefStorage get pStrg {
    return locator<PrefStorage>();
  }

  static set pStrg(PrefStorage value) {
    locator.registerLazySingleton<PrefStorage>(() => value);
  }

  static RetDateTimeWindow get retDateTimeWindow {
    return locator<RetDateTimeWindow>();
  }

  static set retDateTimeWindow(RetDateTimeWindow value) {
    locator.registerLazySingleton<RetDateTimeWindow>(() => value);
  }

  static Logger get logger {
    return locator<Logger>();
  }

  static set logger(Logger value) {
    locator.registerLazySingleton<Logger>(() => value);
  }

  // static MyInfoItem get myInfoItem {
  //   return locator<MyInfoItem>();
  // }

  // static set myInfoItem(MyInfoItem value) {
  //   locator.registerLazySingleton<MyInfoItem>(() => value);
  // }
}
