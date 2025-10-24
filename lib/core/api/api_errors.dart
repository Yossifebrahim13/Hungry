class ApiErrors {
  final String message;
  final int? statusCode;

  ApiErrors({required this.message, this.statusCode});
  @override
  String toString() => message;
}
