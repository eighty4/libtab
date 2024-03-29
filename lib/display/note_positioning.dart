import 'dart:ui';

import 'package:libtab/libtab.dart';

/// Map of 16th note timings (1-16) to list of [NotePosition]s to be positioned
/// at the same y position
typedef NotePositionMap = Map<int, List<NotePosition>>;

extension on NotePositionMap {
  /// Adds [NotePosition]s for a [Note], recursively calling with sixteenthNote
  /// param for [Note.and]
  Offset addNotePosition(ChartPositioning chartPositioning, Note note,
      {int? sixteenthNth}) {
    if (sixteenthNth == null) {
      sixteenthNth = note.timing.toSixteenthNth();
      if (this[sixteenthNth] == null) {
        this[sixteenthNth] = [];
      }
    }
    final offset = chartPositioning.position(note);
    this[sixteenthNth]!.add(NotePosition(note, offset));
    if (note.and != null) {
      addNotePosition(chartPositioning, note.and!, sixteenthNth: sixteenthNth);
    }
    return offset;
  }
}

/// List of [TechniquePosition] containers of [Offset]s specifying the [Note]
/// positions a [Technique] would be played
typedef TechniquePositionList = List<TechniquePosition>;

/// Adds a [TechniquePosition] and a [NotePosition] to [NotePositionMap] for the
/// additional note played by the [Technique]
extension on TechniquePositionList {
  void addTechniquePosition(
      NotePositionMap notePositions,
      ChartPositioning chartPositioning,
      Note note,
      Offset offset,
      Technique technique,
      int fret) {
    final techniqueOffset = notePositions.addNotePosition(chartPositioning,
        Note(note.string, fret, timing: note.sustainReleaseTiming()));
    add(TechniquePosition(technique, offset,
        offset.translate(techniqueOffset.dx - offset.dx, 0)));
  }
}

/// Container and calculator for [NotePositionMap]
class NotePositioning {
  final NotePositionMap notes;
  final TechniquePositionList techniques;

  NotePositioning(this.notes, this.techniques) : assert(notes.isNotEmpty);

  /// Calculates [NotePositionMap] and [TechniquePositionList]
  factory NotePositioning.calculate(
      List<Note> notes, ChartPositioning chartPositioning) {
    final NotePositionMap notePositions = {};
    final TechniquePositionList techniquePositions = [];

    for (var note in notes) {
      final offset = notePositions.addNotePosition(chartPositioning, note);
      if (note.hammerOn != null) {
        techniquePositions.addTechniquePosition(notePositions, chartPositioning,
            note, offset, Technique.hammerOn, note.hammerOn!);
      }
      if (note.pullOff != null) {
        techniquePositions.addTechniquePosition(notePositions, chartPositioning,
            note, offset, Technique.pullOff, note.pullOff!);
      }
      if (note.slideTo != null) {
        techniquePositions.addTechniquePosition(notePositions, chartPositioning,
            note, offset, Technique.slide, note.slideTo!);
      }
    }

    return NotePositioning(notePositions, techniquePositions);
  }
}

/// Pair of [Note] data with the [Offset] paint position
class NotePosition {
  final Note note;
  final Offset offset;

  NotePosition(this.note, this.offset);
}

/// Calculated [Offset]s for positioning a [Technique]
class TechniquePosition {
  final Technique technique;
  final Offset from;
  final Offset to;

  TechniquePosition(this.technique, this.from, this.to)
      : assert(from.dy == to.dy, '${from.dy} != ${to.dy}');
}
