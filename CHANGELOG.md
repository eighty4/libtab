## 0.0.11

* Extended chord data for ChordChartDisplay
* ChordNoteSet shows an unsupported state instead of throwing an error for a chord and instrument
  combo that is unsupported and ChordChartDisplay will build a user friendly message
* Added Chord.a.label() and Instrument.banjo.label() methods to Chord and Instrument for user facing
  labels of Chord and Instrument values
* BREAKING CHANGE by moving exported banjoChords and guitarChords data to
  ChordNoteSet.availableChordCharts
* BREAKING CHANGE by renaming StringsFn to InstrumentStringCountFn

## 0.0.10

* Removed a Center widget around contents of ChordChartDisplay
* BUGFIX for whole, quarter and half note calculations by NotePositioning
* BREAKING CHANGE by upgrading to Dart 3
* BREAKING CHANGE by removing excessive delegate methods for positioning calculations
* BREAKING CHANGE by private scoping chord finger position data in libtab/note.dart
* BREAKING CHANGE by removing const from Timing constructor

## 0.0.9

* ChordChartDisplay and MeasureDisplay repaints when painter params update

## 0.0.8

* MeasureDisplay without notes skips NotePositioning and renders chart without any notes
* Note equality overrides

## 0.0.7

* ChordChartDisplay's shadows around notes are scaled proportional to their radius

## 0.0.6

* MeasureDisplay's shadows around notes are scaled proportional to their radius 

## 0.0.5

* MeasureDisplay dynamically sizes notation paints relative to canvas size
* LibContext constructs Paint instances for reuse

## 0.0.4

* Bug fix for Measure.fromNoteList not updating concurrently played Note.and notes with calculated
  timing

## 0.0.3

* MeasureDisplay no longer grows unconstrained to available space of parent

## 0.0.2

* Added banjo and guitar major chords

## 0.0.1

* Model types and widgets for modeling musical chords and measures
