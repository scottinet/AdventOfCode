import 'package:equatable/equatable.dart';

class MoleculeStep implements Equatable {
  final String molecule;
  final int step;

  MoleculeStep({required this.molecule, required this.step});

  @override
  List<Object?> get props => [molecule];

  @override
  bool? get stringify => false;
}
