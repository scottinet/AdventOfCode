import 'dart:math';

final _ingredientParseRxp = RegExp(
    r'(\w+): capacity ([-\d]+), durability ([-\d]+), flavor ([-\d]+), texture ([-\d]+), calories ([-\d]+)');

class Ingredient {
  final String name;
  final int capacity;
  final int durability;
  final int flavor;
  final int texture;
  final int calories;

  Ingredient(
      {required this.name,
      required this.capacity,
      required this.durability,
      required this.flavor,
      required this.texture,
      required this.calories});

  static Ingredient from(String input) {
    final matches = _ingredientParseRxp.allMatches(input);
    final [name, capacity, durability, flavor, texture, calories] =
        matches.first.groups([1, 2, 3, 4, 5, 6]);

    return Ingredient(
        name: name!,
        capacity: int.parse(capacity!),
        durability: int.parse(durability!),
        flavor: int.parse(flavor!),
        texture: int.parse(texture!),
        calories: int.parse(calories!));
  }
}

class MixedIngredients {
  final Map<Ingredient, int> mix;
  final int? wantedCalories;
  int? _score;

  MixedIngredients({required this.mix, this.wantedCalories});

  int get score {
    if (_score != null) return _score!;

    if (mix.isEmpty) {
      _score = -1;
    } else {
      int capacity = 0;
      int durability = 0;
      int flavor = 0;
      int texture = 0;
      int calories = 0;

      for (final MapEntry(key: ingredient, value: qty) in mix.entries) {
        capacity += ingredient.capacity * qty;
        durability += ingredient.durability * qty;
        flavor += ingredient.flavor * qty;
        texture += ingredient.texture * qty;
        calories += ingredient.calories * qty;
      }

      if (wantedCalories != null && calories != wantedCalories) {
        _score = 0;
      } else {
        _score = max<int>(capacity, 0) *
            max<int>(durability, 0) *
            max<int>(flavor, 0) *
            max<int>(texture, 0);
      }
    }

    return _score!;
  }
}
