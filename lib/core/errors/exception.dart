import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final String statusCode;

  @override
  // TODO: implement props
  List<Object?> get props => [
        message,
        statusCode,
      ];
}

class ChaceException extends Equatable implements Exception {
  const ChaceException({
    required this.message,
    this.statusCode = 500,
  });

  final String message;
  final int statusCode;

  @override
  // TODO: implement props
  List<Object?> get props => [
        message,
        statusCode,
      ];
}
