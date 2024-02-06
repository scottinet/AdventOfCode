import 'dart:async';

import 'package:aoc2015/models/runnable.model.dart';

class Day01 extends Runnable {
  int floor = 0;
  int basementEnteredAt = -1;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final content = await input.join();

    for (int i = 0; i < content.length; i++) {
      if (content[i] == '(') {
        floor++;
      } else if (content[i] == ')') {
        floor--;
      }

      if (basementEnteredAt == -1 && floor == -1) {
        basementEnteredAt = i + 1;
      }
    }
  }

  @override
  void part1() {
    print('Floor: $floor');
  }

  @override
  void part2() {
    print('Basement entered at: $basementEnteredAt');
  }
}
