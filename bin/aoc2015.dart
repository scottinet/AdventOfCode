import 'dart:convert';
import 'dart:io';

import 'package:aoc2015/models/runnable.model.dart';
import 'day01/day01.dart';
import 'day02/day02.dart';
import 'day03/day03.dart';
import 'day04/day04.dart';
import 'day05/day05.dart';
import 'day06/day06.dart';

Map<String, Runnable> dayRunners = {
  'day01': Day01(),
  'day02': Day02(),
  'day03': Day03(),
  'day04': Day04(),
  'day05': Day05(),
  'day06': Day06(),
};

void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart aoc2015.dart <day> <input file>');
    exit(1);
  }

  final runnable = dayRunners[args[0]];

  if (runnable == null) {
    print('Day ${args[0]} not found');
    exit(1);
  }

  final input =
      File('data/${args[0]}/${args[1]}').openRead().transform(utf8.decoder);

  await runnable.init(input);

  var stopwatch = Stopwatch()..start();
  await runnable.part1();
  stopwatch.stop();
  print('(part 1 elapsed time: ${stopwatch.elapsed.inMilliseconds}ms)');

  print('-'.padRight(40, '-'));

  stopwatch = Stopwatch()..start();
  await runnable.part2();
  stopwatch.stop();
  print('(part2 elapsed time: ${stopwatch.elapsed.inMilliseconds}ms)');
}
