import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:libtab/libtab.dart';

import 'grid_painter.dart';

// todo omit nut and indicate chord positions up the neck from first fret
// todo support banjo finger indicators (thumb, index, middle)
// todo support painting guitar strum indicators (open, close)
class ChordChartDisplay extends StatelessWidget {
  static const Size defaultSize = Size(200, 250);
  final TabContext tabContext;
  final Size size;
  final ChordNoteSet chord;

  const ChordChartDisplay(
      {super.key,
      this.size = defaultSize,
      required this.tabContext,
      required this.chord});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: tabContext.backgroundColor,
        child: chord.noData
            ? buildDataUnavailable()
            : CustomPaint(
                willChange: false,
                size: size,
                painter: ChordChartPainter(tabContext, chord)));
  }

  Widget buildDataUnavailable() {
    return Stack(children: [
      Opacity(
        opacity: .3,
        child: CustomPaint(
            willChange: false,
            size: size,
            painter: ChordChartPainter(tabContext, chord)),
      ),
      Positioned.fromRect(
          rect: Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text('Chord ${chord.chord.label()}'),
                const Text('unavailable'),
                Text('for ${chord.instrument.label()}'),
              ])))
    ]);
  }
}

class ChordChartPainter extends CustomPainter {
  final TabContext tabContext;
  final ChordNoteSet chord;
  final int stringCount;
  double fretSpacing = 0;
  double stringSpacing = 0;
  double noteRadius = 0;

  ChordChartPainter(this.tabContext, this.chord)
      : stringCount = chord.instrument.stringCount();

  @override
  void paint(Canvas canvas, Size size) {
    fretSpacing = size.height / 5;
    stringSpacing = size.width / (stringCount - 1);
    noteRadius = min(stringSpacing, fretSpacing) / 3;
    GridPainter.paintGrid(tabContext, canvas, size,
        verticalLines: stringCount, horizontalLines: 6);
    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(size.width, 3)),
        tabContext.chartFillPaint);
    if (chord.notes != null) {
      drawNote(canvas, size, chord.notes!);
    }
  }

  void drawNote(Canvas canvas, Size size, Note note) {
    const double minShadowElevation = 2;
    const double maxShadowElevation = 5;
    final x = size.width - (note.string - 1) * stringSpacing;
    final y = ((note.fret - 1) * fretSpacing) + (fretSpacing / 2);
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(x, y), radius: noteRadius));
    final shadowElevation =
        (noteRadius / 2).clamp(minShadowElevation, maxShadowElevation);
    canvas.drawShadow(path, tabContext.noteLabelColor, shadowElevation, false);
    canvas.drawPath(path, tabContext.noteShapePaint);

    if (note.and != null) {
      drawNote(canvas, size, note.and!);
    }
  }

  @override
  bool shouldRepaint(ChordChartPainter oldDelegate) =>
      !identical(chord, oldDelegate.chord) ||
      !identical(fretSpacing, oldDelegate.fretSpacing) ||
      !identical(noteRadius, oldDelegate.noteRadius) ||
      !identical(stringCount, oldDelegate.stringCount) ||
      !identical(stringSpacing, oldDelegate.stringSpacing) ||
      !identical(tabContext, oldDelegate.tabContext);
}
