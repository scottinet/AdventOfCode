import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

final class Gate {
  final String name;
  int? value;
  Gate? cond1, cond2;
  String? op;

  Gate({required this.name, int? value, Gate? cond1, Gate? cond2, String? op}) {
    if (value != null) {
      this.value = value;
    } else {
      assert(cond1 != null && cond2 != null && op != null);
      this.cond1 = cond1;
      this.cond2 = cond2;
      this.op = op;
    }
  }

  int getValue() {
    if (value != null) return value!;

    switch (op) {
      case "AND":
        return cond1!.getValue() & cond2!.getValue();
      case "OR":
        return cond1!.getValue() | cond2!.getValue();
      case "XOR":
        return cond1!.getValue() ^ cond2!.getValue();
      default:
        throw Exception("Unknown operator $op");
    }
  }
}

final class Y2024Day24 extends Runnable {
  final Map<String, Gate> _gates = {};

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    final Map<String, int> initialValues = {};
    int i = 0;

    for (; lines[i].isNotEmpty; i++) {
      final entry = lines[i].split(':').map((l) => l.trim()).toList();
      initialValues[entry[0]] = int.parse(entry[1]);
    }

    final List<List<String>> tasks = [];

    for (i++; i < lines.length; i++) {
      final [operation, gate] = lines[i].split(' -> ');
      final [cond1, op, cond2] = operation.split(' ');

      for (final n in [cond1, cond2]) {
        if (initialValues.containsKey(n)) {
          _gates[n] = Gate(name: n, value: initialValues[n]);
        }
      }
      tasks.add([cond1, op, cond2, gate]);
    }

    while (tasks.isNotEmpty) {
      final idx = tasks.indexWhere(
          (t) => _gates.containsKey(t[0]) && _gates.containsKey(t[2]));
      final task = tasks.removeAt(idx);

      _gates[task[3]] = Gate(
          name: task[3],
          cond1: _gates[task[0]],
          op: task[1],
          cond2: _gates[task[2]]);
    }
  }

  @override
  void part1() {
    final keys = _gates.keys.where((k) => k.startsWith('z')).sorted().reversed;
    final values = keys.map((k) => _gates[k]!.getValue()).join();

    print(int.parse(values, radix: 2));
  }

  @override
  void part2() {}
}
