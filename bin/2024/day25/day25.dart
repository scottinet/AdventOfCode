import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

const kLockSize = 7;

final class Y2024Day25 extends Runnable {
  final List<List<int>> _locks = [];
  final List<List<int>> _keys = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    final width = lines[0].length;
    List<int> buf = List.generate(width, (_) => 0);
    int start = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      for (int j = 0; j < line.length; j++) {
        if (line[j] == "#") {
          buf[j]++;
        }
      }

      if (line.isEmpty || i == lines.length - 1) {
        if (lines[start][0] == '#') {
          _locks.add(buf);
        } else {
          _keys.add(buf);
        }

        start = i + 1;
        buf = List.generate(width, (_) => 0);
      }
    }
  }

  @override
  void part1() {
    int matches = 0;

    for (final lock in _locks) {
      for (final key in _keys) {
        bool match = true;

        for (int i = 0; match && i < key.length; i++) {
          match = match && (key[i] + lock[i]) <= kLockSize;
        }

        if (match) matches++;
      }
    }

    print("Matches: $matches");
  }

  @override
  void part2() {}
}
