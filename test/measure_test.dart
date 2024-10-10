import 'package:flutter_test/flutter_test.dart';
import 'package:libtab/libtab.dart';

void main() {
  test('Measure.fromNoteList calculates whole note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
    ]);
    expect(measure.notes[0].timing, equals(Timing.ofWholeNote(1)));
  });

  test('Measure.fromNoteList calculates half note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
      Note(1, 2),
    ]);
    expect(measure.notes[0].timing, equals(Timing.ofHalfNote(1)));
    expect(measure.notes[1].timing, equals(Timing.ofHalfNote(2)));
  });

  test('Measure.fromNoteList calculates quarter note timing', () {
    final measure = Measure.fromNoteList([
      Note(1, 2),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
    ]);
    expect(measure.notes[0].timing, equals(Timing.ofQuarterNote(1)));
    expect(measure.notes[1].timing, equals(Timing.ofQuarterNote(2)));
    expect(measure.notes[2].timing, equals(Timing.ofQuarterNote(3)));
    expect(measure.notes[3].timing, equals(Timing.ofQuarterNote(4)));
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
    expect(measure.notes[0].timing, equals(Timing.ofEighthNote(1)));
    expect(measure.notes[1].timing, equals(Timing.ofEighthNote(2)));
    expect(measure.notes[2].timing, equals(Timing.ofEighthNote(3)));
    expect(measure.notes[3].timing, equals(Timing.ofEighthNote(4)));
    expect(measure.notes[4].timing, equals(Timing.ofEighthNote(5)));
    expect(measure.notes[5].timing, equals(Timing.ofEighthNote(6)));
    expect(measure.notes[6].timing, equals(Timing.ofEighthNote(7)));
    expect(measure.notes[7].timing, equals(Timing.ofEighthNote(8)));
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
    expect(measure.notes[0].timing, equals(Timing.ofSixteenthNote(1)));
    expect(measure.notes[1].timing, equals(Timing.ofSixteenthNote(2)));
    expect(measure.notes[2].timing, equals(Timing.ofSixteenthNote(3)));
    expect(measure.notes[3].timing, equals(Timing.ofSixteenthNote(4)));
    expect(measure.notes[4].timing, equals(Timing.ofSixteenthNote(5)));
    expect(measure.notes[5].timing, equals(Timing.ofSixteenthNote(6)));
    expect(measure.notes[6].timing, equals(Timing.ofSixteenthNote(7)));
    expect(measure.notes[7].timing, equals(Timing.ofSixteenthNote(8)));
    expect(measure.notes[8].timing, equals(Timing.ofSixteenthNote(9)));
    expect(measure.notes[9].timing, equals(Timing.ofSixteenthNote(10)));
    expect(measure.notes[10].timing, equals(Timing.ofSixteenthNote(11)));
    expect(measure.notes[11].timing, equals(Timing.ofSixteenthNote(12)));
    expect(measure.notes[12].timing, equals(Timing.ofSixteenthNote(13)));
    expect(measure.notes[13].timing, equals(Timing.ofSixteenthNote(14)));
    expect(measure.notes[14].timing, equals(Timing.ofSixteenthNote(15)));
    expect(measure.notes[15].timing, equals(Timing.ofSixteenthNote(16)));
  });

  test('Measure.fromNoteList syncs calculated timing with concurrent notes',
      () {
    final measure = Measure.fromNoteList([
      Note(1, 2, and: Note(3, 4, and: Note(5, 6))),
      Note(1, 2),
      Note(3, 4),
      Note(5, 6),
    ]);
    expect(measure.notes[0].timing, equals(Timing.ofQuarterNote(1)));
    expect(measure.notes[0].timing, equals(measure.notes[0].and!.timing));
    expect(measure.notes[0].timing, equals(measure.notes[0].and!.and!.timing));
    expect(measure.notes[1].timing, equals(Timing.ofQuarterNote(2)));
    expect(measure.notes[2].timing, equals(Timing.ofQuarterNote(3)));
    expect(measure.notes[3].timing, equals(Timing.ofQuarterNote(4)));
  });
}
