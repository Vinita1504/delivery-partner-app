/// Generic API response wrapper for consistent response handling
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  /// Create a successful response
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Create a failed response
  factory ApiResponse.failure({String? message, int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Parse from JSON map
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    final success =
        json['success'] as bool? ??
        (json['status'] == 'success') ||
            (json['statusCode'] != null && (json['statusCode'] as int) < 400);

    return ApiResponse(
      success: success,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode, data: $data)';
  }
}

/// Paginated API response for list endpoints
class PaginatedApiResponse<T> {
  final bool success;
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String? message;

  const PaginatedApiResponse({
    required this.success,
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.message,
  });

  /// Check if there are more pages
  bool get hasNextPage => currentPage < totalPages;

  /// Check if there are previous pages
  bool get hasPreviousPage => currentPage > 1;

  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList =
        (json['data'] as List<dynamic>?)
            ?.map((item) => fromJsonT(item as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedApiResponse(
      success: json['success'] as bool? ?? true,
      data: dataList,
      currentPage: json['currentPage'] as int? ?? json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems:
          json['totalItems'] as int? ??
          json['total'] as int? ??
          dataList.length,
      message: json['message'] as String?,
    );
  }
}
