import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:libtab/display/note_positioning.dart';
import 'package:libtab/libtab.dart';

expectNotePositioning(
  NotePositioning notePositioning, {
  required int sixteenthNth,
  double? x,
  double? y,
}) {
  assert(x != null || y != null);
  final notesAtNth = notePositioning.notes[sixteenthNth];
  expect(notesAtNth, isNotNull);
  expect(notesAtNth!.length, equals(1));
  final offset = notesAtNth[0].offset;
  if (x != null) {
    expect(offset.dx, equals(x));
  }
  if (y != null) {
    expect(offset.dy, equals(y));
  }
}

void main() {
  test('Positions whole note on x-axis', () {
    final notes = [Note(2, 0, timing: Timing.ofWholeNote(1))];
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(
      size,
      Instrument.guitar,
    );
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(1));
    expectNotePositioning(notePositioning, sixteenthNth: 1, x: 30);
  });
  test('Positions half notes on x-axis', () {
    final notes = [
      Note(2, 0, timing: Timing.ofHalfNote(1)),
      Note(2, 0, timing: Timing.ofHalfNote(2)),
    ];
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(
      size,
      Instrument.guitar,
    );
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(2));
    expectNotePositioning(notePositioning, sixteenthNth: 1, x: 30);
    expectNotePositioning(notePositioning, sixteenthNth: 9, x: 150);
  });
  test('Positions quarter notes on x-axis', () {
    final notes = [
      Note(2, 0, timing: Timing.ofQuarterNote(1)),
      Note(2, 0, timing: Timing.ofQuarterNote(2)),
      Note(2, 0, timing: Timing.ofQuarterNote(3)),
      Note(2, 0, timing: Timing.ofQuarterNote(4)),
    ];
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(
      size,
      Instrument.guitar,
    );
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(4));
    expectNotePositioning(notePositioning, sixteenthNth: 1, x: 30);
    expectNotePositioning(notePositioning, sixteenthNth: 5, x: 90);
    expectNotePositioning(notePositioning, sixteenthNth: 9, x: 150);
    expectNotePositioning(notePositioning, sixteenthNth: 13, x: 210);
  });
  test('Positions eighth notes on x-axis', () {
    final notes = List.generate(
      8,
      (i) => Note(2, 0, timing: Timing.ofEighthNote(i + 1)),
    );
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(
      size,
      Instrument.guitar,
    );
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(8));
    expectNotePositioning(notePositioning, sixteenthNth: 1, x: 30);
    expectNotePositioning(notePositioning, sixteenthNth: 3, x: 60);
    expectNotePositioning(notePositioning, sixteenthNth: 5, x: 90);
    expectNotePositioning(notePositioning, sixteenthNth: 7, x: 120);
    expectNotePositioning(notePositioning, sixteenthNth: 9, x: 150);
    expectNotePositioning(notePositioning, sixteenthNth: 11, x: 180);
    expectNotePositioning(notePositioning, sixteenthNth: 13, x: 210);
    expectNotePositioning(notePositioning, sixteenthNth: 15, x: 240);
  });
  test('Positions sixteenth notes on x-axis', () {
    final notes = List.generate(
      16,
      (i) => Note(2, 0, timing: Timing.ofSixteenthNote(i + 1)),
    );
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(
      size,
      Instrument.guitar,
    );
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(16));
    for (int i = 1; i < 17; i++) {
      expectNotePositioning(
        notePositioning,
        sixteenthNth: i,
        x: 30 + ((i - 1) * 15),
      );
    }
  });
  test('Positions banjo notes on y-axis', () {
    final notes = [
      Note(1, 0, timing: Timing.ofSixteenthNote(1)),
      Note(2, 0, timing: Timing.ofSixteenthNote(2)),
      Note(3, 0, timing: Timing.ofSixteenthNote(3)),
      Note(4, 0, timing: Timing.ofSixteenthNote(4)),
      Note(5, 0, timing: Timing.ofSixteenthNote(5)),
    ];
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(size, Instrument.banjo);
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(5));
    expectNotePositioning(notePositioning, sixteenthNth: 1, y: 0);
    expectNotePositioning(notePositioning, sixteenthNth: 2, y: 37.5);
    expectNotePositioning(notePositioning, sixteenthNth: 3, y: 75);
    expectNotePositioning(notePositioning, sixteenthNth: 4, y: 112.5);
    expectNotePositioning(notePositioning, sixteenthNth: 5, y: 150);
  });
  test('Positions guitar notes on y-axis', () {
    final notes = [
      Note(1, 0, timing: Timing.ofSixteenthNote(1)),
      Note(2, 0, timing: Timing.ofSixteenthNote(2)),
      Note(3, 0, timing: Timing.ofSixteenthNote(3)),
      Note(4, 0, timing: Timing.ofSixteenthNote(4)),
      Note(5, 0, timing: Timing.ofSixteenthNote(5)),
      Note(6, 0, timing: Timing.ofSixteenthNote(6)),
    ];
    const size = Size(270, 150);
    final chartPositioning = ChartPositioning.calculate(
      size,
      Instrument.guitar,
    );
    final notePositioning = NotePositioning.calculate(notes, chartPositioning);
    expect(notePositioning.notes.length, equals(6));
    expectNotePositioning(notePositioning, sixteenthNth: 1, y: 0);
    expectNotePositioning(notePositioning, sixteenthNth: 2, y: 30);
    expectNotePositioning(notePositioning, sixteenthNth: 3, y: 60);
    expectNotePositioning(notePositioning, sixteenthNth: 4, y: 90);
    expectNotePositioning(notePositioning, sixteenthNth: 5, y: 120);
    expectNotePositioning(notePositioning, sixteenthNth: 6, y: 150);
  });
}
