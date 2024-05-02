import 'package:flutter/material.dart';

class TabContext {
  final Color backgroundColor;
  final Paint chartPaint;
  final Color labelTextColor;
  final Paint noteLabelPaint;
  final Paint noteShapePaint;
  final Paint techniquePaint;

  TabContext(
      {this.backgroundColor = Colors.transparent,
      required Color chartColor,
      required this.labelTextColor,
      required Color noteLabelColor,
      required Color noteShapeColor,
      required Color techniqueColor})
      : chartPaint = Paint()
          ..color = chartColor
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        noteLabelPaint = Paint()
          ..color = noteLabelColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
        noteShapePaint = Paint()
          ..color = noteShapeColor
          ..style = PaintingStyle.fill,
        techniquePaint = Paint()
          ..color = techniqueColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

  factory TabContext.forBrightness(Brightness brightness) {
    const backgroundColor = Colors.transparent;
    const chartColor = Colors.blueGrey;
    final labelColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    final noteLabelColor =
        brightness == Brightness.dark ? Colors.black : Colors.white;
    final noteShapeColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    const techniqueColor = Colors.blueGrey;
    return TabContext(
        backgroundColor: backgroundColor,
        chartColor: chartColor,
        labelTextColor: labelColor,
        noteLabelColor: noteLabelColor,
        noteShapeColor: noteShapeColor,
        techniqueColor: techniqueColor);
  }

  Color get chartColor => chartPaint.color;

  Color get noteLabelColor => noteLabelPaint.color;

  Color get noteShapeColor => noteShapePaint.color;

  Color get techniqueColor => techniquePaint.color;
}
