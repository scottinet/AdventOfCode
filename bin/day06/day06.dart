import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:aoc2015/models/runnable.model.dart';

import 'action.model.dart';

class Day06 extends Runnable {
  final List<Action> actions = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = input.transform(LineSplitter());
    final rxp =
        RegExp(r'(toggle|turn on|turn off) (\d+,\d+) through (\d+,\d+)');

    await for (final line in lines) {
      final parsed = rxp.firstMatch(line);

      if (parsed == null || parsed.groupCount != 3) {
        throw Exception('Cannot parse: "$line"');
      }

      final [xs, ys] = parsed.group(2)!.split(',').map(int.parse).toList();
      final [xe, ye] = parsed.group(3)!.split(',').map(int.parse).toList();

      actions.add(Action(
          type: parsed.group(1)!, start: Point(xs, ys), end: Point(xe, ye)));
    }
  }

  @override
  void part1() {
    final Set<Point> lit = {};

    for (final action in actions) {
      for (num y = action.start.y; y <= action.end.y; y++) {
        for (num x = action.start.x; x <= action.end.x; x++) {
          final p = Point(x, y);

          if (action.type == 'turn on') {
            lit.add(p);
          } else if (action.type == 'turn off') {
            lit.remove(p);
          } else if (lit.contains(p)) {
            lit.remove(p);
          } else {
            lit.add(p);
          }
        }
      }
    }

    print('Lights on: ${lit.length}');
  }

  @override
  void part2() {}
}
