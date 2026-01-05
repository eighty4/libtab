import 'package:flutter/widgets.dart';
import 'package:libtab/context.dart';
import 'package:libtab/display/chart_positioning.dart';
import 'package:libtab/display/measure_paint.dart';
import 'package:libtab/display/note_positioning.dart';
import 'package:libtab/instrument.dart';
import 'package:libtab/measure.dart';

class MeasureChart extends StatelessWidget {
  static const defaultSize = Size(300, 200);

  final Instrument instrument;
  final bool last;
  final Measure? measure;
  final Size size;
  final TabContext tabContext;

  const MeasureChart.empty({
    super.key,
    this.size = defaultSize,
    required this.tabContext,
    required this.instrument,
    this.last = false,
  }) : measure = null;

  const MeasureChart.singleMeasure({
    super.key,
    this.size = defaultSize,
    required this.tabContext,
    required this.instrument,
    required this.measure,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (measure) {
      Measure measure => _StaticMeasureChart(
        instrument: instrument,
        last: last,
        measure: measure,
        size: size,
        tabContext: tabContext,
      ),
      null => _EmptyMeasureChart(
        instrument: instrument,
        last: last,
        size: size,
        tabContext: tabContext,
      ),
    };
  }
}

class _StaticMeasureChart extends StatelessWidget {
  final Instrument instrument;
  final bool last;
  final Measure measure;
  final Size size;
  final TabContext tabContext;

  const _StaticMeasureChart({
    required this.instrument,
    required this.last,
    required this.measure,
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
              painter: MeasureChartPainter.forMeasure(
                tabContext: tabContext,
                instrument: instrument,
                measure: measure,
                last: last,
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
  final bool last;
  final Size size;
  final TabContext tabContext;

  const _EmptyMeasureChart({
    required this.instrument,
    required this.last,
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
            repeatEndOrLastMeasure: last,
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
