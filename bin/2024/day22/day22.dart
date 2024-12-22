import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

final class Y2024Day22 extends Runnable {
  final List<int> _secrets = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _secrets.addAll(lines.map((l) => int.parse(l)));
  }

  int getNextSecret(int secret) {
    const int prune = 16777216;

    secret = (secret ^ (secret * 64)) % prune;
    secret = (secret ^ (secret ~/ 32)) % prune;
    secret = (secret ^ (secret * 2048)) % prune;

    return secret;
  }

  @override
  void part1() {
    var total = 0;

    for (final secret in _secrets) {
      var next = secret;
      for (var i = 0; i < 2000; i++, next = getNextSecret(next)) {}
      total += next;
    }

    print("Sum of secret numbers: $total");
  }

  List<Map<(int, int, int, int), int>> getSequences() {
    final List<Map<(int, int, int, int), int>> sequences = [];

    for (final secret in _secrets) {
      var next = secret, prev = secret % 10;
      sequences.add({});
      final List<int> diffs = [];

      for (var i = 0; i < 2000; i++) {
        next = getNextSecret(next);
        final price = next % 10;
        diffs.add(price - prev);

        if (diffs.length >= 4) {
          final seq = diffs.slice(diffs.length - 4);
          final candidate = (seq[0], seq[1], seq[2], seq[3]);

          if (!sequences[sequences.length - 1].containsKey(candidate)) {
            sequences[sequences.length - 1][candidate] = price;
          }
        }

        prev = price;
      }
    }

    return sequences;
  }

  @override
  void part2() {
    int best = 0;
    final sequences = getSequences();
    final Set<(int, int, int, int)> keys =
        Set<(int, int, int, int)>.from(sequences.map((s) => s.keys).flattened);

    for (final key in keys) {
      int score = 0;

      for (int i = 0; i < sequences.length; i++) {
        score += sequences[i][key] ?? 0;
      }

      best = max(best, score);
    }

    print("Best: $best");
  }
}
