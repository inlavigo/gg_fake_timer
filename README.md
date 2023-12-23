With `GgFakeTimer` it is easy to control Timer during tests

## Usage

### Create a single shot timer

```dart
// Define some constants
  const interval = Duration(seconds: 1);
  const oneMicroSecond = Duration(microseconds: 1);

  // ..........................
  // Create a single shot timer
  print('Single shot timer with elapse(...)');

  int counter = 0;
  var timer = GgFakeTimer(interval, () => counter++, isPeriodic: false);

  // Forward timer less then interval
  // Timer did not fire
  timer.elapse(interval - oneMicroSecond);
  assert(counter == 0);

  // Forward timer to interval
  // Timer should fire
  timer.elapse(oneMicroSecond);
  assert(counter == 1);

  // After firing a single time,
  // timer should not be active anymore.
  assert(timer.isActive == false);
  assert(timer.isCancelled == true);

  // When time elapses further, timer does not fire
  timer.elapse(interval);
  assert(counter == 1);

  // ..........................
  // Create a single shot timer
  print('Single shot timer with fire(...)');

  counter = 0;
  timer = GgFakeTimer(interval, () => counter++, isPeriodic: false);

  // Forward timer to interval
  // Timer should fire
  timer.fire();
  assert(counter == 1);

  // After firing a single time,
  // timer should not be active anymore.
  assert(timer.isActive == false);
  assert(timer.isCancelled == true);

  // Calling fire() another time will have no effect
  timer.fire();
  assert(counter == 1);

  // ..........................
  // Cancel a shingle shot timer
  print('Cancelling a single shot timer');

  counter = 0;
  timer = GgFakeTimer(interval, () => counter++, isPeriodic: false);

  // Cancel timer
  timer.cancel();

  // Forward timer to interval
  // Timer did not fire because it was cancelled.
  timer.elapse(interval);
  assert(counter == 0);

  // .........................
  // Work with periodic timers
  counter = 0;
  timer = GgFakeTimer.periodic(interval, (_) => counter++);

  // Forward time less then interval
  // Timer did not fire
  timer.elapse(interval - oneMicroSecond);
  assert(counter == 0);

  // Forward time to interval
  // Timer should fire
  timer.elapse(oneMicroSecond);
  assert(counter == 1);

  // Forward timer short before second interval
  // Timer should not have fired
  timer.elapse(interval - oneMicroSecond);
  assert(counter == 1);

  // Forward timer over second interval
  // Timer should have fired
  timer.elapse(oneMicroSecond);
  assert(counter == 2);

  // Cancel the timer
  timer.cancel();
  assert(timer.isActive == false);
  assert(timer.isCancelled == true);

  // Forward another interval
  // Timer should not fire anymore.
  timer.elapse(interval);
  timer.elapse(interval);
  assert(counter == 2);

  print('Did work!');
```

## Features and bugs

Please file feature requests and bugs at [GitHub](https://github.com/inlavigo/gg_fake_stopwatch).
