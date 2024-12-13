import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/equation.dart';
import 'package:advent_of_code/runnable.dart';

typedef Machine = ({(int, int) A, (int, int) B, (int, int) prize});

final class Y2024Day13 extends Runnable {
  final List<Machine> machines = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    for (int i = 0; i < lines.length; i += 4) {
      List<(int, int)> machine = [];

      for (int j = i; j < i + 3; j++) {
        List<int> xy = lines[j]
            .split(':')[1]
            .split(',')
            .map((s) => int.parse(s.replaceAll(RegExp(r'\D'), '')))
            .toList();

        machine.add((xy[0], xy[1]));
      }

      machines.add((A: machine[0], B: machine[1], prize: machine[2]));
    }
  }

  @override
  void part1() {
    int tokens = 0;

    for (final m in machines) {
      List<List<num>> equations = [
        [m.A.$1, m.B.$1, m.prize.$1],
        [m.A.$2, m.B.$2, m.prize.$2]
      ];

      final result = solveEquations(equations);
      bool valid = true;

      for (final n in result) {
        int ipart = n.truncate();
        double fpart = n - ipart.toDouble();

        if (n < 0 || ipart > 100 || (fpart > 1e-6 && (1 - fpart) > 1e-6)) {
          valid = false;
        }
      }

      if (valid) {
        tokens += result[0].round() * 3 + result[1].round();
      }
    }

    print("Tokens used: $tokens");
  }

  @override
  void part2() {
    int tokens = 0;

    for (final m in machines) {
      List<List<num>> equations = [
        [m.A.$1, m.B.$1, m.prize.$1 + 10000000000000],
        [m.A.$2, m.B.$2, m.prize.$2 + 10000000000000]
      ];

      final result = solveEquations(equations);
      bool valid = true;

      for (final n in result) {
        int ipart = n.truncate();
        double fpart = n - ipart.toDouble();

        if (n < 0 || (fpart > 1e-3 && (1 - fpart) > 1e-3)) {
          valid = false;
        }
      }

      if (valid) {
        tokens += result[0].round() * 3 + result[1].round();
      }
    }

    print("Tokens used: $tokens");
  }
}
