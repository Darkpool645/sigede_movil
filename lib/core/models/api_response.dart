class ApiResponse<T> {
  final T? data;
  final bool error;
  final int statusCode;
  final String message;

  ApiResponse({
    required this.data,
    required this.error,
    required this.statusCode,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] ?? false,
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? '',
    );
  }
}