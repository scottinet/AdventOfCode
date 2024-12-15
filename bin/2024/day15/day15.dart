import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/movable_blocks.dart';
import 'package:advent_of_code/runnable.dart';
import 'package:advent_of_code/vector.dart';

typedef B = ({(num, num) pos, String kind});

final class Y2024Day15 extends Runnable {
  final _blocks = MovableBlocksList();
  final List<(int, int)> _directions = [];
  late (num, num) _robot;
  int xmax = -1, ymax = -1;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    xmax = lines[0].length;

    for (int y = 0; y < lines.length; y++) {
      if (ymax == -1 && lines[y].isEmpty) {
        ymax = y;
      }

      for (int x = 0; x < lines[y].length; x++) {
        switch (lines[y][x]) {
          case '.':
            continue;
          case '#':
          case 'O':
            _blocks.add(MovableBlock(
                points: [(x, y)],
                movable: lines[y][x] == 'O',
                value: lines[y][x]));
            break;
          case '@':
            _robot = (x, y);
            break;
          case '^':
            _directions.add((0, -1));
            break;
          case '>':
            _directions.add((1, 0));
            break;
          case 'v':
            _directions.add((0, 1));
            break;
          case '<':
            _directions.add((-1, 0));
            break;
          default:
            throw Exception("Don't know what to do with char ${lines[y][x]}");
        }
      }
    }
  }

  num getGpsCoords(MovableBlocksList blocks) {
    return blocks.blocks.fold(
        0,
        (agg, b) =>
            agg + (b.movable ? b.points[0].$1 + 100 * b.points[0].$2 : 0));
  }

  void applyDirections(MovableBlocksList blocks, (num, num) robot) {
    for (final dir in _directions) {
      final vect = Vector(pos: robot, dir: dir);
      final block = blocks.getBlockAt(vect.advance().pos);

      if (block == null) {
        robot = vect.advance().pos;
      } else if (blocks.move(block: block, dir: dir)) {
        robot = vect.advance().pos;
      }
    }
  }

  @override
  void part1() {
    final blocks = _blocks.copy();
    applyDirections(blocks, _robot);

    print("Sum of GPS coordinates: ${getGpsCoords(blocks)}");
  }

  @override
  void part2() {
    final blocks = MovableBlocksList();

    for (final block in _blocks.blocks) {
      blocks.add(MovableBlock(points: [
        (block.points[0].$1 * 2, block.points[0].$2),
        (block.points[0].$1 * 2 + 1, block.points[0].$2)
      ], movable: block.movable, value: block.value));
    }

    applyDirections(blocks, (_robot.$1 * 2, _robot.$2));

    print("Sum of GPS coordinates: ${getGpsCoords(blocks)}");
  }
}
