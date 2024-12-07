import 'dart:async';
import 'dart:convert';
import 'package:trotter/trotter.dart';

import 'package:advent_of_code/runnable.dart';

typedef Equation = ({int total, List<int> numbers});

final class Y2024Day07 extends Runnable {
  List<Equation> equations = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    for (final line in lines) {
      final [total, numbers] = line.split(':').map((s) => s.trim()).toList();

      equations.add((
        total: int.parse(total),
        numbers: numbers.split(' ').map(int.parse).toList()
      ));
    }
  }

  @override
  void part1() {
    int calibratedSum = 0;

    for (final equation in equations) {
      final amalgams = Amalgams(equation.numbers.length - 1, ['+', '*']);

      for (final operators in amalgams()) {
        int result = equation.numbers[0];

        for (int i = 1; i < equation.numbers.length; i++) {
          result = operators[i - 1] == '+'
              ? result + equation.numbers[i]
              : result * equation.numbers[i];
        }

        if (result == equation.total) {
          calibratedSum += equation.total;
          break;
        }
      }
    }

    print("Sum of calibrated results: $calibratedSum");
  }

  @override
  void part2() {
    int calibratedSum = 0;

    for (final equation in equations) {
      final amalgams = Amalgams(equation.numbers.length - 1, ['*', '+', '||']);

      for (final operators in amalgams()) {
        int result = equation.numbers[0];

        for (int i = 1; i < equation.numbers.length; i++) {
          result = operators[i - 1] == '+'
              ? result + equation.numbers[i]
              : operators[i - 1] == '*'
                  ? result * equation.numbers[i]
                  : int.parse('$result${equation.numbers[i]}');
        }

        if (result == equation.total) {
          calibratedSum += equation.total;
          break;
        }
      }
    }

    print("Sum of calibrated results: $calibratedSum");
  }
}
