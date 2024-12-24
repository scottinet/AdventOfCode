import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

final class Gate {
  String name;
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

  bool isResultOf(Gate cond1, String op, Gate cond2) {
    return op == this.op &&
        ((cond1 == this.cond1 && cond2 == this.cond2) ||
            (cond1 == this.cond2 && cond2 == this.cond1));
  }

  @override
  String toString() {
    if (value != null) return "$name: $value";

    switch (op) {
      case "AND":
        return "${cond1!.name} AND ${cond2!.name} => $name";
      case "OR":
        return "${cond1!.name} OR ${cond2!.name} => $name";
      case "XOR":
        return "${cond1!.name} XOR ${cond2!.name} => $name";
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

  int getMaxDigit() {
    return int.parse(_gates.keys
        .where((k) => k.startsWith('x'))
        .sorted()
        .reversed
        .first
        .replaceAll(RegExp('\\D'), ''));
  }

  @override
  void part2() {
    final maxDigit = getMaxDigit();
    final gates = _gates.values.toList();

    // the input file seems to use the ripple-carry adder, which is a
    // "simple" succession of full adders
    // see https://en.wikipedia.org/wiki/Adder_(electronics)#Full_adder
    // final List<Gate> carries = [];
    final List<Gate> adders = []; // 1 => maxdigit

    for (int i = 0; i <= maxDigit; i++) {
      final key = i.toString().padLeft(2, '0');

      final adder = gates.firstWhere(
          (g) => g.isResultOf(_gates['x$key']!, 'XOR', _gates['y$key']!));
      adders.add(adder);
    }

    Gate prevCarry = gates
        .firstWhere((g) => g.isResultOf(_gates['x00']!, 'AND', _gates['y00']!));
    List<String> erroneous = [];

    for (int i = 1; i <= maxDigit; i++) {
      final key = i.toString().padLeft(2, '0');
      final zGate = _gates["z$key"]!;

      if (!zGate.isResultOf(adders[i], "XOR", prevCarry)) {
        print("ohnoes: $zGate");
        print("expected: ${adders[i].name} XOR ${prevCarry.name}");

        // this fix is incomplete, there is one case where it doesn't work... and
        // the program crash
        // I fixed the input file manually and added the 2 remaining faulty values
        // to the result by hand -_-
        final swap =
            gates.firstWhere((g) => g.isResultOf(adders[i], "XOR", prevCarry));
        erroneous.addAll([zGate.name, swap.name]);

        for (final gate in gates) {
          if (gate.cond1 == zGate) {
            gate.cond1 = swap;
          }
          if (gate.cond2 == zGate) {
            gate.cond2 = swap;
          }
          if (gate.cond1 == swap) {
            gate.cond1 = zGate;
          }
          if (gate.cond2 == swap) {
            gate.cond2 = zGate;
          }
        }
      }

      Gate ck1 =
          gates.firstWhere((g) => g.isResultOf(adders[i], 'AND', prevCarry));
      Gate ck2 = gates.firstWhere(
          (g) => g.isResultOf(_gates["x$key"]!, "AND", _gates["y$key"]!));

      prevCarry = gates.firstWhere((g) => g.isResultOf(ck1, "OR", ck2));
    }

    erroneous.sort();
    print(erroneous.join(','));
  }
}
