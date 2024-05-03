import 'dart:ui';

const _black = Color(0xFF000000);
const _grey = Color(0xFF607D8B);
const _transparent = Color(0x00000000);
const _white = Color(0xFFFFFFFF);

class TabContext {
  final Color backgroundColor;
  final Paint chartFillPaint;
  final Paint chartStrokePaint;
  final Color labelTextColor;
  final Paint noteLabelPaint;
  final Paint noteShapePaint;
  final Paint techniquePaint;

  TabContext(
      {this.backgroundColor = _transparent,
      required Color chartColor,
      required this.labelTextColor,
      required Color noteLabelColor,
      required Color noteShapeColor,
      required Color techniqueColor})
      : chartFillPaint = Paint()
          ..color = chartColor
          ..style = PaintingStyle.fill,
        chartStrokePaint = Paint()
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
    const backgroundColor = _transparent;
    const chartColor = _grey;
    final labelColor = brightness == Brightness.dark ? _white : _black;
    final noteLabelColor = brightness == Brightness.dark ? _black : _white;
    final noteShapeColor = brightness == Brightness.dark ? _white : _black;
    const techniqueColor = _grey;
    return TabContext(
        backgroundColor: backgroundColor,
        chartColor: chartColor,
        labelTextColor: labelColor,
        noteLabelColor: noteLabelColor,
        noteShapeColor: noteShapeColor,
        techniqueColor: techniqueColor);
  }

  Color get chartColor => chartFillPaint.color;

  Color get noteLabelColor => noteLabelPaint.color;

  Color get noteShapeColor => noteShapePaint.color;

  Color get techniqueColor => techniquePaint.color;
}
