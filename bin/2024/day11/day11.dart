import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

final class Y2024Day11 extends Runnable {
  final List<int> _stones = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final values = (await input.transform(LineSplitter()).toList())
        .first
        .split(RegExp(r'\s'));

    _stones.addAll(values.map((v) => int.parse(v)));
  }

  @override
  void part1() {
    final stones = List.from(_stones);

    for (int i = 0; i < 25; i++) {
      final List<int> spawned = [];

      for (int s = 0; s < stones.length; s++) {
        final str = stones[s].toString();

        if (stones[s] == 0) {
          stones[s] = 1;
        } else if (str.length % 2 == 0) {
          final pivot = str.length ~/ 2;
          stones[s] = int.parse(str.substring(0, pivot));
          spawned.add(int.parse(str.substring(pivot)));
        } else {
          stones[s] *= 2024;
        }
      }

      stones.addAll(spawned);
    }

    print("There are now ${stones.length} stones");
  }

  ExpandResult expand(List<int> stones, int times) {
    List<(List<int> stones, int i)> remaining = [];

    for (int i = 0; i < times && stones.isNotEmpty; i++) {
      final List<int> next = [];

      for (int s = 0; s < stones.length; s++) {
        final str = stones[s].toString();

        if (stones[s] == 0) {
          next.add(1);
        } else if (str.length % 2 == 0) {
          final pivot = str.length ~/ 2;
          next.add(int.parse(str.substring(0, pivot)));
          next.add(int.parse(str.substring(pivot)));
        } else {
          next.add(stones[s] * 2024);
        }
      }

      stones = [];
      final List<int> setAside = [];
      for (final s in next) {
        if (s.toString().length > 1) {
          stones.add(s);
        } else {
          setAside.add(s);
        }
      }

      if (setAside.isNotEmpty) {
        remaining.add((setAside, i + 1));
      }
    }

    return (count: stones.length, remaining: remaining);
  }

  int expandSingle(int stone, int remainingSteps, Map<(int, int), int> cache) {
    final known = cache[(stone, remainingSteps)];

    if (known != null) return known;

    if (remainingSteps > 0) {
      var (:count, :remaining) = expand([stone], remainingSteps);

      for (final r in remaining) {
        final todo = remainingSteps - r.$2;

        if (todo == 0) {
          count += r.$1.length;
        } else {
          for (final l in r.$1) {
            count += expandSingle(l, todo, cache);
          }
        }
      }

      cache[(stone, remainingSteps)] = count;
      return count;
    }

    return 1;
  }

  @override
  void part2() {
    const blinks = 75;

    var (:count, :remaining) = expand(_stones, blinks);
    Map<(int, int), int> cache = {};

    while (remaining.isNotEmpty) {
      final (stones, i) = remaining.removeLast();

      for (final s in stones) {
        count += expandSingle(s, blinks - i, cache);
      }
    }

    print("There are now $count stones");
  }
}

typedef ExpandResult = ({int count, List<(List<int> stones, int i)> remaining});
