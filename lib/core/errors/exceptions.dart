import 'package:dio/dio.dart';
import 'error_model.dart'; // Ensure this path is correct
import 'package:firebase_auth/firebase_auth.dart'; // Add this import


class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

// Network / Connection Exceptions
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

// Status Code Exceptions
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

class ConflictException extends ServerException { // Fixed 'Cofficient'
  ConflictException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel(
          status: 408, errorMessage: "Connection timed out"));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel(
          status: 408, errorMessage: "Send timed out"));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel(
          status: 408, errorMessage: "Receive timed out"));

    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel(
          status: 503, errorMessage: "No Internet Connection"));

    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel(
          status: 495, errorMessage: "Bad Certificate"));

    case DioExceptionType.cancel:
      throw CancelException(ErrorModel(
          status: 500, errorMessage: "Request Cancelled"));

    case DioExceptionType.badResponse:
      _handleBadResponse(e); // Helper function below
      break;

    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel(
          status: 500, errorMessage: "Unknown Error: ${e.message}"));
  }
}

void handleFirebaseException(FirebaseException e) {
  // Create a default ErrorModel from the Firebase message
  final errorModel = ErrorModel(
    status: 500, // Default status
    errorMessage: e.message ?? "Unknown Firebase Error",
  );

  switch (e.code) {
  // --- NETWORK ERRORS ---
    case 'network-request-failed':
      throw ConnectionErrorException(ErrorModel(
          status: 503,
          errorMessage: "No Internet Connection"
      ));

  // --- AUTH ERRORS (Login/Signup) ---
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      throw UnauthorizedException(ErrorModel(
          status: 401,
          errorMessage: "Invalid email or password"
      ));

    case 'email-already-in-use':
      throw ConflictException(ErrorModel(
          status: 409,
          errorMessage: "This email is already registered"
      ));

    case 'user-disabled':
      throw ForbiddenException(ErrorModel(
          status: 403,
          errorMessage: "This account has been disabled"
      ));

    case 'too-many-requests':
      throw ServerException(ErrorModel(
          status: 429,
          errorMessage: "Too many attempts. Try again later."
      ));

    case 'invalid-email':
      throw BadResponseException(ErrorModel(
          status: 400,
          errorMessage: "The email address is badly formatted."
      ));

  // --- DEFAULT ---
    default:
      throw ServerException(errorModel);
  }
}

// Helper to separate logic and clean up the switch case
void _handleBadResponse(DioException e) {
  // 1. Check if response exists
  final statusCode = e.response?.statusCode ?? 500;
  final dynamic data = e.response?.data;

  // 2. Try to parse the server error, or use a default message if parsing fails
  ErrorModel errorModel;
  try {
    // If data is a Map, parse it. If it's a string, wrap it.
    if (data is Map<String, dynamic>) {
      errorModel = ErrorModel.fromJson(data);
    } else {
      errorModel = ErrorModel(status: statusCode, errorMessage: data.toString());
    }
  } catch (_) {
    errorModel = ErrorModel(status: statusCode, errorMessage: "An error occurred");
  }

  // 3. Throw specific exception based on Status Code
  switch (statusCode) {
    case 400:
    case 422: // Unprocessable Entity (Common validation error)
      throw BadResponseException(errorModel);
    case 401:
      throw UnauthorizedException(errorModel);
    case 403:
      throw ForbiddenException(errorModel);
    case 404:
      throw NotFoundException(errorModel);
    case 409: // Conflict
      throw ConflictException(errorModel);
    case 504: // Gateway Timeout
      throw ConnectionTimeoutException(errorModel);
    default:
    // Handle 500, 502, etc.
      throw BadResponseException(errorModel);
  }
}