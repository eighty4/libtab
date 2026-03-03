# Examples for `libtab`

## Display a single measure

```dart
MeasureChart.singleMeasure(
  instrument: Instrument.banjo,
  measure: Measure.fromNoteList([
    Note(3, 0),
    Note(2, 1),
    Note(1, 3),
    Note(5, 0),
    Note(1, 3),
    Note(2, 1),
    Note(3, 0),
    Note(1, 3),
  ]),
  size: chartSize(context),
  tabContext: TabContext.forBrightness(Brightness.light),
)
```

This example is runnable from the [GitHub repository](./single_measure_chart/lib/main.dart).
