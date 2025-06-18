import 'chord.dart';
import 'timing.dart';

enum Finger { t, m, i }

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
    return length == null
        ? Timing(timing.type, timing.nth + 1)
        : timing + length!;
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
