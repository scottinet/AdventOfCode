import 'dart:async';
import 'dart:convert';

import 'package:aoc2015/runnable.dart';

class Y2015Day12 implements Runnable {
  Map<String, dynamic> json = {};

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    var raw = await input.join();
    json = jsonDecode(raw);
  }

  num parseVal(dynamic v) {
    if (v is Map) return reduceMap(v);
    if (v is num) return v;
    if (v is String) return num.tryParse(v) ?? 0;
    if (v is List) return v.fold(0, (agg, value) => agg + parseVal(value));

    return 0;
  }

  num reduceMap(Map obj) {
    num val = 0;

    for (final v in obj.values) {
      val += parseVal(v);
    }

    return val;
  }

  @override
  FutureOr<void> part1() {
    final reduced = reduceMap(json);

    print('Reduced: $reduced');
  }

  @override
  FutureOr<void> part2() {}
}
