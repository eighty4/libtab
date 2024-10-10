import 'package:flutter_test/flutter_test.dart';
import 'package:libtab/libtab.dart';

void main() {
  test('NoteType.notesPerMeasure', () {
    expect(NoteType.sixteenth.notesPerMeasure(), equals(16));
  });
  test('Timing.toSixteenthNth', () {
    expect(Timing.ofWholeNote(1).toSixteenthNth(), equals(1));
    expect(Timing.ofHalfNote(1).toSixteenthNth(), equals(1));
    expect(Timing.ofHalfNote(2).toSixteenthNth(), equals(9));
    expect(Timing.ofQuarterNote(1).toSixteenthNth(), equals(1));
    expect(Timing.ofQuarterNote(2).toSixteenthNth(), equals(5));
    expect(Timing.ofQuarterNote(3).toSixteenthNth(), equals(9));
    expect(Timing.ofQuarterNote(4).toSixteenthNth(), equals(13));
    expect(Timing.ofEighthNote(1).toSixteenthNth(), equals(1));
    expect(Timing.ofEighthNote(2).toSixteenthNth(), equals(3));
    expect(Timing.ofEighthNote(3).toSixteenthNth(), equals(5));
    expect(Timing.ofEighthNote(4).toSixteenthNth(), equals(7));
    expect(Timing.ofEighthNote(5).toSixteenthNth(), equals(9));
    expect(Timing.ofEighthNote(6).toSixteenthNth(), equals(11));
    expect(Timing.ofEighthNote(7).toSixteenthNth(), equals(13));
    expect(Timing.ofEighthNote(8).toSixteenthNth(), equals(15));
    for (int i = 1; i < 17; i++) {
      expect(Timing.ofSixteenthNote(i).toSixteenthNth(), equals(i));
    }
  });
}
