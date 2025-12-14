sealed class ApiResponse<T> {}

class Success<T> extends ApiResponse<T> {
  final T data;
  Success(this.data);
}

class ApiError<T> extends ApiResponse<T> {
  final String message;
  ApiError(this.message);
}
