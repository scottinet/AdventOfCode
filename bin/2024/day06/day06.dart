import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:advent_of_code/vector.dart';

final class Y2024Day06 extends Runnable {
  static const dirs = [(0, -1), (1, 0), (0, 1), (-1, 0)];
  Map<(int, int), String> map = {};
  (int, int) start = (-1, -1);

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    final ymax = lines.length;
    final xmax = lines[0].length;

    for (int y = 0; y < ymax; y++) {
      for (int x = 0; x < xmax; x++) {
        final char = lines[y][x];

        if (char == '^') {
          start = (x, y);
          map[(x, y)] = '.';
        } else {
          map[(x, y)] = char;
        }
      }
    }
  }

  @override
  void part1() {
    Vector vect = Vector(pos: start, dir: dirs[0]);
    int idir = 0;
    final Set<(int, int)> walked = {start};

    while (true) {
      final next = vect.advance();
      var value = map[next.pos];

      if (value == null) {
        break;
      } else if (value == '#') {
        idir = (idir + 1) % dirs.length;
        vect = vect.changeDir(dirs[idir]);
      } else {
        walked.add(next.pos);
        vect = next;
      }
    }

    print("Walked: ${walked.length}");
  }

  @override
  void part2() {
    Vector vect = Vector(pos: start, dir: dirs[0]);
    int idir = 0;
    final Set<(int, int)> addableBlocks = {};
    final Set<(int, int)> walked = {vect.pos};

    while (true) {
      final next = vect.advance();
      var value = map[next.pos];

      if (value == null) {
        break;
      } else if (value == '#') {
        idir = (idir + 1) % dirs.length;
        vect = vect.changeDir(dirs[idir]);
      } else {
        walked.add(next.pos);
        vect = next;
      }

      final possibleBlock = _canLoop(vect, walked);

      if (possibleBlock != null) addableBlocks.add(possibleBlock);
    }

    print("Addable blocks: ${addableBlocks.length}");
  }

  /*
  * Walk until exit or until a position+vector has already been walked
  * 
  * Returns the position of the addable block if one can be added
  */
  (int, int)? _canLoop(Vector vect, final Set<(int, int)> walked) {
    final (int, int) addedBlock = vect.advance().pos;
    final Set<Vector> tested = {};
    int idir = (dirs.indexWhere((dir) => dir == vect.dir) + 1) % dirs.length;

    if (map[addedBlock] == null ||
        map[addedBlock] == '#' ||
        walked.contains(addedBlock)) {
      return null;
    }

    vect = vect.changeDir(dirs[idir]);
    tested.add(vect);

    while (true) {
      final next = vect.advance();
      final value = map[next.pos];

      if (value == null) {
        break;
      } else if (tested.contains(next)) {
        return addedBlock;
      } else if (value == '#' || next.pos == addedBlock) {
        idir = (idir + 1) % dirs.length;
        vect = vect.changeDir(dirs[idir]);
      } else {
        vect = next;
      }

      tested.add(next);
    }

    return null;
  }
}
