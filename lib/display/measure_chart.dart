import 'package:flutter/widgets.dart';
import 'package:libtab/context.dart';
import 'package:libtab/display/chart_positioning.dart';
import 'package:libtab/display/measure_paint.dart';
import 'package:libtab/display/note_positioning.dart';
import 'package:libtab/instrument.dart';
import 'package:libtab/measure.dart';
import 'package:libtab/metronome.dart';

class MeasureChart extends StatelessWidget {
  static const defaultSize = Size(300, 200);

  final Instrument instrument;
  final Measure? measure;
  final Metronome? metronome;
  final bool showFinalBarOrRepeatEnd;
  final bool showRepeatStart;
  final Size size;
  final TabContext tabContext;

  const MeasureChart.empty({
    super.key,
    this.size = defaultSize,
    required this.tabContext,
    required this.instrument,
    this.showFinalBarOrRepeatEnd = false,
    this.showRepeatStart = false,
  }) : measure = null,
       metronome = null;

  const MeasureChart.singleMeasure({
    super.key,
    this.size = defaultSize,
    required this.tabContext,
    required this.instrument,
    required this.measure,
    this.showFinalBarOrRepeatEnd = false,
    this.showRepeatStart = false,
  }) : metronome = null;

  const MeasureChart.withMetronome({
    super.key,
    this.size = defaultSize,
    required this.tabContext,
    required this.instrument,
    this.metronome,
    bool showFinalBarOnLastMeasure = false,
  }) : measure = null,
       showFinalBarOrRepeatEnd = showFinalBarOnLastMeasure,
       showRepeatStart = false;

  @override
  Widget build(BuildContext context) {
    return switch ((measure, metronome)) {
      (null, Metronome metronome) => _DynamicMeasureChart(
        instrument: instrument,
        metronome: metronome,
        showFinalBarOnLastMeasure: showFinalBarOrRepeatEnd,
        size: size,
        tabContext: tabContext,
      ),
      (Measure measure, null) => _StaticMeasureChart(
        instrument: instrument,
        showFinalBar: showFinalBarOrRepeatEnd,
        measure: measure,
        size: size,
        tabContext: tabContext,
      ),
      (null, null) => _EmptyMeasureChart(
        instrument: instrument,
        showFinalBar: showFinalBarOrRepeatEnd,
        size: size,
        tabContext: tabContext,
      ),
      (_, _) => throw StateError('invalid MeasureChart state'),
    };
  }
}

class _DynamicMeasureChart extends StatefulWidget {
  final Instrument instrument;
  final Metronome metronome;
  final bool showFinalBarOnLastMeasure;
  final Size size;
  final TabContext tabContext;

  const _DynamicMeasureChart({
    required this.instrument,
    required this.metronome,
    required this.showFinalBarOnLastMeasure,
    required this.size,
    required this.tabContext,
  });

  @override
  State<_DynamicMeasureChart> createState() => _DynamicMeasureChartState();
}

class _DynamicMeasureChartState extends State<_DynamicMeasureChart> {
  late bool showFinalBar;
  late Measure measure;
  late MetronomeListener _onMeasureChange;

  @override
  void initState() {
    super.initState();
    updateMaterial();
    _onMeasureChange = widget.metronome.onMeasure(
      (_) => setState(() => updateMaterial()),
    );
  }

  @override
  void dispose() {
    _onMeasureChange.remove();
    super.dispose();
  }

  @override
  void didUpdateWidget(_DynamicMeasureChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.metronome, oldWidget.metronome)) {
      setState(() => updateMaterial());
    }
  }

  void updateMaterial() {
    showFinalBar =
        widget.showFinalBarOnLastMeasure && widget.metronome.isLastMeasure();
    measure = widget.metronome.currentMeasure;
  }

  @override
  Widget build(BuildContext context) {
    return _CalculatedNotePositioning(
      instrument: widget.instrument,
      measure: measure,
      size: widget.size,
      builder: (context, chartPositioning, notePositioning) {
        return Stack(
          children: [
            CustomPaint(
              size: widget.size,
              painter: MeasureChartPainter.forMeasure(
                tabContext: widget.tabContext,
                instrument: widget.instrument,
                measure: measure,
                last: showFinalBar,
                chartPositioning: chartPositioning,
              ),
            ),
            if (measure.notes.isNotEmpty)
              CustomPaint(
                size: widget.size,
                painter: MeasureNotePainter(
                  tabContext: widget.tabContext,
                  measure: measure,
                  chartPositioning: chartPositioning,
                  notePositioning: notePositioning,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StaticMeasureChart extends StatelessWidget {
  final Instrument instrument;
  final Measure measure;
  final bool showFinalBar;
  final Size size;
  final TabContext tabContext;

  const _StaticMeasureChart({
    required this.instrument,
    required this.measure,
    required this.showFinalBar,
    required this.size,
    required this.tabContext,
  });

  @override
  Widget build(BuildContext context) {
    return _CalculatedNotePositioning(
      instrument: instrument,
      measure: measure,
      size: size,
      builder: (context, chartPositioning, notePositioning) {
        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: MeasureChartPainter(
                tabContext: tabContext,
                instrument: instrument,
                showFinalBarOrRepeatEnd: showFinalBar || measure.repeatEnd,
                showRepeatStart: measure.repeatStart,
                chartPositioning: chartPositioning,
              ),
            ),
            if (measure.notes.isNotEmpty)
              CustomPaint(
                size: size,
                painter: MeasureNotePainter(
                  tabContext: tabContext,
                  measure: measure,
                  chartPositioning: chartPositioning,
                  notePositioning: notePositioning,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyMeasureChart extends StatelessWidget {
  final Instrument instrument;
  final bool showFinalBar;
  final Size size;
  final TabContext tabContext;

  const _EmptyMeasureChart({
    required this.instrument,
    required this.showFinalBar,
    required this.size,
    required this.tabContext,
  });

  @override
  Widget build(BuildContext context) {
    return _CalculatedChartPositioning(
      instrument: instrument,
      size: size,
      builder: (context, chartPositioning) {
        return CustomPaint(
          size: size,
          painter: MeasureChartPainter(
            chartPositioning: chartPositioning,
            instrument: instrument,
            showFinalBarOrRepeatEnd: showFinalBar,
            tabContext: tabContext,
          ),
        );
      },
    );
  }
}

class _CalculatedChartPositioning extends StatefulWidget {
  final Widget Function(BuildContext context, ChartPositioning chartPositioning)
  builder;
  final Instrument instrument;
  final Size size;

  const _CalculatedChartPositioning({
    required this.builder,
    required this.instrument,
    required this.size,
  });

  @override
  State<_CalculatedChartPositioning> createState() =>
      _CalculatedChartPositioningState();
}

class _CalculatedChartPositioningState
    extends State<_CalculatedChartPositioning> {
  late ChartPositioning chartPositioning;

  @override
  void initState() {
    super.initState();
    updateChartPositioning();
  }

  @override
  void didUpdateWidget(_CalculatedChartPositioning oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instrument != oldWidget.instrument ||
        widget.size != oldWidget.size) {
      setState(() => updateChartPositioning());
    }
  }

  void updateChartPositioning() {
    chartPositioning = ChartPositioning.calculate(
      widget.size,
      widget.instrument,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, chartPositioning);
  }
}

class _CalculatedNotePositioning extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    ChartPositioning chartPositioning,
    NotePositioning notePositioning,
  )
  builder;
  final Instrument instrument;
  final Measure measure;
  final Size size;

  const _CalculatedNotePositioning({
    required this.builder,
    required this.instrument,
    required this.measure,
    required this.size,
  });

  @override
  State<_CalculatedNotePositioning> createState() =>
      _CalculatedNotePositioningState();
}

class _CalculatedNotePositioningState
    extends State<_CalculatedNotePositioning> {
  late ChartPositioning chartPositioning;
  late NotePositioning notePositioning;

  @override
  void initState() {
    super.initState();
    updateChartPositioning();
  }

  @override
  void didUpdateWidget(_CalculatedNotePositioning oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instrument != oldWidget.instrument ||
        widget.size != oldWidget.size) {
      setState(() => updateChartPositioning());
    } else if (!identical(widget.measure, oldWidget.measure)) {
      setState(() => updateNotePositioning());
    }
  }

  void updateChartPositioning() {
    chartPositioning = ChartPositioning.calculate(
      widget.size,
      widget.instrument,
    );
    updateNotePositioning();
  }

  void updateNotePositioning() {
    notePositioning = NotePositioning.calculate(
      widget.measure.notes,
      chartPositioning,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, chartPositioning, notePositioning);
  }
}
