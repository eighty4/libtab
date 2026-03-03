import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:libtab/libtab.dart';

import 'measure_paint.dart';

class MetronomeDisplay extends StatefulWidget {
  final List<Measure> measures;
  final Size measureSize;
  final Metronome metronome;

  const MetronomeDisplay({
    super.key,
    required this.measures,
    required this.measureSize,
    required this.metronome,
  });

  @override
  State<MetronomeDisplay> createState() => _MetronomeDisplayState();
}

class _MetronomeDisplayState extends State<MetronomeDisplay>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animateSize;
  late AnimationController _animation;
  late double _metronomeBorderRadius;
  late double _metronomeHeight;
  late double _metronomeHeightMin;
  late double _metronomeWidth;
  late double _metronomeWidthMin;
  late Tween<RelativeRect> _metronomePositioned;
  late double _noteVertOffset;
  late MetronomeListener _onMeasure;
  late MetronomeListener _onTicking;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: widget.metronome.measureDuration,
      vsync: this,
    );
    updateAnimations();
    updateMetronomeSize();
    _onMeasure = widget.metronome.onMeasure(restartAnimation);
    _onTicking = widget.metronome.onTicking(onTicking);
    // _animation.addStatusListener((status) {
    //   print("Metronome animation status listener $status");
    //   // todo only if looping measure
    //   if (status == AnimationStatus.completed) {
    //     restartAnimation();
    //   }
    //   // todo move to next measure
    // });
  }

  void onTicking(bool picking) {
    if (picking) {
      _animation.duration = widget.metronome.measureDuration;
      _animation.forward();
    } else {
      _animation.stop();
    }
  }

  void restartAnimation(_) {
    _animation.reset();
    if (kDebugMode) {
      print(
        "MetronomeDisplay.restartAnimation ${_animation.duration?.inMicroseconds}",
      );
    }
    _animation.forward();
  }

  @override
  void didUpdateWidget(MetronomeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.measureSize != oldWidget.measureSize) {
      updateMetronomeSize();
    }
    // todo only call if measure changes
    updateAnimations();
  }

  void updateMetronomeSize() {
    // called from initState and didUpdateWidget so setState is unnecessary
    final noteRadius = MeasureNotePainter.calcNoteRadius(widget.measureSize);
    _noteVertOffset = -1.5 * noteRadius;
    _metronomeBorderRadius = noteRadius * 1.125;
    _metronomeHeight = widget.measureSize.height + (noteRadius * 5);
    _metronomeHeightMin = widget.measureSize.height / 3;
    _metronomeWidth = noteRadius * 2.25;
    _metronomeWidthMin = noteRadius / 2.5;
    final mwh = _metronomeWidth / 2;
    _metronomePositioned = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        -1 * mwh,
        _noteVertOffset,
        widget.measureSize.width - mwh,
        _noteVertOffset,
      ),
      end: RelativeRect.fromLTRB(
        widget.measureSize.width - mwh,
        _noteVertOffset,
        -1 * mwh,
        _noteVertOffset,
      ),
    );
  }

  void updateAnimations() {
    List<bool> notes = List.filled(16, false, growable: false);
    for (final note in widget.metronome.currentMeasure.notes) {
      notes[note.timing.toSixteenthNth() - 1] = true;
    }
    final List<TweenSequenceItem<double>> sizes = [];
    sizes.add(
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0), weight: .5),
    );
    for (var i = 0; i < 16; i++) {
      if (notes[i]) {
        sizes.add(
          TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: .2),
        );
        sizes.add(
          TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: .6),
        );
        sizes.add(
          TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: .2),
        );
      } else {
        sizes.add(
          TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: 0),
            weight: 1.0,
          ),
        );
      }
    }
    sizes.add(
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0), weight: .5),
    );
    _animateSize = TweenSequence<double>(sizes).animate(_animation);
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: _metronomePositioned.animate(_animation),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.only(
              left: _animation.value * widget.measureSize.width,
            ),
            height: max(
              _metronomeHeight * _animateSize.value,
              _metronomeHeightMin,
            ),
            width: max(
              _metronomeWidth * _animateSize.value,
              _metronomeWidthMin,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_metronomeBorderRadius),
              color: const Color(0xff2255ff),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _onMeasure.remove();
    _onTicking.remove();
    _animation.dispose();
    super.dispose();
  }
}
