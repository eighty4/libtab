import 'dart:math';

import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(body: SafeArea(child: const SingleMeasureExample())),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    ),
  );
}

class SingleMeasureExample extends StatelessWidget {
  const SingleMeasureExample({super.key});

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
