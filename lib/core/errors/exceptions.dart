import 'package:dio/dio.dart';
import 'error_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class ConflictException extends ServerException {
  ConflictException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(
        ErrorModel(status: 408, errorMessage: "Connection timed out"),
      );

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(
        ErrorModel(status: 408, errorMessage: "Send timed out"),
      );

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(
        ErrorModel(status: 408, errorMessage: "Receive timed out"),
      );

    case DioExceptionType.connectionError:
      throw ConnectionErrorException(
        ErrorModel(status: 503, errorMessage: "No Internet Connection"),
      );

    case DioExceptionType.badCertificate:
      throw BadCertificateException(
        ErrorModel(status: 495, errorMessage: "Bad Certificate"),
      );

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(status: 500, errorMessage: "Request Cancelled"),
      );

    case DioExceptionType.badResponse:
      _handleBadResponse(e);
      break;

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(status: 500, errorMessage: "Unknown Error: ${e.message}"),
      );
  }
}

void handleFirebaseException(FirebaseException e) {
  final errorModel = ErrorModel(
    status: 500,
    errorMessage: e.message ?? "Unknown Firebase Error",
  );

  switch (e.code) {
    case 'network-request-failed':
      throw ConnectionErrorException(
        ErrorModel(status: 503, errorMessage: "No Internet Connection"),
      );

    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      throw UnauthorizedException(
        ErrorModel(status: 401, errorMessage: "Invalid email or password"),
      );

    case 'email-already-in-use':
      throw ConflictException(
        ErrorModel(
          status: 409,
          errorMessage: "This email is already registered",
        ),
      );

    case 'user-disabled':
      throw ForbiddenException(
        ErrorModel(status: 403, errorMessage: "This account has been disabled"),
      );

    case 'too-many-requests':
      throw ServerException(
        ErrorModel(
          status: 429,
          errorMessage: "Too many attempts. Try again later.",
        ),
      );

    case 'invalid-email':
      throw BadResponseException(
        ErrorModel(
          status: 400,
          errorMessage: "The email address is badly formatted.",
        ),
      );

    default:
      throw ServerException(errorModel);
  }
}

void _handleBadResponse(DioException e) {
  final statusCode = e.response?.statusCode ?? 500;
  final dynamic data = e.response?.data;

  ErrorModel errorModel;
  try {
    if (data is Map<String, dynamic>) {
      errorModel = ErrorModel.fromJson(data);
    } else {
      errorModel = ErrorModel(
        status: statusCode,
        errorMessage: data.toString(),
      );
    }
  } catch (_) {
    errorModel = ErrorModel(
      status: statusCode,
      errorMessage: "An error occurred",
    );
  }

  switch (statusCode) {
    case 400:
    case 422:
      throw BadResponseException(errorModel);
    case 401:
      throw UnauthorizedException(errorModel);
    case 403:
      throw ForbiddenException(errorModel);
    case 404:
      throw NotFoundException(errorModel);
    case 409:
      throw ConflictException(errorModel);
    case 504:
      throw ConnectionTimeoutException(errorModel);
    default:
      throw BadResponseException(errorModel);
  }
}
