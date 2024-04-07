final _auntSueRxp = RegExp(r'Sue (\d+): (.+)');
final _compoundRxp = RegExp(r'(\w+): (\d+)');

class AuntSue {
  final int number;
  final Map<String, int> compounds;

  AuntSue({required this.number, required this.compounds});

  static AuntSue from(String input) {
    final [number, compoundsStr] =
        _auntSueRxp.allMatches(input).first.groups([1, 2]);
    final Map<String, int> compounds = {};

    for (final c in compoundsStr!.split(',')) {
      final [name, count] = _compoundRxp.allMatches(c).first.groups([1, 2]);
      compounds[name!] = int.parse(count!);
    }

    return AuntSue(number: int.parse(number!), compounds: compounds);
  }
}
