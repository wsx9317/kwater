// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:kwater/id_widget/IdColor.dart';
import 'package:kwater/id_widget/IdImgBox1.dart';
import 'package:kwater/id_widget/Idbtn.dart';
import 'package:kwater/common/uiCommon.dart';

//의사결정 하단 수치값
class IdValueBox extends StatefulWidget {
  final String text;
  final String imagePath;
  final String runText;
  final Widget valueController;
  final String valueMaxText;
  final Widget btnWidget;
  final String currentNum;
  final Color currentNumColor;

  const IdValueBox({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.runText,
    required this.valueController,
    required this.valueMaxText,
    required this.btnWidget,
    required this.currentNum,
    required this.currentNumColor,
  }) : super(key: key); // Pass the key to the superclass

  @override
  State<IdValueBox> createState() => _IdValueBoxState();
}

class _IdValueBoxState extends State<IdValueBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 42,
          width: 358,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: IdColors.white16per),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    uiCommon.styledText(widget.text, 14, 0, 1, FontWeight.w700,
                        IdColors.white, TextAlign.start),
                    IdImgBox1(
                        imageWidth: 20,
                        imageHeight: 20,
                        imagePath: widget.imagePath,
                        imageFit: BoxFit.cover),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 10,
                decoration: BoxDecoration(color: IdColors.white40per),
              ),
              const SizedBox(width: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    child: uiCommon.styledText(
                        '1/${widget.valueMaxText}',
                        12,
                        0,
                        1,
                        FontWeight.w500,
                        IdColors.white70per,
                        TextAlign.center),
                  ),
                  const SizedBox(width: 2),
                  widget.valueController,
                  const SizedBox(width: 2),
                ],
              ),
              SizedBox(
                width: 20,
                child: uiCommon.styledText(widget.currentNum, 16, 0, 1,
                    FontWeight.w700, widget.currentNumColor, TextAlign.center),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 38,
                child: uiCommon.styledText(widget.runText, 14, 0, 1,
                    FontWeight.w400, IdColors.white70per, TextAlign.right),
              ),
              const SizedBox(width: 8),
              widget.btnWidget
              /* IdBtn(
                onBtnPressed: widget.onBtnPressed,
                childWidget: IdImgBox1(
                    imageWidth: 16,
                    imageHeight: 16,
                    imagePath: widget.btnImagePath,
                    imageFit: BoxFit.cover),
              ), */
            ],
          ),
        ),
        /* Visibility(
          visible: widget.dropShow,
          child: Positioned(
              bottom: 30,
              right: 4,
              child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: IdColors.white90per),
                  child: Column(
                    children: [
                      HoverContainer(
                        width: double.infinity,
                        height: 30,
                        hoverDecoration: BoxDecoration(
                            color: IdColors.white90per,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))),
                        child: IdBtn(
                          onBtnPressed: widget.dropMenuPressed1,
                          childWidget: uiCommon.styledText(
                              '가동',
                              12,
                              0,
                              1,
                              FontWeight.w500,
                              IdColors.black90Per,
                              TextAlign.center),
                        ),
                      ),
                      Center(
                        child: Container(
                            width: 60, height: 1, color: IdColors.darkGray2),
                      ),
                      HoverContainer(
                        width: double.infinity,
                        height: 30,
                        hoverDecoration: BoxDecoration(
                            color: IdColors.white90per,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        child: IdBtn(
                          onBtnPressed: widget.dropMenuPressed2,
                          childWidget: uiCommon.styledText(
                              '미가동',
                              12,
                              0,
                              1,
                              FontWeight.w500,
                              IdColors.black90Per,
                              TextAlign.center),
                        ),
                      ),
                    ],
                  ))),
        ), */
      ],
    );
  }
}
