import 'dart:async';

abstract class Runnable {
  FutureOr<void> init(Stream<String> input, {List<String> args = const []});
  FutureOr<void> part1();
  FutureOr<void> part2();
}
