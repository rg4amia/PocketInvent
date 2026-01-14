/// Exception thrown when attempting to sell a phone that is already sold
/// and has not been returned yet.
class SaleBlockedException implements Exception {
  final String message;

  SaleBlockedException(this.message);

  @override
  String toString() => 'SaleBlockedException: $message';
}

/// Exception thrown when attempting to create a return for a phone
/// that is not in the "Vendu" (sold) status.
class InvalidReturnException implements Exception {
  final String message;

  InvalidReturnException(this.message);

  @override
  String toString() => 'InvalidReturnException: $message';
}

/// Exception thrown when there is insufficient data to complete
/// a transaction operation.
class InsufficientDataException implements Exception {
  final String message;

  InsufficientDataException(this.message);

  @override
  String toString() => 'InsufficientDataException: $message';
}
