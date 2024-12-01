import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

import 'operation.dart';

class Y2015Day07 extends Runnable {
  Map<String, Operation> dict = {};
  int? a;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    await for (final line in input.transform(LineSplitter())) {
      final [lhs, rhs] = line.split(' -> ');
      final op = lhs.split(' ');

      if (op.length == 1) {
        dict[rhs] = Operation(lhs: op[0], op: 'NOOP');
      } else if (op.length == 2) {
        dict[rhs] = Operation(lhs: op[1], op: 'NOT');
      } else {
        dict[rhs] = Operation(lhs: op[0], op: op[1], rhs: op[2]);
      }
    }
  }

  int _compute({required String op, required int lhs, int? rhs}) {
    if (op != 'NOT' && op != 'NOOP' && rhs == null) {
      throw Exception('Cannot perform $op without a rhs');
    }

    switch (op) {
      case 'NOOP':
        return lhs;
      case 'NOT':
        return ~lhs;
      case 'AND':
        return lhs & rhs!;
      case 'OR':
        return lhs | rhs!;
      case 'LSHIFT':
        return lhs << rhs!;
      case 'RSHIFT':
        return lhs >> rhs!;
      default:
        throw Exception('Unknown operator $op');
    }
  }

  int _findA(Map<String, int> computed) {
    final queue = dict.keys.toSet()..removeWhere((k) => computed[k] != null);

    while (queue.isNotEmpty && !computed.containsKey('a')) {
      final l = queue.toList();

      for (final key in l) {
        final value = dict[key];
        final lhs = int.tryParse(value!.lhs) ?? computed[value.lhs];
        final op = value.op;
        int? rhs;

        if (value.rhs != null) {
          rhs = int.tryParse(value.rhs!) ?? computed[value.rhs];
        }

        if (lhs != null && (op.startsWith('NO') || rhs != null)) {
          computed[key] = _compute(op: value.op, lhs: lhs, rhs: rhs);
          queue.remove(key);
        }
      }
    }

    return computed['a']!;
  }

  @override
  void part1() {
    final Map<String, int> computed = {};

    for (final entry in dict.entries) {
      if (entry.value.op == 'NOOP') {
        final res = int.tryParse(entry.value.lhs);

        if (res != null) {
          computed[entry.key] = res;
        }
      }
    }

    a = _findA(computed);
    print('A: $a');
  }

  @override
  void part2() {
    final Map<String, int> computed = {};

    for (final entry in dict.entries) {
      if (entry.value.op == 'NOOP') {
        if (entry.key == 'b') {
          computed[entry.key] = a!;
        } else {
          final res = int.tryParse(entry.value.lhs);

          if (res != null) {
            computed[entry.key] = res;
          }
        }
      }
    }

    print('A: ${_findA(computed)}');
  }
}
