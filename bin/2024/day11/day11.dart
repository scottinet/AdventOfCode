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

  @override
  void part2() {}
}
