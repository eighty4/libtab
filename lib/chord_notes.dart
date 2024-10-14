import 'chord.dart';
import 'instrument.dart';
import 'note.dart';

// todo support multiple finger position variations to form a chord
//  examples are B, B7, C7, F7 and G7
// todo support varying finger positions as chords reoccur up the neck

/// ChordNoteSet contains Note data for an Instrument's finger positioning for
/// a Chord. A Chord and Instrument combination without chart data will
/// be rendered by ChordChartDisplay with a user friendly message.
class ChordNoteSet {
  static List<Chord> availableChordCharts(Instrument instrument) =>
      switch (instrument) {
        Instrument.banjo => List.unmodifiable(_banjoChordNotes.keys),
        Instrument.guitar => List.unmodifiable(_guitarChordNotes.keys),
      };

  final Chord chord;
  final int? fretOffset;
  final Instrument instrument;
  final bool noData;
  final Note? notes;

  factory ChordNoteSet(Instrument instrument, Chord chord) {
    if (instrument == Instrument.banjo && chord == Chord.g) {
      return ChordNoteSet._(chord: chord, instrument: instrument);
    } else {
      final notes = switch (instrument) {
        Instrument.banjo => _banjoChordNotes[chord],
        Instrument.guitar => _guitarChordNotes[chord],
      };
      if (notes == null) {
        return ChordNoteSet._unavailable(chord: chord, instrument: instrument);
      } else {
        return ChordNoteSet._(
            chord: chord,
            fretOffset: null,
            instrument: instrument,
            notes: notes);
      }
    }
  }

  ChordNoteSet._(
      {required this.chord,
      this.fretOffset,
      required this.instrument,
      this.notes})
      : noData = false;

  ChordNoteSet._unavailable({required this.chord, required this.instrument})
      : fretOffset = null,
        noData = true,
        notes = null;
}

/// Mapping a chord to the optional fret offset of the chord position and
/// notes that comprise the chord
typedef _ChordNoteMapping = Map<Chord, Note?>;

final _ChordNoteMapping _banjoChordNotes = Map.unmodifiable({
  Chord.a: Note(1, 2, and: Note(2, 2, and: Note(3, 2, and: Note(4, 2)))),
  Chord.am: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 2)))),
  Chord.a7: Note(1, 1, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.amaj7: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.am7: Note(1, 1, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
  Chord.b: Note(1, 4, and: Note(2, 4, and: Note(3, 4, and: Note(4, 4)))),
  // Chord.bm: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 2)))),
  Chord.b7: Note(1, 1, and: Note(3, 2, and: Note(4, 1))),
  // Chord.bmaj7: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  // Chord.bm7: Note(1, 1, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
  Chord.c: Note(1, 2, and: Note(2, 1, and: Note(4, 2))),
  Chord.cm: Note(1, 1, and: Note(2, 1, and: Note(4, 1))),
  // Chord.c7: Note(1, 1, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  // Chord.cmaj7: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  // Chord.cm7: Note(1, 1, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
  Chord.d: Note(1, 4, and: Note(2, 3, and: Note(3, 2))),
  Chord.dm: Note(1, 3, and: Note(2, 3, and: Note(3, 2))),
  Chord.d7: Note(1, 4, and: Note(2, 1, and: Note(3, 2))),
  // Chord.dmaj7: Note(1, 3, and: Note(2, 1, and: Note(3, 1))),
  Chord.dm7: Note(1, 3, and: Note(2, 1, and: Note(3, 2))),
  Chord.e: Note(1, 2, and: Note(3, 1, and: Note(4, 2))),
  Chord.em: Note(1, 2, and: Note(4, 2)),
  Chord.e7: Note(3, 1, and: Note(4, 2)),
  Chord.emaj7: Note(1, 1, and: Note(3, 1, and: Note(4, 2))),
  Chord.em7: Note(4, 2),
  Chord.f: Note(1, 3, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.fm: Note(1, 3, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
  Chord.f7: Note(1, 3, and: Note(2, 1, and: Note(3, 2, and: Note(4, 1)))),
  // Chord.f7: Note(1, 1, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.fmaj7: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.fm7: Note(1, 1, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
  Chord.g: null,
  // Chord.gm: Note(1, 3, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
  Chord.g7: Note(1, 3),
  // Chord.gmaj7: Note(1, 2, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  // Chord.gm7: Note(1, 1, and: Note(2, 1, and: Note(3, 1, and: Note(4, 3)))),
});

final _ChordNoteMapping _guitarChordNotes = Map.unmodifiable({
  Chord.a: Note(2, 2, and: Note(3, 2, and: Note(4, 2))),
  Chord.am: Note(2, 1, and: Note(3, 2, and: Note(4, 2))),
  Chord.a7: Note(2, 2, and: Note(4, 2)),
  Chord.amaj7: Note(2, 2, and: Note(3, 1, and: Note(4, 2))),
  Chord.am7: Note(2, 1, and: Note(4, 2)),
  Chord.b: Note(1, 2,
      and: Note(2, 4, and: Note(3, 4, and: Note(4, 4, and: Note(5, 2))))),
  Chord.bm: Note(1, 2,
      and: Note(2, 3, and: Note(3, 4, and: Note(4, 4, and: Note(5, 2))))),
  Chord.b7: Note(1, 2, and: Note(3, 2, and: Note(4, 1, and: Note(5, 2)))),
  Chord.bmaj7: Note(1, 1,
      and: Note(2, 3, and: Note(3, 2, and: Note(4, 3, and: Note(5, 1))))),
  Chord.bm7: Note(1, 1,
      and: Note(2, 2, and: Note(3, 1, and: Note(4, 3, and: Note(5, 1))))),
  Chord.c: Note(2, 1, and: Note(4, 2, and: Note(5, 3))),
  Chord.cm: Note(1, 1,
      and: Note(2, 2, and: Note(3, 3, and: Note(4, 3, and: Note(5, 1))))),
  Chord.c7: Note(2, 1, and: Note(3, 3, and: Note(4, 2, and: Note(5, 3)))),
  Chord.cmaj7: Note(4, 2, and: Note(5, 3)),
  Chord.cm7: Note(1, 1,
      and: Note(2, 2, and: Note(3, 1, and: Note(4, 3, and: Note(5, 1))))),
  Chord.d: Note(1, 2, and: Note(2, 3, and: Note(3, 2))),
  Chord.dm: Note(1, 1, and: Note(2, 3, and: Note(3, 2))),
  Chord.d7: Note(1, 2, and: Note(2, 1, and: Note(3, 2))),
  Chord.dmaj7: Note(1, 2, and: Note(2, 2, and: Note(3, 2))),
  Chord.dm7: Note(1, 1, and: Note(2, 1, and: Note(3, 2))),
  Chord.e: Note(3, 1, and: Note(4, 2, and: Note(5, 2))),
  Chord.em: Note(4, 2, and: Note(5, 2)),
  Chord.e7: Note(3, 1, and: Note(5, 2)),
  Chord.emaj7: Note(3, 1, and: Note(4, 1, and: Note(5, 2))),
  Chord.em7: Note(5, 2),
  Chord.f: Note(1, 1, and: Note(2, 1, and: Note(3, 2, and: Note(4, 3)))),
  Chord.fm: Note(1, 1,
      and: Note(2, 1,
          and: Note(3, 1, and: Note(4, 3, and: Note(5, 3, and: Note(6, 1)))))),
  Chord.f7: Note(1, 1,
      and: Note(2, 1,
          and: Note(3, 2, and: Note(4, 1, and: Note(5, 3, and: Note(6, 1)))))),
  Chord.fmaj7: Note(2, 1, and: Note(3, 2, and: Note(4, 3))),
  Chord.fm7: Note(1, 1,
      and: Note(2, 1,
          and: Note(3, 1, and: Note(4, 1, and: Note(5, 3, and: Note(6, 1)))))),
  Chord.g: Note(1, 3, and: Note(5, 2, and: Note(6, 3))),
  Chord.gm: Note(1, 1,
      and: Note(2, 1,
          and: Note(3, 1, and: Note(4, 3, and: Note(5, 3, and: Note(6, 1)))))),
  Chord.g7: Note(1, 1, and: Note(5, 2, and: Note(6, 3))),
  Chord.gmaj7: Note(1, 2, and: Note(2, 3, and: Note(3, 4, and: Note(4, 5)))),
  Chord.gm7: Note(1, 1,
      and: Note(2, 1,
          and: Note(3, 1, and: Note(4, 1, and: Note(5, 3, and: Note(6, 1)))))),
});
