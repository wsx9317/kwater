import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:kwater/common/globalvar.dart';
import 'package:kwater/common/uiCommon.dart';
import 'package:kwater/constants/constants.dart';
import 'package:kwater/screens/Decision.dart';
import 'package:kwater/screens/Home.dart';
import 'package:kwater/screens/Background.dart';
import 'package:kwater/screens/Mornitoring.dart';
import 'package:kwater/screens/WaterQualityPrediction.dart';
import 'package:kwater/screens/WaterQualityStatus.dart';
import 'package:kwater/screens/Zoom1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  var mainpage = dotenv.env['MAIN'];
  var logLevel = dotenv.env['LOGLEVEL'];

  await GV.init(logLevel as String);

  runApp(MyApp(mainPage: mainpage));
}

class MyApp extends StatelessWidget {
  final String? mainPage;
  const MyApp({super.key, required this.mainPage});

  @override
  Widget build(BuildContext context) {
    GV.pStrg.getHistoryPages().isEmpty ? uiCommon.IdPushPage(context, mainPage!) : 1 == 1;
    PageTransitionsTheme _removeTransitions() {
      return PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values) platform: const _NoTransitionsBuilder(),
        },
      );
    }

    return MaterialApp(
      key: ValueKey('123mainbase0'),
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      title: 'K-Water',
      theme:  ThemeData(pageTransitionsTheme: _removeTransitions()),
      initialRoute: "/${mainPage!}",
      debugShowCheckedModeBanner: false,
      routes: {
        "/$PAGE_HOME_PAGE": (context) => const Home(key: ValueKey('123mainbase1'),),
        "/$PAGE_MORNITORING_PAGE": (context) => const Mornitoring(key: ValueKey('123mainbase2'),),
        "/$PAGE_WQSTATUS_PAGE": (context) => const Waterqualitystatus(key: ValueKey('123mainbase3'),),
        "/$PAGE_WQPREDICTION_PAGE": (context) => const Waterqualityprediction(key: ValueKey('123mainbase4'),),
        "/$PAGE_DECISION_PAGE": (context) => const Decision(key: ValueKey('123mainbase5'),),

        // "/$PAGE_TEST_PAGE": (context) => Background(),
        // "/$PAGE_CHART_PAGE": (context) => const LineChartSample11(),
      },
    );
  }
}

class _NoTransitionsBuilder extends PageTransitionsBuilder {
  const _NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    return child!;
  }
}
