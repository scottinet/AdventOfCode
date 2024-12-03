import 'dart:async';

import 'package:advent_of_code/runnable.dart';

class Y2024Day03 extends Runnable {
  List<String> input = [];
  String content = "";

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    content = await input.join();
  }

  @override
  void part1() {
    final pattern = RegExp(r'mul\((\d+),(\d+)\)');
    num sum = 0;

    for (final match in pattern.allMatches(content)) {
      sum += match.groups([1, 2]).fold(1, (agg, val) => agg * int.parse(val!));
    }

    print("Sum: $sum");
  }

  @override
  void part2() {
    final pattern = RegExp(r"(do\(\)|don't\(\)|mul\(\d+,\d+\))");
    final mulPattern = RegExp(r'mul\((\d+),(\d+)\)');
    num sum = 0;
    bool active = true;

    for (final match in pattern.allMatches(content)) {
      final [command] = match.groups([1]);

      if (command!.startsWith("don't")) {
        active = false;
      } else if (command.startsWith("do")) {
        active = true;
      } else if (active) {
        sum += mulPattern
            .firstMatch(command)!
            .groups([1, 2]).fold(1, (agg, val) => agg * int.parse(val!));
      }
    }

    print("Sum: $sum");
  }
}
