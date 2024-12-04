import 'dart:convert';
import 'dart:io';

import 'package:advent_of_code/runnable.dart';
import 'bin/2024/day01/day01.dart';
import 'bin/2024/day02/day02.dart';
import 'bin/2024/day03/day03.dart';
import 'bin/2024/day04/day04.dart';

Map<String, Runnable> dayRunners = {
  'day01': Y2024Day01(),
  'day02': Y2024Day02(),
  'day03': Y2024Day03(),
  'day04': Y2024Day04(),
};

void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart aoc2024.dart <day> <input file>');
    exit(1);
  }

  final runnable = dayRunners[args[0]];

  if (runnable == null) {
    print('Day ${args[0]} not found');
    exit(1);
  }

  final input = File('bin/2024/${args[0]}/data/${args[1]}')
      .openRead()
      .transform(utf8.decoder);

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
