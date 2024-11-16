import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdPolygonWidget.dart';
import 'package:kwater/model/BoxCustom.dart';
import 'package:kwater/model/gps/Geoprediction.dart';

import 'package:proj4dart/proj4dart.dart' as proj4;

class Background extends StatefulWidget {
  final bool showPolygon;
  final bool showDevice;
  final bool showIcon;
  final List<List>? polygonIdList;
  final List<List>? polygonIdList2;
  final VoidCallback? onPolygonClick;
  final List<List<dynamic>>? polygonGrupList;
  final List<List<double>> robotPathHistory;
  final bool setData;
  final double? deviceValue;

  Background({
    Key? key,
    required this.showPolygon,
    required this.showDevice,
    required this.showIcon,
    this.polygonIdList,
    this.polygonIdList2,
    this.onPolygonClick,
    this.polygonGrupList,
    required this.robotPathHistory,
    required this.setData,
    this.deviceValue,
  }) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  double imageWidth = 1920.0;
  double imageHeight = 1920.0;
  double centerLat = 36.345759;
  double centerLongi = 127.562920;
  double topLeftLat = 36.3534934;
  double topLeftLng = 127.5520527;
  double bottomRightLat = 36.3441704;
  double bottomRightLng = 127.5715727;
  double colorOpacity = 1.0;

//map16x2는 naver 16레벨 지도를 2배의 크기인  3840x3840으로 1920x1920의 2배크기의 지도임.(실제 해상도는 1920x1920)
  double lat1m = 0.00000898;
  //1미터당 위도 중가.
  double longi1m = 0.00001116;
  //1미터당 경도 증가.
  List<double> robotOffset = [];
  List<List<double>> robotPathList = [];
  List<Offset> robotOffsetList = [];

  Map<int, Map<int, BoxCustom>>? boxMapMap;
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<List<Offset>> _parsePolygonString(String polygonString) async {
    final srcProj = proj4.Projection.get('EPSG:5181');
    final dstProj = proj4.Projection.get('EPSG:4326');
    final coordinates0 = polygonString
        .replaceAll('POLYGON ((', '')
        .replaceAll('))', '')
        .split(', ')
        .map((point) {
      final coords = point.split(' ');
      final x = double.parse(coords[0]);
      final y = double.parse(coords[1]);
      final transformed = srcProj!.transform(dstProj!, proj4.Point(x: x, y: y));
      final adjustedX = (transformed.x - topLeftLng) *
          (imageWidth / ((bottomRightLng - topLeftLng) * 1));
      final adjustedY = (topLeftLat - transformed.y) *
          (imageHeight / ((topLeftLat - bottomRightLat) * 1));
      return Offset(adjustedX, adjustedY);
    });
    final coordinates = coordinates0.toList();
    return coordinates;
  }

  Future<Map<int, String>> loadIdGeometryMap() async {
    final Map<int, String> idGeometryMap = {};
    final String response = await rootBundle.loadString('assets/data/kw-status.csv');
    var d = const FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
    final List<List<dynamic>> rows =
        CsvToListConverter(csvSettingsDetector: d).convert(response);

    for (var row in rows.skip(1)) {
      var idValue = int.parse(row[0].toString());
      String groudIdValue = row[7].toString(); //그룹id
      String geometryValue = row[8].toString();
      idGeometryMap[idValue] = geometryValue;
    }
    return idGeometryMap;
  }

  Future<Map<int, Map<int, BoxCustom>>> loadGeoJson() async {
    final srcProj = proj4.Projection.add('EPSG:5181',
        '+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ');
    final dstProj = proj4.Projection.add(
        'EPSG:4326', '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ');

    final String response = await rootBundle.loadString('assets/data/prediction.geojson');
    final data = json.decode(response);

    final gp1 = GeoPrediction.fromJson(data);
    Map<int, Map<int, BoxCustom>> result = {};

    Map<int, BoxCustom> boxPoints = {};
    for (var feature in gp1.features) {
      List<Offset> points123 = [];
      var coordinates = feature.geometry?.coordinates[0][0];
      for (var coord in coordinates!) {
        try {
          final x = coord[0];
          final y = coord[1];
          final transformed =
              srcProj.transform(dstProj, proj4.Point(x: x, y: y));
          final adjustedX = (transformed.x - topLeftLng) *
              (imageWidth / ((bottomRightLng - topLeftLng) * 1));
          final adjustedY = (topLeftLat - transformed.y) *
              (imageHeight / ((topLeftLat - bottomRightLat) * 1));
          points123.add(Offset(adjustedX, adjustedY));
        } catch (e) {
          debugPrint('error: $e');
        }
      }
      boxPoints[feature.properties!.id!] = BoxCustom(
          id: feature.properties!.id!,
          lineColor: Colors.black,
          data: points123);
    }
    result[0] = boxPoints;

    Map<int, BoxCustom> points2 = {};
    var smallBoxes = await loadIdGeometryMap();

    // widget.robotPath;
    // final adjustedX = (widget.robotPath[0] - topLeftLng) *
    //     (imageWidth / ((bottomRightLng - topLeftLng) * 1));
    // final adjustedY = (topLeftLat - widget.robotPath[1]) *
    //     (imageHeight / ((topLeftLat - bottomRightLat) * 1));
    // robotOffset = [adjustedX, adjustedY];

    for (var i = 0; i < widget.robotPathHistory.length; i++) {
      final adjustedX = (widget.robotPathHistory[i][0] - topLeftLng) *
          (imageWidth / ((bottomRightLng - topLeftLng) * 1));
      final adjustedY = (topLeftLat - widget.robotPathHistory[i][1]) *
          (imageHeight / ((topLeftLat - bottomRightLat) * 1));
      robotPathList.add([adjustedX, adjustedY]);
      robotOffsetList.add(Offset(adjustedX, adjustedY));
    }

    robotOffset = robotPathList[robotOffsetList.length - 1];

    for (var key1 in smallBoxes.keys) {
      var polystring = smallBoxes[key1];

      var smallPoints = await _parsePolygonString(polystring!);

      // 기본 색상 설정
      Color polygonColor = Colors.blue.withOpacity(0.5);
      Color lineColor = IdColors.invisiable;

      // polygonIdList에서 일치하는 항목 찾기
      if (widget.polygonIdList != null) {
        polygonColor = IdColors.invisiable;
        for (var item in widget.polygonIdList!) {
          if (item[0] == key1) {
            // 두 번째 값이 20인지 확인
           if (item[1] == 1) {
              polygonColor = IdColors.waterPolygon1Level1.withOpacity(colorOpacity);
            } else if (item[1] == 2) {
              polygonColor = IdColors.waterPolygon1Level2.withOpacity(colorOpacity);
            } else if (item[1] == 3) {
              polygonColor = IdColors.waterPolygon1Level3.withOpacity(colorOpacity);
            } else if (item[1] == 4) {
              polygonColor = IdColors.waterPolygon1Level4.withOpacity(colorOpacity);
            } else if (item[1] == 5) {
              polygonColor = IdColors.waterPolygon1Level5.withOpacity(colorOpacity);
            } else if (item[1] == 6) {
              polygonColor = IdColors.waterPolygon1Level6.withOpacity(colorOpacity);
            } else if (item[1] == 7) {
              polygonColor = IdColors.waterPolygon1Level7.withOpacity(colorOpacity);
            } else if (item[1] == 8) {
              polygonColor = IdColors.waterPolygon1Level8.withOpacity(colorOpacity);
            } else if (item[1] == 9) {
              polygonColor = IdColors.waterPolygon1Level9.withOpacity(colorOpacity);
            } else if (item[1] == 10) {
              polygonColor = IdColors.waterPolygon1Level10.withOpacity(colorOpacity);
            } else if (item[1] == 11) {
              polygonColor = IdColors.waterPolygon1Level11.withOpacity(colorOpacity);
            } else if (item[1] == 12) {
              polygonColor = IdColors.waterPolygon1Level12.withOpacity(colorOpacity);
            } else if (item[1] == 13) {
              polygonColor = IdColors.waterPolygon1Level13.withOpacity(colorOpacity);
            } else if (item[1] == 14) {
              polygonColor = IdColors.waterPolygon1Level14.withOpacity(colorOpacity);
            } else if (item[1] == 15) {
              polygonColor = IdColors.waterPolygon1Level15.withOpacity(colorOpacity);
            } else if (item[1] == 16) {
              polygonColor = IdColors.waterPolygon1Level16.withOpacity(colorOpacity);
            } else if (item[1] == 17) {
              polygonColor = IdColors.waterPolygon1Level17.withOpacity(colorOpacity);
            } else if (item[1] == 18) {
              polygonColor = IdColors.waterPolygon1Level18.withOpacity(colorOpacity);
            } else if (item[1] == 19) {
              polygonColor = IdColors.waterPolygon1Level19.withOpacity(colorOpacity);
            } else if (item[1] == 20) {
              polygonColor = IdColors.waterPolygon1Level20.withOpacity(colorOpacity);
            } else if (item[1] == 21) {
              polygonColor = IdColors.waterPolygon1Level21.withOpacity(colorOpacity);
            } else if (item[1] == 22) {
              polygonColor = IdColors.waterPolygon1Level22.withOpacity(colorOpacity);
            } else if (item[1] == 23) {
              polygonColor = IdColors.waterPolygon1Level23.withOpacity(colorOpacity);
            } else if (item[1] == 24) {
              polygonColor = IdColors.waterPolygon1Level24.withOpacity(colorOpacity);
            } else if (item[1] == 25) {
              polygonColor = IdColors.waterPolygon1Level25.withOpacity(colorOpacity);
            } else if (item[1] == 26) {
              polygonColor = IdColors.waterPolygon1Level26.withOpacity(colorOpacity);
            } else if (item[1] == 27) {
              polygonColor = IdColors.waterPolygon1Level27.withOpacity(colorOpacity);
            } else if (item[1] == 28) {
              polygonColor = IdColors.waterPolygon1Level28.withOpacity(colorOpacity);
            } else if (item[1] == 29) {
              polygonColor = IdColors.waterPolygon1Level29.withOpacity(colorOpacity);
            } else if (item[1] >= 30) {
              polygonColor = IdColors.waterPolygon1Level30.withOpacity(colorOpacity);
            }  else {
              polygonColor = IdColors.invisiable.withOpacity(0);
            } 
            break; // 일치하는 항목을 찾았으므로 반복 중단
          }
        }
      }

      if (widget.polygonIdList2 != null) {
        polygonColor = IdColors.invisiable;
        for (var item in widget.polygonIdList2!) {
          if (item[0] == key1) {
            if (item[1] == 1) {
              polygonColor = IdColors.waterPolygon1Level30.withOpacity(0.5);
            } else if (item[1] == 2) {
              polygonColor = IdColors.waterPolygon1Level25.withOpacity(0.5);
            } else if (item[1] == 3) {
              polygonColor = IdColors.waterPolygon1Level21.withOpacity(0.5);
            } else if (item[1] == 4) {
              polygonColor = IdColors.waterPolygon1Level16.withOpacity(0.5);
            } else if (item[1] == 5) {
              polygonColor = IdColors.waterPolygon1Level7.withOpacity(0.5);
            } else if (item[1] == 6) {
              polygonColor = IdColors.waterPolygon1Level1.withOpacity(0.5);
            } else {
              polygonColor = IdColors.invisiable;
            }
            break; // 일치하는 항목을 찾았으므로 반복 중단
          }
        }
      }

      points2[key1] = BoxCustom(
        id: key1,
        color: polygonColor,
        lineColor: lineColor,
        data: smallPoints,
      );
    }
    result[1] = points2;
    return result;
  }

  List<double> robotPathOffset() {
    List<double> result = [];

    return result;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 10), () async {
      boxMapMap = await loadGeoJson();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    topLeftLat = centerLat + (imageWidth / 2) * lat1m;
    topLeftLng = centerLongi - (imageHeight / 2) * longi1m;

    bottomRightLat = centerLat - (imageWidth / 2) * lat1m;
    bottomRightLng = centerLongi + (imageHeight / 2) * longi1m;

    return SizedBox(
      key: ValueKey('sizedbox_background'),
      width: imageWidth,
      height: imageHeight,
      child: (widget.setData)
          ? IdPolygonWidget(
              key: ValueKey('kwater_polygon_background'),
              boxMapMap: boxMapMap,
              topLeftLat: topLeftLat,
              topLeftLng: topLeftLng,
              bottomRightLat: bottomRightLat,
              bottomRightLng: bottomRightLng,
              imageWidth: imageWidth,
              imageHeight: imageHeight,
              showBackground: true,
              color: Colors.blue,
              showPolygon: widget.showPolygon,
              showDevice: widget.showDevice,
              showIcon: widget.showIcon,
              onPolygonClick: widget.onPolygonClick,
              polygonGrupList: widget.polygonGrupList,
              robotPositionList: robotOffset,
              robotPathHistory: robotOffsetList,
              deviceValue: widget.deviceValue ?? 0,
            )
          : Image.asset(
              'assets/img/map16x2.jpg',
              key: const ValueKey('polygonwidet123_map16x2_123'),
              width: 1920,
              height: 1920,
              fit: BoxFit.cover,
            ),
    );
  }
}
