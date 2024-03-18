import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:aoc2015/runnable.dart';
import './reindeer.dart';

final kReindeerParsingRxp = RegExp(
    r'^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.$');

class Y2015Day14 implements Runnable {
  final reindeers = <Reindeer>[];

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    for (final line in lines) {
      final [name, velocity, flyTime, restTime] =
          kReindeerParsingRxp.allMatches(line).first.groups([1, 2, 3, 4]);

      reindeers.add(Reindeer(
          name: name!,
          velocity: int.parse(velocity!),
          restTime: int.parse(restTime!),
          flyTime: int.parse(flyTime!)));
    }
  }

  @override
  FutureOr<void> part1() {
    var maxDistance = 0;
    const totalTime = 2503;

    for (var i = 0; i < reindeers.length; i++) {
      final r = reindeers[i];
      final cycleTime = r.flyTime + r.restTime;
      final remainder = totalTime.remainder(cycleTime);
      int distance = (r.velocity * r.flyTime) * (totalTime ~/ cycleTime) +
          r.velocity * min(r.flyTime, remainder);

      maxDistance = max(maxDistance, distance);
    }

    print("Max distance travelled: $maxDistance");
  }

  @override
  FutureOr<void> part2() {}
}
