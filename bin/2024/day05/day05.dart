import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:advent_of_code/runnable.dart';

class Y2024Day05 extends Runnable {
  List<String> input = [];
  // In that order: page => required (inverted from input)
  final Map<int, List<int>> rules = {};
  final List<List<int>> toProduce = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    bool isRule = true;

    for (final line in lines) {
      if (line.trim().isEmpty) {
        isRule = false;
      } else if (isRule) {
        final [required, page] = line.split('|').map(int.parse).toList();

        rules[page] ??= [];
        rules[page]!.add(required);
      } else {
        toProduce.add(line.split(',').map(int.parse).toList());
      }
    }
  }

  int _getInvalidIndex(List<int> update) {
    final Set<int> required = {};
    bool correct = true;

    for (int i = 0; correct && i < update.length; i++) {
      if (required.contains(update[i])) {
        return i;
      } else {
        required.addAll(rules[update[i]] ?? []);
      }
    }

    return -1;
  }

  @override
  void part1() {
    int middlePagesSum = 0;

    for (final update in toProduce) {
      if (_getInvalidIndex(update) == -1) {
        middlePagesSum += update[(update.length ~/ 2)];
      }
    }

    print("Sum of correct middle pages: $middlePagesSum");
  }

  @override
  void part2() {
    int fixedMiddlePagesSum = 0;

    for (final update in toProduce) {
      int invalidIndex;
      List<int> fixed = List.from(update);

      while ((invalidIndex = _getInvalidIndex(fixed)) != -1) {
        final invalidValue = fixed[invalidIndex];
        int newIndex =
            update.indexWhere((v) => rules[v]?.contains(invalidValue) == true);

        fixed.removeAt(invalidIndex);
        fixed.insert(newIndex, invalidValue);
      }

      if (!update.equals(fixed)) {
        fixedMiddlePagesSum += fixed[fixed.length ~/ 2];
      }
    }

    print("Sum of fixed lists: $fixedMiddlePagesSum");
  }
}
