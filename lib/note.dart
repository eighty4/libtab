import 'chord.dart';
import 'instrument.dart';

enum Finger { t, m, i }

enum NoteType { whole, half, quarter, eighth, sixteenth }

extension NotesPerMeasureFn on NoteType {
  /// How many notes this note type is played in a measure
  int notesPerMeasure() {
    switch (this) {
      case NoteType.whole:
        return 1;
      case NoteType.half:
        return 2;
      case NoteType.quarter:
        return 4;
      case NoteType.eighth:
        return 8;
      case NoteType.sixteenth:
        return 16;
    }
  }

  /// How many sixteenth notes a beat lasts for this note type
  int toSixteenthNotesPerBeat() {
    return (16 / notesPerMeasure()).round();
  }
}

class Timing {
  static const Timing unspecified = Timing(NoteType.eighth, -1);

  /// Type of note
  final NoteType type;

  /// 1-indexed placement in measure
  final int nth;

  const Timing(this.type, this.nth);

  /// Create a [Timing] for a [Note] using [Timing.unspecified] based on the
  /// index of the [Note] in a [List]
  factory Timing.withinNoteList(
      {required int listLength, required int noteIndex}) {
    return Timing(notesPerMeasureToNoteType(listLength), noteIndex + 1);
  }

  /// Resolves [NoteType] based on the number of [Note]s in a measure
  static NoteType notesPerMeasureToNoteType(int noteCount) {
    switch (noteCount) {
      case 16:
        return NoteType.sixteenth;
      case 8:
        return NoteType.eighth;
      case 4:
        return NoteType.quarter;
      case 2:
        return NoteType.half;
      case 1:
        return NoteType.whole;
      default:
        if (noteCount < 8) {
          return NoteType.eighth;
        } else {
          return NoteType.sixteenth;
        }
    }
  }

  Timing operator +(Timing timing) => add(timing);

  Timing add(Timing timing) {
    if (type == timing.type) {
      return Timing(type, nth + timing.nth);
    } else {
      final sixteenthNth = toSixteenthNth() + timing.toSixteenthNth();
      assert(sixteenthNth < 17);
      return Timing(NoteType.sixteenth, sixteenthNth);
    }
  }

  /// Resolves the [Timing.nth] value as a [NoteType.sixteenth] note
  int toSixteenthNth() {
    return nth == 1 ? 1 : type.toSixteenthNotesPerBeat() * nth - 1;
  }

  @override
  String toString() {
    return 'Timing{type: $type, nth: $nth}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timing &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          nth == other.nth;

  @override
  int get hashCode => type.hashCode ^ nth.hashCode;
}

class Note {
  /// 1-indexed string
  final int string;

  /// 1-indexed fret
  final int fret;

  /// Whether melody note
  final bool melody;

  /// Time to play note
  final Timing timing;

  /// Length of note
  final Timing? length;

  /// Chord composed by notes
  final Chord? chord;

  /// Hammer on fret
  final int? hammerOn;

  /// Pull off fret
  final int? pullOff;

  /// Slide to fret
  final int? slideTo;

  /// Which finger plays note
  final Finger? pick;

  /// Additional notes played in tandem
  final Note? and;

  Note(this.string, this.fret,
      {this.melody = false,
      this.timing = Timing.unspecified,
      this.length,
      this.chord,
      this.hammerOn,
      this.pullOff,
      this.slideTo,
      this.pick,
      this.and}) {
    assert(hammerOn == null || fret < hammerOn!);
    assert(pullOff == null || fret > pullOff!);
    assert(slideTo == null || fret < slideTo!);
  }

  Note copyWithTiming(Timing timing) {
    assert(timing.nth > 0);
    return Note(
      string,
      fret,
      timing: timing,
      length: length,
      pick: pick,
      chord: chord,
      melody: melody,
      slideTo: slideTo,
      hammerOn: hammerOn,
      pullOff: pullOff,
      and: and,
    );
  }

  Timing sustainReleaseTiming() {
    return timing + (length ?? Timing(timing.type, timing.nth + 1));
  }
}

class ChordNoteSet {
  final Instrument instrument;
  final Chord chord;
  final Note? notes;

  factory ChordNoteSet(Instrument instrument, Chord chord) {
    late final Note? note;
    switch (instrument) {
      case Instrument.banjo:
        if (chord == Chord.g) {
          return ChordNoteSet.banjo(chord, null);
        } else {
          note = banjoChordNotes[chord];
          assert(note != null);
          return ChordNoteSet.banjo(chord, note);
        }
      case Instrument.guitar:
        note = guitarChordNotes[chord];
        assert(note != null);
        return ChordNoteSet.guitar(chord, note);
    }
  }

  ChordNoteSet.banjo(this.chord, this.notes) : instrument = Instrument.banjo;

  ChordNoteSet.guitar(this.chord, this.notes) : instrument = Instrument.guitar;
}

final Map<Chord, Note?> banjoChordNotes = Map.unmodifiable({
  Chord.a: Note(1, 2, and: Note(2, 2, and: Note(3, 2, and: Note(4, 2)))),
  Chord.b: Note(1, 4, and: Note(2, 4, and: Note(3, 4, and: Note(4, 4)))),
  Chord.c: Note(1, 2, and: Note(2, 1, and: Note(4, 2))),
  Chord.d: Note(1, 4, and: Note(2, 3, and: Note(3, 2))),
  Chord.e: Note(1, 2, and: Note(3, 1, and: Note(4, 2))),
  Chord.f: Note(1, 3, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.g: null,
});

final banjoChords = List.unmodifiable(banjoChordNotes.keys);

final Map<Chord, Note> guitarChordNotes = Map.unmodifiable({
  Chord.a: Note(2, 2, and: Note(2, 3, and: Note(2, 4))),
  Chord.am: Note(2, 1, and: Note(3, 2, and: Note(4, 2))),
  Chord.b: Note(1, 2, and: Note(2, 4, and: Note(3, 4, and: Note(4, 4)))),
  Chord.c: Note(1, 2, and: Note(2, 4, and: Note(3, 5))),
  Chord.d: Note(1, 2, and: Note(2, 3, and: Note(3, 2))),
  Chord.em: Note(4, 2, and: Note(5, 2)),
  Chord.e: Note(3, 1, and: Note(4, 2, and: Note(5, 2))),
  Chord.f: Note(1, 1, and: Note(1, 2, and: Note(2, 3, and: Note(3, 4)))),
  Chord.g: Note(1, 3, and: Note(5, 2, and: Note(6, 3))),
});

final guitarChords = List.unmodifiable(guitarChordNotes.keys);
