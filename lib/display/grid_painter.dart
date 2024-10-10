import 'package:flutter/widgets.dart';
import 'package:libtab/libtab.dart';

class GridPainter extends CustomPainter {
  static void paintGrid(TabContext tabContext, Canvas canvas, Size size,
      {required int verticalLines, required int horizontalLines}) {
    final path = Path()
      ..addRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));
    if (horizontalLines > 0) {
      final horizontalSpacing = size.height / (horizontalLines - 1);
      for (var i = 1; i < horizontalLines - 1; i++) {
        var y = horizontalSpacing * i;
        path.moveTo(0, y);
        path.lineTo(size.width, y);
      }
    }
    if (verticalLines > 0) {
      final verticalSpacing = size.width / (verticalLines - 1);
      for (var i = 1; i < verticalLines - 1; i++) {
        var x = verticalSpacing * i;
        path.moveTo(x, 0);
        path.lineTo(x, size.height);
      }
    }
    canvas.drawPath(path, tabContext.chartStrokePaint);
  }

  final TabContext tabContext;
  final int verticalLines;
  final int horizontalLines;

  GridPainter(
      {required this.tabContext,
      this.verticalLines = 0,
      this.horizontalLines = 0}) {
    assert(verticalLines >= 0 || horizontalLines >= 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(tabContext, canvas, size,
        verticalLines: verticalLines, horizontalLines: horizontalLines);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      !identical(horizontalLines, oldDelegate.horizontalLines) ||
      !identical(tabContext, oldDelegate.tabContext) ||
      !identical(verticalLines, oldDelegate.verticalLines);
}
