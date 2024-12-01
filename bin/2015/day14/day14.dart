import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:advent_of_code/runnable.dart';
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

  int getDistanceTravelled(Reindeer reindeer, int elapsed) {
    final cycleTime = reindeer.flyTime + reindeer.restTime;
    final remainder = elapsed.remainder(cycleTime);

    return (reindeer.velocity * reindeer.flyTime) * (elapsed ~/ cycleTime) +
        reindeer.velocity * min(reindeer.flyTime, remainder);
  }

  @override
  FutureOr<void> part1() {
    var maxDistance = 0;
    const totalTime = 2503;

    for (var i = 0; i < reindeers.length; i++) {
      final r = reindeers[i];
      maxDistance = max(maxDistance, getDistanceTravelled(r, totalTime));
    }

    print("Max distance travelled: $maxDistance");
  }

  @override
  FutureOr<void> part2() {
    const totalTime = 2503;
    final points = List<int>.filled(reindeers.length, 0, growable: false);

    for (int elapsed = 0; elapsed < totalTime; elapsed++) {
      final travelled =
          reindeers.map((r) => getDistanceTravelled(r, elapsed + 1)).toList();
      final maxDistance = travelled.reduce((agg, val) => max(agg, val));

      for (int i = 0; i < travelled.length; i++) {
        if (travelled[i] == maxDistance) {
          points[i]++;
        }
      }
    }

    final maxPoints = points.reduce((agg, val) => max(agg, val));

    print("Maximum points: $maxPoints");
  }
}
