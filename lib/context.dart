import 'package:flutter/material.dart';

class TabContext {
  final Color backgroundColor;
  final Color chartColor;
  final Color labelColor;
  final Color noteLabelColor;
  final Color noteShapeColor;

  TabContext(
      {this.backgroundColor = Colors.transparent,
      required this.chartColor,
      required this.labelColor,
      required this.noteLabelColor,
      required this.noteShapeColor});

  TabContext.forBrightness(Brightness brightness)
      : backgroundColor = Colors.transparent,
        chartColor = Colors.blueGrey,
        labelColor =
            brightness == Brightness.dark ? Colors.white : Colors.black,
        noteLabelColor =
            brightness == Brightness.dark ? Colors.black : Colors.white,
        noteShapeColor =
            brightness == Brightness.dark ? Colors.white : Colors.black;

  Paint chartPaint(PaintingStyle style, {double width = 1}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = chartColor;
  }

  Paint noteLabelPaint(PaintingStyle style, {double width = 2}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = noteLabelColor;
  }

  Paint noteShapePaint(PaintingStyle style, {double width = 2}) {
    return Paint()
      ..strokeWidth = width
      ..style = style
      ..color = noteShapeColor;
  }
}
