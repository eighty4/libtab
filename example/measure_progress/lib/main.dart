import 'dart:math';

import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(body: SafeArea(child: const MeasureProgressExample())),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    ),
  );
}

class MeasureProgressExample extends StatefulWidget {
  const MeasureProgressExample({super.key});

  @override
  State<MeasureProgressExample> createState() => _MeasureProgressExampleState();
}

class _MeasureProgressExampleState extends State<MeasureProgressExample> {
  late final Metronome metronome;
  late MetronomeListener onTicking;
  bool ticking = true;

  @override
  void initState() {
    super.initState();
    metronome = Metronome(
      material: MetronomeMeasures([
        Measure.fromNoteList([
          Note(3, 0),
          Note(2, 1),
          Note(1, 3),
          Note(5, 0),
          Note(1, 3),
          Note(2, 1),
          Note(3, 0),
          Note(1, 3),
        ]),
      ]),
      looping: true,
    );
    onTicking = metronome.onTicking((update) {
      setState(() => ticking = update);
    });
    metronome.toggleTicking();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 60,
        children: [
          ExampleHeader(),
          MeasureChart.withMetronome(
            instrument: Instrument.banjo,
            metronome: metronome,
            size: chartSize(context),
            tabContext: TabContext.forBrightness(Brightness.light),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: MeasureProgress(metronome),
          ),
          ElevatedButton.icon(
            icon: Icon(ticking ? Icons.pause : Icons.play_arrow),
            label: Text(ticking ? 'Pause' : 'Play'),
            onPressed: () => metronome.toggleTicking(),
          ),
        ],
      ),
    );
  }

  Size chartSize(BuildContext context) {
    final double w = (MediaQuery.sizeOf(context).width * .8).clamp(200, 800);
    final double h = min(300, w * .5);
    return Size(w, h);
  }
}

class ExampleHeader extends StatelessWidget {
  const ExampleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
    const subheader = Text(
      'for the 5-string banjo',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
      ),
    );
    return Column(
      spacing: 5,
      children: MediaQuery.sizeOf(context).width < 600
          ? [
              Text('Forward-backward roll', style: style),
              Text('over a C-chord', style: style),
              subheader,
            ]
          : [
              Text('Forward-backward roll over a C-chord', style: style),
              subheader,
            ],
    );
  }
}
