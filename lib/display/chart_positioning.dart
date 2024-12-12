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

  /// Builds a ChartPositioning for the given size and instrument
  factory ChartPositioning.calculate(Size size, Instrument instrument) {
    return ChartPositioning(
      sixteenthSpacing: size.width / 18,
      stringSpacing: size.height / (instrument.stringCount() - 1),
      xOffset: size.width / 9,
    );
  }

  /// The center of a [Note] placement on a chart
  Offset position(Note note) => Offset(xPosition(note), yPosition(note));

  /// A Note's center's x position on a chart
  double xPosition(Note note) =>
      xOffset + (note.timing.toSixteenthNth() - 1) * sixteenthSpacing;

  /// A Note's center's y position on a chart
  double yPosition(Note note) => (note.string - 1) * stringSpacing;
}
