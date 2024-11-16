import 'package:flutter/material.dart';
import 'package:kwater/id_widget/IdBtn.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdZoomDrag.dart';

class Zoom1 extends StatelessWidget {
  Zoom1({super.key});

  final ZoomDragController _controller = ZoomDragController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('줌 컨트롤'),
        actions: [
          IdBtn(
            onBtnPressed: () => _controller.zoomIn(),
            childWidget: const Icon(Icons.zoom_in),
          ),
          IdBtn(
            onBtnPressed: () => _controller.zoomOut(),
            childWidget: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              color: IdColors.white,
            ),
            IdZoomdrag(
              windowWidth: 500,
              windowHeight: 500,
              contentWidth: 1500,
              contentHeight: 1500,
              controller: _controller,
              children: [
                Positioned(
                  top: 1010,
                  left: 500,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Box 3',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 100,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Box 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 150,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Box 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
