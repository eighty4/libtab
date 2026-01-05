import 'package:flutter/widgets.dart';
import 'package:libtab/libtab.dart';

import 'measure_paint.dart';
import 'note_positioning.dart';

/// Displays a [Measure] of tab data that can be styled with [TabContext]
@Deprecated('migrate to MeasureChart.singleMeasure')
class MeasureDisplay extends StatelessWidget {
  static const defaultSize = Size(300, 200);
  final TabContext tabContext;
  final Size size;
  final Instrument instrument;
  final bool last;
  final Measure measure;
  final String? label;

  const MeasureDisplay(
    this.measure, {
    super.key,
    this.size = defaultSize,
    required this.tabContext,
    required this.instrument,
    this.label,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final chartPositioning = ChartPositioning.calculate(size, instrument);
    final notePositioning = NotePositioning.calculate(
      measure.notes,
      chartPositioning,
    );
    return _MeasureDisplay(
      measure: measure,
      chartPositioning: chartPositioning,
      notePositioning: notePositioning,
      tabContext: tabContext,
      instrument: instrument,
      size: size,
      label: label,
      last: last,
    );
  }
}

class _MeasureDisplay extends StatelessWidget {
  final TabContext tabContext;
  final Size size;
  final Instrument instrument;
  final bool last;
  final Measure measure;
  final String? label;
  final ChartPositioning chartPositioning;
  final NotePositioning notePositioning;

  const _MeasureDisplay({
    required this.measure,
    required this.chartPositioning,
    required this.notePositioning,
    required this.tabContext,
    required this.instrument,
    required this.size,
    required this.last,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return buildMeasure();
    } else {
      return buildLabeledMeasure();
    }
  }

  Widget buildLabeledMeasure() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: tabContext.labelTextColor,
          ),
        ),
        const SizedBox(height: 25),
        buildMeasure(),
      ],
    );
  }

  Widget buildMeasure() {
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
  }
}
