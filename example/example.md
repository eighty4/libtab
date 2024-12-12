# Libtab musical charts

## Display a measure of notes

```dart
MeasureDisplay(
    Measure.fromNoteList([
        Note(2, 0),
        Note(1, 0),
        Note(5, 0),
        Note(2, 0),
        Note(1, 0),
        Note(5, 0),
        Note(2, 0),
        Note(1, 0),
    ]),
    tabContext: TabContext.forBrightness(Brightness.light),
    instrument: Instrument.guitar,
);
```

## Display a chord chart

```dart
ChordChartDisplay(
    chord: ChordNoteSet(Instrument.guitar, Chord.em),
    tabContext: TabContext.forBrightness(Brightness.light),
);
```
