// ignore_for_file: public_member_api_docs, sort_constructors_first
class GenericError implements Exception {
  final dynamic message;
  const GenericError({
    required this.message,
  });

  @override
  String toString() => 'GenericError(message: $message)';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory GenericError.fromJson(Map<String, dynamic> json) {
    return GenericError(
      message: json['message'] as dynamic,
    );
  }
}