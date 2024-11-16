import 'package:flutter/material.dart';
import 'package:kwater/model/Kwater.dart';
import 'package:kwater/screens/Decision.dart';
import 'package:kwater/screens/Mornitoring.dart';
import 'package:kwater/screens/WaterQualityPrediction.dart';
import 'package:kwater/screens/WaterQualityStatus.dart';
import '../api/kwater_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> fetchData() async {
    //KwaterApi.getStatistics(WaterFilter.temp_deg_c,'2024-10-10');
    // KwaterApi.getChlHistory(WaterFilter.temp_deg_c,0);
    // KwaterApi.getDevicePower(DeviceFilter.amplifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('123mainhome0'),
      body: SizedBox(
        key: ValueKey('123mainhome1'),
        child: Mornitoring(
          key: ValueKey('123mainhome2'),
        ),
        // child: Waterqualitystatus(),
        // child: Waterqualityprediction(),
        // child: Decision(),
      ),
    );
  }
}
