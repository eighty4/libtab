import 'package:flutter_test/flutter_test.dart';
import 'package:libtab/libtab.dart';

void main() {
  test('Measure.fromNoteList calculates whole note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
    ]);
    expect(measure.notes[0].timing, equals(const Timing(NoteType.whole, 1)));
  });

  test('Measure.fromNoteList calculates half note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
      Note(1, 2),
    ]);
    expect(measure.notes[0].timing, equals(const Timing(NoteType.half, 1)));
    expect(measure.notes[1].timing, equals(const Timing(NoteType.half, 2)));
  });

  test('Measure.fromNoteList calculates quarter note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
    ]);
    expect(measure.notes[0].timing, equals(const Timing(NoteType.quarter, 1)));
    expect(measure.notes[1].timing, equals(const Timing(NoteType.quarter, 2)));
    expect(measure.notes[2].timing, equals(const Timing(NoteType.quarter, 3)));
    expect(measure.notes[3].timing, equals(const Timing(NoteType.quarter, 4)));
  });

  test('Measure.fromNoteList calculates eighth note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
    ]);
    expect(measure.notes[0].timing, equals(const Timing(NoteType.eighth, 1)));
    expect(measure.notes[1].timing, equals(const Timing(NoteType.eighth, 2)));
    expect(measure.notes[2].timing, equals(const Timing(NoteType.eighth, 3)));
    expect(measure.notes[3].timing, equals(const Timing(NoteType.eighth, 4)));
    expect(measure.notes[4].timing, equals(const Timing(NoteType.eighth, 5)));
    expect(measure.notes[5].timing, equals(const Timing(NoteType.eighth, 6)));
    expect(measure.notes[6].timing, equals(const Timing(NoteType.eighth, 7)));
    expect(measure.notes[7].timing, equals(const Timing(NoteType.eighth, 8)));
  });

  test('Measure.fromNoteList calculates sixteenth note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
    ]);
    expect(
        measure.notes[0].timing, equals(const Timing(NoteType.sixteenth, 1)));
    expect(
        measure.notes[1].timing, equals(const Timing(NoteType.sixteenth, 2)));
    expect(
        measure.notes[2].timing, equals(const Timing(NoteType.sixteenth, 3)));
    expect(
        measure.notes[3].timing, equals(const Timing(NoteType.sixteenth, 4)));
    expect(
        measure.notes[4].timing, equals(const Timing(NoteType.sixteenth, 5)));
    expect(
        measure.notes[5].timing, equals(const Timing(NoteType.sixteenth, 6)));
    expect(
        measure.notes[6].timing, equals(const Timing(NoteType.sixteenth, 7)));
    expect(
        measure.notes[7].timing, equals(const Timing(NoteType.sixteenth, 8)));
    expect(
        measure.notes[8].timing, equals(const Timing(NoteType.sixteenth, 9)));
    expect(
        measure.notes[9].timing, equals(const Timing(NoteType.sixteenth, 10)));
    expect(
        measure.notes[10].timing, equals(const Timing(NoteType.sixteenth, 11)));
    expect(
        measure.notes[11].timing, equals(const Timing(NoteType.sixteenth, 12)));
    expect(
        measure.notes[12].timing, equals(const Timing(NoteType.sixteenth, 13)));
    expect(
        measure.notes[13].timing, equals(const Timing(NoteType.sixteenth, 14)));
    expect(
        measure.notes[14].timing, equals(const Timing(NoteType.sixteenth, 15)));
    expect(
        measure.notes[15].timing, equals(const Timing(NoteType.sixteenth, 16)));
  });
}
