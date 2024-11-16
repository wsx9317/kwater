// PolygonPainterWidget 클래스 추가
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// 좌표 변환을 위한 라이브러리 (예: proj4js) 필요
import 'package:proj4dart/proj4dart.dart' as proj4;

// PolygonPainter 클래스 추가
class PolygonPainter extends CustomPainter {
  final List<Offset> points;

  PolygonPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class IdMultiPolygonPainterWidget extends StatelessWidget {
  Future<List<Offset>> loadGeoJson() async {
    final srcProj = proj4.Projection.add(
        'EPSG:5181', '+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs');
    final dstProj = proj4.Projection.WGS84;

    final String response = await rootBundle.loadString('assets/data/prediction.geojson');
    final data = json.decode(response);

    List<Offset> points = [];
    for (var feature in data['features']) {
      var coordinates = feature['geometry']['coordinates'][0];
      for (var coord in coordinates) {
        try {
          final x = (coord[0] as List).map((e) => e.toDouble()).toList()[0]; // JSArray를 double로 변환
          final y = (coord[1] as List).map((e) => e.toDouble()).toList()[0]; // JSArray를 double로 변환
          final transformed = srcProj.transform(dstProj, proj4.Point(x: x, y: y)); // x와 y를 명시적으로 전달
          points.add(Offset(transformed.x, transformed.y)); // Point를 Offset으로 변환
        } catch (e) {
          debugPrint('error: $e');
        }
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Offset>>(
      future: loadGeoJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading GeoJSON'));
        } else {
          final points = snapshot.data ?? [];
          return CustomPaint(
            painter: PolygonPainter(points), // points를 사용하여 그리기
          );
        }
      },
    );
  }
}
