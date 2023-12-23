import 'package:gg_fake_timer/gg_fake_timer.dart';
import 'package:test/test.dart';

void main() {
  // Create some variables
  int counter = 0;
  const interval = Duration(seconds: 1);
  const oneMicroSecond = Duration(microseconds: 1);
  late GgFakeTimer timer;

  // ...........................................................................
  setUp(
    () {
      counter = 0;
      timer = GgFakeTimer(interval, () => counter++, isPeriodic: false);
    },
  );

  group('ggFakeTimer', () {
    // #########################################################################

    test('run() should create a immediately firing timer', () {
      expect(counter, 0);
      GgFakeTimer.run(() => counter++);
      expect(counter, 1);
    });

    group('single shot timer should work fine', () {
      // .......................................................................
      test('when using elapse(duration)', () {
        // Initially, the timer has not fired
        expect(counter, 0);
        expect(timer.isActive, isTrue);
        expect(timer.isCancelled, isFalse);
        expect(timer.isPeriodic, isFalse);
        expect(timer.tick, 10 * 1000 * 1000);

        // Forward time less then interval
        // Timer did not fire
        timer.elapse(interval - oneMicroSecond);
        expect(counter, 0);

        // Forward time to interval
        // Timer should fire
        timer.elapse(oneMicroSecond);
        expect(counter, 1);

        // After firing a single time,
        // timer should not be active anymore.
        expect(timer.isActive, isFalse);
        expect(timer.isCancelled, isTrue);
      });

      // .......................................................................

      test('when using fire()', () {
        // Initially, the timer has not fired
        expect(counter, 0);
        expect(timer.isActive, isTrue);

        // Call fire()
        // Timer did fire
        timer.fire();
        expect(counter, 1);

        // After firing a single time,
        // timer should not be active anymore.
        expect(timer.isActive, isFalse);
        expect(timer.isCancelled, isTrue);
      });

      // .......................................................................
      test('when canceling', () {
        // Initially, the timer has not fired
        expect(counter, 0);
        expect(timer.isActive, isTrue);

        // Forward time less then interval
        // Timer did not fire
        timer.elapse(interval - oneMicroSecond);
        expect(counter, 0);

        // Cancel timer
        timer.cancel();
        expect(timer.isActive, isFalse);
        expect(timer.isCancelled, isTrue);

        // Forward time to interval
        // Timer should not fire anymore
        timer.elapse(oneMicroSecond);
        expect(counter, 0);
      });
    });

    // #########################################################################
    group('periodic timer should work fine', () {
      test('when using elapse(duration)', () {
        final timer = GgFakeTimer.periodic(interval, (_) => counter++);

        // Initially, the timer has not fired
        expect(counter, 0);
        expect(timer.isActive, isTrue);

        // Forward time less then interval
        // Timer did not fire
        timer.elapse(interval - oneMicroSecond);
        expect(counter, 0);

        // Forward time to interval
        // Timer should fire
        timer.elapse(oneMicroSecond);
        expect(counter, 1);

        // Forward timer short before second interval
        // Timer should not have fired
        timer.elapse(interval - oneMicroSecond);
        expect(counter, 1);

        // Forward timer over second interval
        // Timer should have fired
        timer.elapse(oneMicroSecond);
        expect(counter, 2);

        // Cancel the timer
        timer.cancel();
        expect(timer.isActive, isFalse);
        expect(timer.isCancelled, isTrue);

        // Forward another interval
        // Timer should not fire anymore.
        timer.elapse(interval);
        timer.elapse(interval);
        expect(counter, 2);
      });

      // .......................................................................
      test('when using fire()', () {
        final timer = GgFakeTimer.periodic(interval, (_) => counter++);

        // Initially, the timer has not fired
        expect(counter, 0);
        expect(timer.isActive, isTrue);

        // Call fire()
        // Timer did fire
        timer.fire();
        expect(counter, 1);

        // Call fire() a second time
        // Timer did fire
        timer.fire();
        expect(counter, 2);

        // Cancel the timer
        timer.cancel();
        expect(timer.isActive, isFalse);
        expect(timer.isCancelled, isTrue);

        // Call fire()
        // Timer should not fire anymore.
        timer.elapse(interval);
        timer.elapse(interval);
        expect(counter, 2);
      });
    });
  });
}
