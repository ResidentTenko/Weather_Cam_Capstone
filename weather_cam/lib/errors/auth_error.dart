import 'package:equatable/equatable.dart';

class AuthError extends Equatable {
  // code, message, and plugin are all related to the firebase exception

  final String code;
  final String message;
  final String plugin;
  const AuthError({
    this.code = '',
    this.message = '',
    this.plugin = '',
  });

  @override
  List<Object> get props => [code, message, plugin];

  @override
  String toString() =>
      'AuthError(code: $code, message: $message, plugin: $plugin)';
}
