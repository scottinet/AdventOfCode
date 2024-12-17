import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

class Registers {
  int A, B, C;

  Registers({required this.A, required this.B, required this.C});

  Registers copy() {
    return Registers(A: A, B: B, C: C);
  }

  @override
  String toString() {
    return "(A: $A, B: $B, C: $C)";
  }
}

final class Y2024Day17 extends Runnable {
  late Registers _registers;
  final List<int> _program = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _registers = Registers(
        A: int.parse(lines[0].split(': ')[1]),
        B: int.parse(lines[1].split(': ')[1]),
        C: int.parse(lines[2].split(': ')[1]));

    _program
        .addAll(lines[4].split(': ')[1].split(',').map((c) => int.parse(c)));
  }

  int getComboValue(int combo, Registers regs) {
    if (combo < 4) return combo;
    if (combo == 4) return regs.A;
    if (combo == 5) return regs.B;
    if (combo == 6) return regs.C;

    throw Exception('Invalid combo operator: $combo');
  }

  List<int> solve(Registers regs) {
    List<int> out = [];
    int pointer = 0;

    while (pointer < _program.length) {
      switch (_program[pointer]) {
        case 0:
          regs.A = regs.A ~/ pow(2, getComboValue(_program[pointer + 1], regs));
          break;
        case 1:
          regs.B ^= _program[pointer + 1];
          break;
        case 2:
          regs.B = getComboValue(_program[pointer + 1], regs) % 8;
          break;
        case 3:
          pointer = regs.A == 0 ? pointer + 2 : _program[pointer + 1];
          continue;
        case 4:
          regs.B ^= regs.C;
          break;
        case 5:
          out.add(getComboValue(_program[pointer + 1], regs) % 8);
          break;
        case 6:
          regs.B = regs.A ~/ pow(2, getComboValue(_program[pointer + 1], regs));
          break;
        case 7:
          regs.C = regs.A ~/ pow(2, getComboValue(_program[pointer + 1], regs));
          break;
        default:
          throw Exception(
              'Invalid program opcode: ${_program[pointer]} (pointer: $pointer)');
      }

      pointer += 2;
    }

    return out;
  }

  @override
  void part1() {
    print(solve(_registers.copy()).join(','));
  }

  List<String> findDigits(String input) {
    if (input.length == _program.length) return [input];

    List<int> sliced = _program.slice(_program.length - input.length - 1);
    List<String> output = [];

    for (int i = 0; i < 8; i++) {
      final test = input + i.toString();
      final result = solve(Registers(A: int.parse(test, radix: 8), B: 0, C: 0));

      if (result.toString() == sliced.toString()) {
        output.add(test);
      }
    }

    return output.map((o) => findDigits(o)).flattened.toList();
  }

  @override
  void part2() {
    print(findDigits('')
        .map((s) => int.parse(s, radix: 8))
        .toList()
        .sorted((a, b) => a - b)[0]);
  }
}
