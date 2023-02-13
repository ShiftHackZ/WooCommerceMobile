class ApiResponse<T extends Object> {
  final int code;
  final T data;
  final String error;

  ApiResponse(this.code, this.data, this.error);
}
