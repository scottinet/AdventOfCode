import 'dart:async';

import 'package:aoc2015/models/point.model.dart';
import 'package:aoc2015/models/runnable.model.dart';

class Day03 extends Runnable {
  String _content = '';

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    _content = await input.join();
  }

  @override
  void part1() {
    Point p = Point(0, 0);
    Set<Point> visited = {p};

    for (var i = 0; i < _content.length; i++) {
      switch (_content[i]) {
        case '^':
          p = Point(p.x, p.y + 1);
          break;
        case 'v':
          p = Point(p.x, p.y - 1);
          break;
        case '>':
          p = Point(p.x + 1, p.y);
          break;
        case '<':
          p = Point(p.x - 1, p.y);
          break;
      }

      visited.add(p);
    }

    print('Part 1: ${visited.length}');
  }

  @override
  void part2() {
    List<Point> plist = [Point(0, 0), Point(0, 0)];
    Set<Point> visited = {plist[0]};

    for (var i = 0; i < _content.length; i++) {
      Point p = plist[i % 2];

      switch (_content[i]) {
        case '^':
          p = Point(p.x, p.y + 1);
          break;
        case 'v':
          p = Point(p.x, p.y - 1);
          break;
        case '>':
          p = Point(p.x + 1, p.y);
          break;
        case '<':
          p = Point(p.x - 1, p.y);
          break;
      }

      plist[i % 2] = p;
      visited.add(p);
    }

    print('Part 2: ${visited.length}');
  }
}
