import 'dart:ui';

import 'package:libtab/libtab.dart';

/// Container and calculator of [Canvas] spacing values for strings and notes
class ChartPositioning {
  /// Spacing between sixteenth notes on x-axis
  final double sixteenthSpacing;

  /// Spacing between strings on y-axis
  final double stringSpacing;

  /// Horizontal padding on the edges of a measure before first note
  final double xOffset;

  ChartPositioning(
      {required this.sixteenthSpacing,
      required this.stringSpacing,
      required this.xOffset});

  factory ChartPositioning.calculate(Size size, Instrument instrument) {
    return ChartPositioning(
      sixteenthSpacing: size.width / 18,
      stringSpacing: size.height / (instrument.stringCount() - 1),
      xOffset: size.width / 9,
    );
  }

  Offset position(Note note) => Offset(xPosition(note), yPosition(note));

  double xPosition(Note note) =>
      xOffset + (note.timing.toSixteenthNth() - 1) * sixteenthSpacing;

  double yPosition(Note note) => (note.string - 1) * stringSpacing;
}
