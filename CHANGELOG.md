# Changelog

## Unreleased - ReleaseDate

## 0.0.11 - 2024-12-17

* Extended chord data for ChordChartDisplay
* ChordNoteSet shows an unsupported state instead of throwing an error for a chord and instrument
  combo that is unsupported and ChordChartDisplay will build a user friendly message
* Added Chord.a.label() and Instrument.banjo.label() methods to Chord and Instrument for user facing
  labels of Chord and Instrument values
* BREAKING CHANGE by moving exported banjoChords and guitarChords data to
  ChordNoteSet.availableChordCharts
* BREAKING CHANGE by renaming StringsFn to InstrumentStringCountFn

## 0.0.10 - 2024-10-11

* Removed a Center widget around contents of ChordChartDisplay
* BUGFIX for whole, quarter and half note calculations by NotePositioning
* BREAKING CHANGE by upgrading to Dart 3
* BREAKING CHANGE by removing excessive delegate methods for positioning calculations
* BREAKING CHANGE by private scoping chord finger position data in libtab/note.dart
* BREAKING CHANGE by removing const from Timing constructor

## 0.0.9 - 2024-10-09

* ChordChartDisplay and MeasureDisplay repaints when painter params update

## 0.0.8 - 2024-07-17

* MeasureDisplay without notes skips NotePositioning and renders chart without any notes
* Note equality overrides

## 0.0.7 - 2024-05-10

* ChordChartDisplay's shadows around notes are scaled proportional to their radius

## 0.0.6 - 2024-05-03

* MeasureDisplay's shadows around notes are scaled proportional to their radius 

## 0.0.5 - 2024-05-02

* MeasureDisplay dynamically sizes notation paints relative to canvas size
* LibContext constructs Paint instances for reuse

## 0.0.4 - 2024-03-28

* Bug fix for Measure.fromNoteList not updating concurrently played Note.and notes with calculated
  timing

## 0.0.3 - 2024-07-14

* MeasureDisplay no longer grows unconstrained to available space of parent

## 0.0.2 - 2023-07-03

* Added banjo and guitar major chords

## 0.0.1 2023-03-03

* Model types and widgets for modeling musical chords and measures

[Unreleased]: https://github.com/eighty4/libtab/compare/v0.0.11...HEAD
[0.0.11]: https://github.com/eighty4/libtab/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/eighty4/libtab/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/eighty4/libtab/compare/v0.0.8...v0.0.9
[0.0.8]: https://github.com/eighty4/libtab/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/eighty4/libtab/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/eighty4/libtab/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/eighty4/libtab/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/eighty4/libtab/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/eighty4/libtab/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/eighty4/libtab/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/eighty4/libtab/releases/tag/v0.0.1
