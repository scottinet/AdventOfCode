import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

final class Y2024Day22 extends Runnable {
  final List<int> secrets = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    secrets.addAll(lines.map((l) => int.parse(l)));
  }

  @override
  void part1() {
    const int prune = 16777216;
    var total = 0;

    for (final secret in secrets) {
      var next = secret;

      for (var i = 0; i < 2000; i++) {
        next = (next ^ (next * 64)) % prune;
        next = (next ^ (next ~/ 32)) % prune;
        next = (next ^ (next * 2048)) % prune;
      }

      total += next;
    }

    print("Sum of secret numbers: $total");
  }

  @override
  void part2() {}
}
