import '../databases/api/end_points.dart';

class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});
  factory ErrorModel.fromJson(Map jsonData) {
    return ErrorModel(
      errorMessage: jsonData[ApiKey.statusMessage] ?? "Unknown Error",
      status: jsonData[ApiKey.status] is int
          ? jsonData[ApiKey.status]
          : int.tryParse(jsonData[ApiKey.status].toString()) ?? 0,
    );
  }
}
