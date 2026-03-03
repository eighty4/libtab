import 'dart:math';

import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(body: SafeArea(child: const MetronomeMaterialExample())),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    ),
  );
}

class DynamicMetronomeMaterial implements MetronomeMaterial {
  static const measureCount = 3;
  @override
  Measure at(int measureIndex) {
    return switch (measureIndex % measureCount) {
      0 => Measure.fromNoteList([
        Note(3, 0),
        Note(2, 1),
        Note(1, 3),
        Note(5, 0),
        Note(1, 3),
        Note(2, 1),
        Note(3, 0),
        Note(1, 3),
      ]),
      1 => Measure.fromNoteList([
        Note(3, 0),
        Note(2, 0),
        Note(1, 2),
        Note(5, 0),
        Note(1, 2),
        Note(2, 0),
        Note(3, 0),
        Note(1, 2),
      ]),
      2 => Measure.fromNoteList([
        Note(3, 0),
        Note(2, 0),
        Note(1, 0),
        Note(5, 0),
        Note(1, 0),
        Note(2, 0),
        Note(3, 0),
        Note(1, 0),
      ]),
      _ => throw Error(),
    };
  }

  @override
  bool isLastMeasure(int measureIndex) {
    return false;
  }
}

class MetronomeMaterialExample extends StatefulWidget {
  const MetronomeMaterialExample({super.key});

  @override
  State<MetronomeMaterialExample> createState() =>
      _MetronomeMaterialExampleState();
}

class _MetronomeMaterialExampleState extends State<MetronomeMaterialExample> {
  late final Metronome metronome;
  late MetronomeListener onTicking;
  bool looping = false;
  bool ticking = true;

  @override
  void initState() {
    super.initState();
    metronome = Metronome(material: DynamicMetronomeMaterial(), looping: false);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              ElevatedButton.icon(
                icon: Icon(ticking ? Icons.pause : Icons.play_arrow),
                label: Text(ticking ? 'Pause' : 'Play'),
                onPressed: () => metronome.toggleTicking(),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.loop),
                label: Text('Loop'),
                style: !looping
                    ? null
                    : ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                onPressed: () {
                  metronome.toggleLooping();
                  setState(() => looping = metronome.looping);
                },
              ),
            ],
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
      children: [
        Text('Forward-backward roll', style: style),
        Text('over chords C E & G', style: style),
        subheader,
      ],
    );
  }
}
