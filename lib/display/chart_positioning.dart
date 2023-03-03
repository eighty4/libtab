import 'dart:ui';
import 'package:libtab/libtab.dart';

/// Container and calculator of [Canvas] spacing values for strings and notes
class ChartPositioning {
  final double sixteenthSpacing;
  final double eighthSpacing;
  final double quarterSpacing;
  final double halfSpacing;
  final double stringSpacing;

  ChartPositioning(
      {required this.sixteenthSpacing,
      required this.eighthSpacing,
      required this.quarterSpacing,
      required this.halfSpacing,
      required this.stringSpacing});

  factory ChartPositioning.calculate(Size size, Instrument instrument) {
    final eighthSpacing = size.width / 9;
    final quarterSpacing = eighthSpacing * 2;
    final stringSpacing = size.height / (instrument.stringCount() - 1);
    return ChartPositioning(
      sixteenthSpacing: eighthSpacing / 2,
      eighthSpacing: eighthSpacing,
      quarterSpacing: quarterSpacing,
      halfSpacing: quarterSpacing * 2,
      stringSpacing: stringSpacing,
    );
  }

  Offset position(Note note) => Offset(xPosition(note), yPosition(note));

  double xPosition(Note note) =>
      note.timing.nth * noteSpacing(note.timing.type);

  double yPosition(Note note) => (note.string - 1) * stringSpacing;

  double noteSpacing(NoteType noteType) {
    switch (noteType) {
      case NoteType.whole:
        return 1;
      case NoteType.half:
        return halfSpacing;
      case NoteType.quarter:
        return quarterSpacing;
      case NoteType.eighth:
        return eighthSpacing;
      case NoteType.sixteenth:
        return sixteenthSpacing;
    }
  }
}
