import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:libtab/libtab.dart';
import 'package:meta/meta.dart';

class MetronomeListener {
  final VoidCallback _listener;
  final ChangeNotifier _notifier;

  MetronomeListener(this._notifier, this._listener);

  void remove() {
    _notifier.removeListener(_listener);
  }
}

abstract class MetronomeMaterial {
  Measure at(int measureIndex);
  bool isLastMeasure(int measureIndex);
}

class MetronomeMeasures extends MetronomeMaterial {
  final List<Measure> measures;

  MetronomeMeasures(this.measures);

  @override
  Measure at(int measureIndex) {
    return measures[measureIndex];
  }

  @override
  bool isLastMeasure(int measureIndex) {
    return measureIndex == measures.length - 1;
  }
}

class _MeasureNotifier extends ValueNotifier<int> {
  _MeasureNotifier(super.value);

  void emit() {
    notifyListeners();
  }
}

class Metronome {
  final ValueNotifier<int> _bpm;
  final ValueNotifier<bool> _looping;
  final _MeasureNotifier _measure = _MeasureNotifier(0);
  final ValueNotifier<bool> _ticking = ValueNotifier(false);

  final MetronomeMaterial _material;
  MetronomeMaterial get material => _material;

  late final _MetronomeTimer _timer;

  Metronome({int? bpm, bool? looping, required MetronomeMaterial material})
    : _bpm = ValueNotifier(bpm ?? 10),
      _looping = ValueNotifier(looping ?? false),
      _material = material {
    _timer = _MetronomeTimer(
      bpm: _bpm.value,
      continuation: _looping.value || !_material.isLastMeasure(0),
      onMeasureElapsed: _onMeasureElapsed,
    );
  }

  factory Metronome.forMeasures(
    int? bpm,
    List<Measure> measures,
    bool? looping,
  ) {
    return Metronome(
      bpm: bpm,
      looping: looping,
      material: MetronomeMeasures(measures),
    );
  }

  /// Whether [Metronome]'s [MaterialSource] is at tracked at start position.
  bool isAtBeginning() => _timer.isAtBeginning();

  /// Whether [currentMeasure] is the last measure from the [MeasureSource].
  bool isFirstMeasure() => _measure.value == 0;

  /// Whether [currentMeasure] is the last measure from the [MeasureSource].
  bool isLastMeasure() => _material.isLastMeasure(_measure.value);

  bool isTicking() => _ticking.value;

  set bpm(int bpm) {
    _timer.bpm = _bpm.value = bpm;
  }

  Measure get currentMeasure => _material.at(_measure.value);

  double get currentMeasureCompleted => _timer.currentMeasureCompleted;

  Duration get measureDuration => _timer.measureDuration;

  bool get looping => _looping.value;

  set looping(bool looping) {
    _looping.value = looping;
    _updateContinuation();
  }

  bool nextMeasure() {
    if (isLastMeasure()) {
      return false;
    } else {
      _measure.value += 1;
      _updateContinuation();
      return true;
    }
  }

  bool prevMeasure() {
    if (isFirstMeasure()) {
      return false;
    } else {
      _measure.value -= 1;
      _updateContinuation();
      return true;
    }
  }

  void reset() {
    _timer.reset();
    _measure.value = 0;
    _ticking.value = false;
  }

  void toggleLooping() {
    looping = !looping;
  }

  void toggleTicking() {
    if (_ticking.value) {
      _ticking.value = false;
      _timer.stop();
    } else {
      _ticking.value = true;
      _timer.start(continuation: _looping.value || !isLastMeasure());
    }
  }

  void _onMeasureElapsed() {
    if (_looping.value) {
      _measure.emit();
    } else {
      nextMeasure();
    }
  }

  void _updateContinuation() {
    _timer.continuation = looping || !isLastMeasure();
  }

  @useResult
  MetronomeListener onBpm(Function(int bpm) onBpm) {
    void listener() {
      onBpm(_bpm.value);
    }

    _bpm.addListener(listener);
    return MetronomeListener(_bpm, listener);
  }

  @useResult
  MetronomeListener onLooping(Function(bool looping) onLooping) {
    void listener() {
      onLooping(_looping.value);
    }

    _looping.addListener(listener);
    return MetronomeListener(_looping, listener);
  }

  @useResult
  MetronomeListener onMeasure(Function(int measure) onMeasure) {
    void listener() {
      onMeasure(_measure.value);
    }

    _measure.addListener(listener);
    return MetronomeListener(_measure, listener);
  }

  @useResult
  MetronomeListener onTicking(Function(bool ticking) onTicking) {
    void listener() {
      onTicking(_ticking.value);
    }

    _ticking.addListener(listener);
    return MetronomeListener(_ticking, listener);
  }

  void dispose() {
    _timer.reset();
    _bpm.dispose();
    _looping.dispose();
    _measure.dispose();
    _ticking.dispose();
  }
}

class _MetronomeTimer {
  int _bpm;
  bool _continuation;
  final VoidCallback _onMeasureElapsed;

  /// Tracks material progress.
  final Stopwatch _stopwatch = Stopwatch();

  /// Tracks time of current measure.
  Timer? _timer;

  _MetronomeTimer({
    required int bpm,
    required bool continuation,
    required VoidCallback onMeasureElapsed,
  }) : _bpm = bpm,
       _continuation = continuation,
       _onMeasureElapsed = onMeasureElapsed;

  set bpm(int bpm) {
    _bpm = bpm;
  }

  set continuation(bool continuation) {
    _continuation = continuation;
  }

  double get currentMeasureCompleted => clampDouble(
    _stopwatch.elapsedMicroseconds / _measureDurationMicroseconds,
    0,
    1,
  );

  Duration get currentMeasureDuration =>
      isAtBeginning() ? measureDuration : _measureDurationRemaining;

  Duration get measureDuration {
    return Duration(microseconds: _measureDurationMicroseconds);
  }

  bool isAtBeginning() => _stopwatch.elapsedMicroseconds == 0;

  void reset() {
    _stopwatch.reset();
    _timer?.cancel();
  }

  void start({bool? continuation}) {
    final timerDuration = isAtBeginning()
        ? measureDuration
        : _measureDurationRemaining;
    _stopwatch.start();
    _timer = Timer(timerDuration, _onTimerElapsed);
    if (continuation != null) {
      _continuation = continuation;
    }
  }

  void stop() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  int get _measureDurationMicroseconds {
    return Duration.microsecondsPerMinute ~/ _bpm;
  }

  Duration get _measureDurationRemaining {
    final elapsed = _stopwatch.elapsedMicroseconds;
    final duration = _measureDurationMicroseconds;
    return Duration(microseconds: duration - (elapsed % duration));
  }

  void _onTimerElapsed() {
    if (_continuation) {
      _timer = Timer(measureDuration, _onTimerElapsed);
    }
    _onMeasureElapsed();
  }
}
