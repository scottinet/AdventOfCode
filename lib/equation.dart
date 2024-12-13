/// Linear equation solver using the Gauss-Jordan elimination algorithm
///
/// The input should be a matrix where:
///   - each column but the last is a term to be found
///   - the last column is the result for each equation
///   - each line is an equation
///
/// See https://fr.wikipedia.org/wiki/%C3%89limination_de_Gauss-Jordan
List<num> solveEquations(List<List<num>> matrix) {
  int r = -1;

  for (int j = 0; r < matrix.length - 1 && j < matrix[0].length; j++) {
    int k = r + 1;
    num maxVal = matrix[k][j].abs();

    for (int i = r + 2; i < matrix.length; i++) {
      if (matrix[i][j].abs() > maxVal) {
        k = i;
        maxVal = matrix[i][j].abs();
      }
    }

    if (matrix[k][j] == 0) continue;

    r++;

    final divider = matrix[k][j];
    matrix[k] = matrix[k].map((val) => (val / divider)).toList();

    if (r != k) {
      final temp = matrix[r];
      matrix[r] = matrix[k];
      matrix[k] = temp;
    }

    for (int i = 0; i < matrix.length; i++) {
      if (i != r) {
        final multiplier = matrix[i][j];
        for (int l = 0; l < matrix[0].length; l++) {
          matrix[i][l] = matrix[i][l] - (matrix[r][l] * multiplier);
        }
      }
    }
  }

  return matrix.map((row) => row[matrix[0].length - 1]).toList();
}
