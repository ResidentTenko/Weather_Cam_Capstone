// ignore_for_file: public_member_api_docs, sort_constructors_first
class HttpErrorStatusException implements Exception {
  final String responseMessage;

  HttpErrorStatusException({
    required this.responseMessage,
  });

  @override
  String toString() =>
      '(HttpErrorStatusException : Response Message: $responseMessage)';
}


