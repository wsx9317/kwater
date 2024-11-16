import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';

class IdBtn extends StatelessWidget {
  final Function()? onBtnPressed;
  final Widget childWidget;
  const IdBtn({super.key, this.onBtnPressed, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    Widget wg1 = DeferredPointerHandler(
        child: DeferPointer(
            child: TextButton(
      onPressed: onBtnPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: childWidget,
    )));
    return wg1;
  }
}
