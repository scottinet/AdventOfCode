import 'dart:async';
import 'dart:convert';
import 'package:aoc2015/runnable.dart';
import 'package:collection/collection.dart';
import './ingredient.dart';

class Y2015Day15 implements Runnable {
  final _ingredients = <Ingredient>[];

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _ingredients.addAll(lines.map((l) => Ingredient.from(l)));
  }

  @override
  FutureOr<void> part1() {
    final best = _findBestMix(_ingredients, 100);

    print('Recipe: ');

    for (final MapEntry(key: ingredient, value: qty) in best.mix.entries) {
      print(
          '\t- $qty teaspoon${qty > 1 ? 's' : ''} of ${ingredient.name.toLowerCase()}');
    }

    print('Score: ${best.score}');
  }

  @override
  FutureOr<void> part2() {}

  MixedIngredients _findBestMix(List<Ingredient> ingredients, int quantity,
      [Map<Ingredient, int>? currentMix]) {
    var bestMix = MixedIngredients(mix: {});

    if (ingredients.isEmpty || quantity == 0) return bestMix;

    final first = ingredients[0];
    final remaining = ingredients.slice(1);

    for (int i = 0; i <= quantity; i++) {
      Map<Ingredient, int> current = {first: quantity - i};

      if (currentMix != null) current.addAll(currentMix);
      current.addAll(_findBestMix(remaining, i, current).mix);

      final mix = MixedIngredients(mix: current);
      if (bestMix.score < mix.score) bestMix = mix;
    }

    return bestMix;
  }
}
