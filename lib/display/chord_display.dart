import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:libtab/libtab.dart';
import 'grid_painter.dart';

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
    return Center(
      child: Container(
          color: tabContext.backgroundColor,
          child: CustomPaint(
              willChange: false,
              size: size,
              painter: ChordChartPainter(tabContext, chord))),
    );
  }
}

class ChordChartPainter extends CustomPainter {
  final TabContext tabContext;
  final ChordNoteSet chord;
  final Paint notePaint;
  final int stringCount;
  double fretSpacing = 0;
  double stringSpacing = 0;
  double noteRadius = 0;

  ChordChartPainter(this.tabContext, this.chord)
      : notePaint = tabContext.noteShapePaint(PaintingStyle.fill),
        stringCount = chord.instrument.stringCount();

  @override
  void paint(Canvas canvas, Size size) {
    fretSpacing = size.height / 5;
    stringSpacing = size.width / (stringCount - 1);
    noteRadius = min(stringSpacing, fretSpacing) / 3;
    GridPainter.paintGrid(tabContext, canvas, size,
        verticalLines: stringCount, horizontalLines: 6);
    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(size.width, 3)),
        tabContext.chartPaint(PaintingStyle.fill));
    if (chord.notes != null) {
      drawNote(canvas, size, chord.notes!);
    }
  }

  void drawNote(Canvas canvas, Size size, Note note) {
    final x = size.width - (note.string - 1) * stringSpacing;
    final y = ((note.fret - 1) * fretSpacing) + (fretSpacing / 2);
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(x, y), radius: noteRadius));
    canvas.drawShadow(path, tabContext.noteLabelColor, 6, false);
    canvas.drawPath(path, notePaint);

    if (note.and != null) {
      drawNote(canvas, size, note.and!);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
