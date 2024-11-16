import 'package:flutter/material.dart';

class CellData {
  final Color color;
  final bool isVisible;

  CellData({required this.color, this.isVisible = true});
}

class GridBoxes extends StatelessWidget {
  final int rows;
  final int columns;
  final double boxSize;
  final List<List<CellData>> cellDataArray;

  const GridBoxes({
    Key? key,
    this.rows = 30,
    this.columns = 30,
    this.boxSize = 20.0,
    required this.cellDataArray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: columns * boxSize,
        height: rows * boxSize,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1.0,
          ),
          itemCount: rows * columns,
          itemBuilder: (context, index) {
            int row = index ~/ columns;
            int col = index % columns;
            CellData cellData = cellDataArray[row][col];
            return Container(
              width: boxSize,
              height: boxSize,
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 2.0),
                color: cellData.isVisible ? cellData.color : Colors.transparent,
              ),
            );
          },
        ),
      ),
    );
  }
}
