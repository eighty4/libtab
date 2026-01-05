import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:libtab/display/grid_painter.dart';
import 'package:libtab/display/note_positioning.dart';
import 'package:libtab/libtab.dart';

/// Paints a [Measure] of tab data that can be styled with [TabContext]
class MeasureChartPainter extends CustomPainter {
  static const double barPad = 3;
  static const double fatBar = 5;
  static const double thinBar = 2;
  static const double repeatDot = 18;
  static const double repeatDotRadius = 3;
  final ChartPositioning chartPositioning;
  final Instrument instrument;
  final bool repeatEndOrLastMeasure;
  final bool repeatStart;
  final TabContext tabContext;

  MeasureChartPainter({
    required this.chartPositioning,
    required this.instrument,
    this.repeatEndOrLastMeasure = false,
    this.repeatStart = false,
    required this.tabContext,
  });

  MeasureChartPainter.forMeasure({
    required ChartPositioning chartPositioning,
    required Instrument instrument,
    required bool last,
    required Measure measure,
    required TabContext tabContext,
  }) : this(
         instrument: instrument,
         chartPositioning: chartPositioning,
         repeatEndOrLastMeasure: last || measure.repeatEnd,
         repeatStart: measure.repeatStart,
         tabContext: tabContext,
       );

  @override
  void paint(Canvas canvas, Size size) {
    GridPainter.paintGrid(
      tabContext,
      canvas,
      size,
      verticalLines: 2,
      horizontalLines: instrument.stringCount(),
    );
    paintMeasureDecorations(canvas, size);
  }

  void paintMeasureDecorations(Canvas canvas, Size size) {
    final path = Path();
    if (repeatEndOrLastMeasure) {
      addRepeatBarsToPath(path, size);
    }
    if (repeatStart) {
      addRepeatCirclesToPath(path, size);
    }
    canvas.drawPath(path, tabContext.chartFillPaint);
  }

  void addRepeatBarsToPath(Path path, Size size) {
    final fat = Rect.fromPoints(Offset.zero, Offset(fatBar, size.height));
    final thin = Rect.fromPoints(
      const Offset(fatBar + barPad, 0),
      Offset(fatBar + thinBar + barPad, size.height),
    );
    if (repeatStart) {
      path.addRect(fat);
      path.addRect(thin);
    }
    if (repeatEndOrLastMeasure) {
      path.addRect(fat.translate(size.width - fat.width, 0));
      path.addRect(
        thin.translate(size.width - (thin.left * 2) - thin.width, 0),
      );
    }
  }

  void addRepeatCirclesToPath(Path path, Size size) {
    final top = Rect.fromCircle(
      center: Offset(
        repeatDot,
        chartPositioning.stringSpacing * instrument.topRepeatCircleCenter(),
      ),
      radius: repeatDotRadius,
    );
    final bottom = Rect.fromCircle(
      center: Offset(
        repeatDot,
        chartPositioning.stringSpacing * instrument.bottomRepeatCircleCenter(),
      ),
      radius: repeatDotRadius,
    );
    if (repeatStart) {
      path.addOval(top);
      path.addOval(bottom);
    }
    if (repeatEndOrLastMeasure) {
      path.addOval(top.translate(size.width - (repeatDot * 2), 0));
      path.addOval(bottom.translate(size.width - (repeatDot * 2), 0));
    }
  }

  @override
  bool shouldRepaint(MeasureChartPainter oldDelegate) =>
      chartPositioning != oldDelegate.chartPositioning ||
      instrument != oldDelegate.instrument ||
      repeatEndOrLastMeasure != oldDelegate.repeatEndOrLastMeasure ||
      repeatStart != oldDelegate.repeatStart ||
      tabContext.backgroundColor != oldDelegate.tabContext.backgroundColor ||
      tabContext.chartFillPaint != oldDelegate.tabContext.chartFillPaint ||
      tabContext.chartStrokePaint != oldDelegate.tabContext.chartStrokePaint;
}

extension RepeatCircleCenterFns on Instrument {
  double topRepeatCircleCenter() => 1.5;

  double bottomRepeatCircleCenter() => switch (this) {
    Instrument.banjo => 2.5,
    Instrument.guitar => 3.5,
  };
}

class MeasureNotePainter extends CustomPainter {
  static const double _minNoteRadius = 3;
  static const double _maxNoteRadius = 20;
  static const double _minShadowElevation = 1;
  static const double _maxShadowElevation = 5;

  static double calcNoteRadius(Size measureSize) {
    return (min(measureSize.width / 2, measureSize.height) * .09).clamp(
      _minNoteRadius,
      _maxNoteRadius,
    );
  }

  final TabContext tabContext;
  final Measure measure;
  final ChartPositioning chartPositioning;
  final NotePositioning notePositioning;

  MeasureNotePainter({
    required this.tabContext,
    required this.measure,
    required this.chartPositioning,
    required this.notePositioning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    notePositioning.notes.forEach((sixteenthNth, notes) {
      for (var positioning in notes) {
        paintNote(canvas, size, positioning.note, positioning.offset);
      }
    });

    for (var positioning in notePositioning.techniques) {
      switch (positioning.technique) {
        case Technique.hammerOn:
          paintHammerLine(canvas, size, positioning.from, positioning.to);
          break;
        case Technique.pullOff:
          paintPullLine(canvas, size, positioning.from, positioning.to);
          break;
        case Technique.slide:
          paintSlideLine(canvas, size, positioning.from, positioning.to);
          break;
      }
    }
  }

  void paintNote(Canvas canvas, Size size, Note note, Offset offset) {
    const double noteRadiusRangeDiff = _maxNoteRadius - _minNoteRadius;
    final double noteRadius = calcNoteRadius(size);
    final shadowElevation =
        ((noteRadius - _minNoteRadius) / noteRadiusRangeDiff) *
        _maxShadowElevation;
    final path = Path()
      ..addOval(Rect.fromCircle(center: offset, radius: noteRadius));
    canvas.drawShadow(
      path,
      tabContext.noteLabelColor,
      max(_minShadowElevation, shadowElevation),
      false,
    );
    canvas.drawPath(path, tabContext.noteShapePaint);

    final textStyle = TextStyle(
      color: tabContext.noteLabelColor,
      fontSize: noteRadius * 1.5,
    );
    final textSpan = TextSpan(text: note.fret.toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      offset - Offset(textPainter.size.width / 2, textPainter.size.height / 2),
    );

    if (note.melody) {
      canvas.drawCircle(offset, noteRadius, tabContext.techniquePaint);
    }
  }

  void paintHammerLine(
    Canvas canvas,
    Size size,
    Offset noteOffset,
    Offset releaseOffset,
  ) {
    final y = releaseOffset.dy - (chartPositioning.stringSpacing * .3);
    final xTo = releaseOffset.dx - 8;
    final xFrom = noteOffset.dx + 8;
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y - (chartPositioning.stringSpacing * .3);
    final path = Path()
      ..moveTo(xFrom, y)
      ..quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, tabContext.techniquePaint);
  }

  void paintPullLine(
    Canvas canvas,
    Size size,
    Offset noteOffset,
    Offset releaseOffset,
  ) {
    final y = releaseOffset.dy + (chartPositioning.stringSpacing * .3);
    final xTo = releaseOffset.dx - 8;
    final xFrom = noteOffset.dx + 8;
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y + (chartPositioning.stringSpacing * .3);
    final path = Path()
      ..moveTo(xFrom, y)
      ..quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, tabContext.techniquePaint);
  }

  void paintSlideLine(
    Canvas canvas,
    Size size,
    Offset noteOffset,
    Offset releaseOffset,
  ) {
    final y = releaseOffset.dy - (chartPositioning.stringSpacing * .3);
    final path = Path()
      ..moveTo(noteOffset.dx + 8, y)
      ..lineTo(releaseOffset.dx - 8, y);
    canvas.drawPath(path, tabContext.techniquePaint);
  }

  @override
  bool shouldRepaint(MeasureNotePainter oldDelegate) =>
      !identical(measure, oldDelegate.measure) ||
      !identical(notePositioning, oldDelegate.notePositioning) ||
      chartPositioning != oldDelegate.chartPositioning ||
      tabContext.noteLabelColor != oldDelegate.tabContext.noteLabelColor ||
      tabContext.noteShapePaint != oldDelegate.tabContext.noteShapePaint ||
      tabContext.techniquePaint != oldDelegate.tabContext.techniquePaint;
}
