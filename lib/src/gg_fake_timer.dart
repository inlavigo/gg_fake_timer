// @license
// Copyright (c) 2019 - 2023 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:async';

class GgFakeTimer implements Timer {
  // ...........................................................................
  // Create a normal timer
  GgFakeTimer(this.interval, void Function() callback,
      {required this.isPeriodic})
      : _callback = callback;

  // ...........................................................................
  /// Create a periodic timer
  factory GgFakeTimer.periodic(
    Duration duration,
    void Function(Timer timer) callback,
  ) {
    final timer = GgFakeTimer(
      duration,
      () => {}, // coverage:ignore-line
      isPeriodic: true,
    );

    timer._callback = () => callback(timer);

    return timer;
  }

  // ...........................................................................
  /// Create an immediately executing single shot timer
  static void run(void Function() callback) => callback();

  // ...........................................................................
  /// Fake elapsed milliseconds -> Will trigger timer
  void elapse(Duration progress) {
    if (_isCancelled) {
      return;
    }

    _currentDuration = _currentDuration + progress;
    final durationSinceLastFire = _currentDuration - _durationAtLastFirering;

    if (durationSinceLastFire >= interval) {
      _callback();
      _durationAtLastFirering = _currentDuration;

      if (!isPeriodic) {
        _isCancelled = true;
      }
    }
  }

  // ...........................................................................
  void fire() => elapse(_currentDuration + interval);

  // ...........................................................................
  /// Interval
  final Duration interval;

  /// Returns true if timer is a periodic timer
  final bool isPeriodic;

  /// Current ticks
  @override
  int get tick => interval.inMicroseconds * 10;

  /// Returns true if timer is still active
  @override
  bool get isActive => !_isCancelled;

  /// Returns true if timer is cancelled
  bool get isCancelled => _isCancelled;

  // ...........................................................................
  // Livecycle

  /// Cancel timer
  @override
  void cancel() => _isCancelled = true;

  // ######################
  // Private
  // ######################

  void Function() _callback;
  bool _isCancelled = false;
  Duration _durationAtLastFirering = Duration.zero;
  Duration _currentDuration = Duration.zero;
}
