class Operation {
  /// Can be one of the following:
  /// NOOP, NOT, AND, OR, LSHIFT, RSHIFT
  String op;
  String lhs;
  String? rhs;

  Operation({required this.lhs, required this.op, this.rhs});
}
