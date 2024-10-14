import 'chord.dart';

enum Finger { t, m, i }

enum NoteType { whole, half, quarter, eighth, sixteenth }

extension NotesPerMeasureFn on NoteType {
  /// How many notes this note type occurs in a measure
  int notesPerMeasure() => switch (this) {
        NoteType.whole => 1,
        NoteType.half => 2,
        NoteType.quarter => 4,
        NoteType.eighth => 8,
        NoteType.sixteenth => 16
      };
}

class Timing {
  static const Timing unspecified = Timing._(NoteType.eighth, -1);

  /// Type of note
  final NoteType type;

  /// 1-indexed placement in measure
  final int nth;

  Timing(this.type, this.nth) {
    assert(nth > 0);
    assert(nth <= type.notesPerMeasure());
  }

  Timing.ofWholeNote(int nth) : this(NoteType.whole, nth);

  Timing.ofHalfNote(int nth) : this(NoteType.half, nth);

  Timing.ofQuarterNote(int nth) : this(NoteType.quarter, nth);

  Timing.ofEighthNote(int nth) : this(NoteType.eighth, nth);

  Timing.ofSixteenthNote(int nth) : this(NoteType.sixteenth, nth);

  const Timing._(this.type, this.nth);

  /// Create a [Timing] for a [Note] using [Timing.unspecified] based on the
  /// index of the [Note] in a [List]
  factory Timing.withinNoteList(
      {required int listLength, required int noteIndex}) {
    assert(noteIndex > -1 && noteIndex < listLength);
    return Timing(notesPerMeasureToNoteType(listLength), noteIndex + 1);
  }

  /// Resolves [NoteType] based on the number of [Note]s in a measure
  static NoteType notesPerMeasureToNoteType(int noteCount) {
    assert(noteCount <= 16);
    return switch (noteCount) {
      16 => NoteType.sixteenth,
      8 => NoteType.eighth,
      4 => NoteType.quarter,
      2 => NoteType.half,
      1 => NoteType.whole,
      _ => noteCount < 8 ? NoteType.eighth : NoteType.sixteenth
    };
  }

  Timing operator +(Timing timing) => add(timing);

  Timing add(Timing timing) {
    if (type == timing.type) {
      return Timing(type, nth + timing.nth);
    } else {
      final sixteenthNth = toSixteenthNth() + timing.toSixteenthNth();
      assert(sixteenthNth < 17);
      return Timing.ofSixteenthNote(sixteenthNth);
    }
  }

  /// Resolves the [Timing.nth] value as a [NoteType.sixteenth] note
  int toSixteenthNth() {
    if (nth == 1) {
      return 1;
    } else {
      return (16 ~/ type.notesPerMeasure()) * (nth - 1) + 1;
    }
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
      and: and?.copyWithTiming(timing),
    );
  }

  Timing sustainReleaseTiming() {
    return timing + (length ?? Timing(timing.type, timing.nth + 1));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          string == other.string &&
          timing == other.timing;

  @override
  int get hashCode => string.hashCode ^ timing.hashCode;
}
