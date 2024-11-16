import 'package:flutter/material.dart';

class IdSpace extends StatefulWidget {
  final double spaceWidth;
  final double spaceHeight;
  const IdSpace({super.key, required this.spaceWidth, required this.spaceHeight});

  @override
  State<IdSpace> createState() => _IdSpaceState();
}

class _IdSpaceState extends State<IdSpace> {
  @override
  Widget build(BuildContext context) {
    Widget wg1 = SizedBox(
      width: widget.spaceWidth,
      height: widget.spaceHeight,
    );
    return wg1;
  }
}
