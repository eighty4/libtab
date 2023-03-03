import 'package:flutter/widgets.dart';
import 'package:libtab/libtab.dart';
import 'note_positioning.dart';

class MeasureDisplay extends StatelessWidget {
  static const defaultSize = Size(300, 200);
  final TabContext tabContext;
  final Size size;
  final Instrument instrument;
  final bool last;
  final Measure measure;
  final String? label;

  const MeasureDisplay(this.measure,
      {super.key,
      this.size = defaultSize,
      required this.tabContext,
      required this.instrument,
      this.label,
      this.last = false});

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return buildMeasure();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(label!,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: tabContext.labelColor)),
        ),
        buildMeasure()
      ],
    );
  }

  Container buildMeasure() {
    final chartPositioning = ChartPositioning.calculate(size, instrument);
    final notePositioning =
        NotePositioning.calculate(measure.notes, chartPositioning);
    final chartPaint = CustomPaint(
        size: size,
        painter: MeasureChartPainter(
            tabContext: tabContext,
            instrument: instrument,
            measure: measure,
            last: last,
            chartPositioning: chartPositioning));
    final notesPaint = CustomPaint(
        size: size,
        painter: MeasureNotePainter(
            tabContext: tabContext,
            measure: measure,
            chartPositioning: chartPositioning,
            notePositioning: notePositioning));
    final List<Widget> children = [chartPaint, notesPaint];
    return Container(
        color: tabContext.backgroundColor,
        child: Stack(
          children: children,
        ));
  }
}

class MeasureChartPainter extends CustomPainter {
  static const double barPad = 3;
  static const double fatBar = 5;
  static const double thinBar = 2;
  static const double repeatDot = 18;
  static const double repeatDotRadius = 3;
  final Instrument instrument;
  final bool last;
  final Measure measure;
  final ChartPositioning chartPositioning;
  final TabContext tabContext;

  MeasureChartPainter(
      {required this.instrument,
      required this.last,
      required this.measure,
      required this.chartPositioning,
      required this.tabContext});

  @override
  void paint(Canvas canvas, Size size) {
    paintStrings(canvas, size);
    paintMeasureDecorations(canvas, size);
  }

  void paintStrings(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 1; i < instrument.stringCount(); i++) {
      final y = chartPositioning.stringSpacing * i;
      path.moveTo(0, y);
      path.lineTo(size.width, y);
    }
    path.addRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));
    canvas.drawPath(path, tabContext.chartPaint(PaintingStyle.stroke));
  }

  void paintMeasureDecorations(Canvas canvas, Size size) {
    final path = Path();
    if (measure.repeatStart || measure.repeatEnd || last) {
      addRepeatBarsToPath(path, size);
    }
    if (measure.repeatStart || measure.repeatEnd) {
      addRepeatCirclesToPath(path, size);
    }
    canvas.drawPath(path, tabContext.chartPaint(PaintingStyle.fill));
  }

  void addRepeatBarsToPath(Path path, Size size) {
    final fat = Rect.fromPoints(Offset.zero, Offset(fatBar, size.height));
    final thin = Rect.fromPoints(const Offset(fatBar + barPad, 0),
        Offset(fatBar + thinBar + barPad, size.height));
    if (measure.repeatStart) {
      path.addRect(fat);
      path.addRect(thin);
    }
    if (measure.repeatEnd || last) {
      path.addRect(fat.translate(size.width - fat.width, 0));
      path.addRect(
          thin.translate(size.width - (thin.left * 2) - thin.width, 0));
    }
  }

  void addRepeatCirclesToPath(Path path, Size size) {
    final top = Rect.fromCircle(
        center: Offset(
            repeatDot,
            chartPositioning.stringSpacing *
                instrument.topRepeatCircleCenter()),
        radius: repeatDotRadius);
    final bottom = Rect.fromCircle(
        center: Offset(
            repeatDot,
            chartPositioning.stringSpacing *
                instrument.bottomRepeatCircleCenter()),
        radius: repeatDotRadius);
    if (measure.repeatStart) {
      path.addOval(top);
      path.addOval(bottom);
    }
    if (measure.repeatEnd) {
      path.addOval(top.translate(size.width - (repeatDot * 2), 0));
      path.addOval(bottom.translate(size.width - (repeatDot * 2), 0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

extension RepeatCircleCenterFns on Instrument {
  double topRepeatCircleCenter() => 1.5;

  double bottomRepeatCircleCenter() {
    switch (this) {
      case Instrument.banjo:
        return 2.5;
      case Instrument.guitar:
        return 3.5;
    }
  }
}

class MeasureNotePainter extends CustomPainter {
  final TabContext tabContext;
  final Measure measure;
  final Paint noteLabelPaint;
  final Paint noteFillPaint;
  final Paint noteStrokePaint;
  final ChartPositioning chartPositioning;
  final NotePositioning notePositioning;

  MeasureNotePainter(
      {required this.tabContext,
      required this.measure,
      required this.chartPositioning,
      required this.notePositioning})
      : noteLabelPaint = tabContext.noteLabelPaint(PaintingStyle.stroke),
        noteFillPaint = tabContext.noteShapePaint(PaintingStyle.fill),
        noteStrokePaint = tabContext.noteShapePaint(PaintingStyle.stroke);

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
    // todo dynamic size and position
    final path = Path()..addOval(Rect.fromCircle(center: offset, radius: 12));
    canvas.drawShadow(path, tabContext.noteLabelColor, 6, false);
    canvas.drawPath(path, noteFillPaint);

    final textStyle = TextStyle(color: tabContext.noteLabelColor, fontSize: 22);
    final textSpan = TextSpan(text: note.fret.toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: 30,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, offset.translate(-15, -13));

    if (note.melody) {
      canvas.drawCircle(offset, 16, noteLabelPaint);
    }
  }

  void paintHammerLine(
      Canvas canvas, Size size, Offset noteOffset, Offset releaseOffset) {
    final y = releaseOffset.dy - (chartPositioning.stringSpacing * .3);
    final xTo = releaseOffset.dx - 8;
    final xFrom = noteOffset.dx + 8;
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y - (chartPositioning.stringSpacing * .3);
    final path = Path()
      ..moveTo(xFrom, y)
      ..quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, noteStrokePaint);
  }

  void paintPullLine(
      Canvas canvas, Size size, Offset noteOffset, Offset releaseOffset) {
    final y = releaseOffset.dy + (chartPositioning.stringSpacing * .3);
    final xTo = releaseOffset.dx - 8;
    final xFrom = noteOffset.dx + 8;
    final xControl = ((xTo - xFrom) / 2) + xFrom;
    final yControl = y + (chartPositioning.stringSpacing * .3);
    final path = Path()
      ..moveTo(xFrom, y)
      ..quadraticBezierTo(xControl, yControl, xTo, y);
    canvas.drawPath(path, noteStrokePaint);
  }

  void paintSlideLine(
      Canvas canvas, Size size, Offset noteOffset, Offset releaseOffset) {
    final y = releaseOffset.dy - (chartPositioning.stringSpacing * .3);
    final path = Path()
      ..moveTo(noteOffset.dx + 8, y)
      ..lineTo(releaseOffset.dx - 8, y);
    canvas.drawPath(path, noteStrokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
