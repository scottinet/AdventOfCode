import 'dart:convert';
import 'dart:io';

import 'package:advent_of_code/runnable.dart';
import 'bin/2024/day01/day01.dart';
import 'bin/2024/day02/day02.dart';
import 'bin/2024/day03/day03.dart';
import 'bin/2024/day04/day04.dart';
import 'bin/2024/day05/day05.dart';
import 'bin/2024/day06/day06.dart';
import 'bin/2024/day07/day07.dart';
import 'bin/2024/day08/day08.dart';
import 'bin/2024/day09/day09.dart';
import 'bin/2024/day10/day10.dart';
import 'bin/2024/day11/day11.dart';
import 'bin/2024/day12/day12.dart';

Map<String, Runnable> dayRunners = {
  'day01': Y2024Day01(),
  'day02': Y2024Day02(),
  'day03': Y2024Day03(),
  'day04': Y2024Day04(),
  'day05': Y2024Day05(),
  'day06': Y2024Day06(),
  'day07': Y2024Day07(),
  'day08': Y2024Day08(),
  'day09': Y2024Day09(),
  'day10': Y2024Day10(),
  'day11': Y2024Day11(),
  'day12': Y2024Day12(),
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
  print('(part 1 elapsed time: ${stopwatch.elapsed.inMicroseconds / 1000}ms)');

  print('-'.padRight(40, '-'));

  stopwatch = Stopwatch()..start();
  await runnable.part2();
  stopwatch.stop();
  print('(part 2 elapsed time: ${stopwatch.elapsed.inMicroseconds / 1000}ms)');
}
