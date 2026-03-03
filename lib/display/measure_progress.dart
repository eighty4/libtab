import 'package:flutter/material.dart';
import 'package:libtab/libtab.dart';

class MeasureProgress extends StatefulWidget {
  final Metronome metronome;
  final TabContext? tabContext;

  const MeasureProgress(this.metronome, {super.key, this.tabContext});

  @override
  State<MeasureProgress> createState() => _MeasureProgressState();
}

class _MeasureProgressState extends State<MeasureProgress>
    with TickerProviderStateMixin {
  late AnimationController _animation;
  late Animation<Color> _color;
  late MetronomeListener _bpmListener;
  late MetronomeListener _measureListener;
  late MetronomeListener _tickingListener;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: widget.metronome.measureDuration,
      value: 0,
      vsync: this,
    );
    _animation.addListener(() => setState(() {}));
    updateMetronomeColor();
    _initializeMetronome();
  }

  @override
  void didUpdateWidget(MeasureProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.tabContext, oldWidget.tabContext)) {
      updateMetronomeColor();
    }
    if (!identical(widget.metronome, oldWidget.metronome)) {
      _clearMetronome();
      _initializeMetronome();
    }
  }

  void updateMetronomeColor() {
    final tabContext =
        widget.tabContext ??
        TabContext.forBrightness(
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
        );
    final color = tabContext.metronomeStyle.shapeColor;
    setState(() {
      _color = AlwaysStoppedAnimation<Color>(color);
    });
  }

  @override
  void dispose() {
    _clearMetronome();
    super.dispose();
  }

  void _clearMetronome() {
    _bpmListener.remove();
    _measureListener.remove();
    _tickingListener.remove();
  }

  void _initializeMetronome() {
    _bpmListener = widget.metronome.onBpm((int bpm) {
      _animation.duration = widget.metronome.measureDuration;
      if (_animation.isAnimating) {
        _animation.forward(from: _animation.value);
      }
    });
    _measureListener = widget.metronome.onMeasure((_) {
      _animation.forward(from: 0);
    });
    _tickingListener = widget.metronome.onTicking((ticking) {
      if (ticking) {
        _animation.forward();
      } else {
        _animation.stop(canceled: false);
      }
    });
    if (_animation.duration != widget.metronome.measureDuration) {
      _animation.duration = widget.metronome.measureDuration;
    }
    if (widget.metronome.isTicking()) {
      _animation.forward(from: widget.metronome.currentMeasureCompleted);
    } else {
      _animation.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.black12,
      value: _animation.value,
      valueColor: _color,
    );
  }
}
