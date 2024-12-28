class PhotoResponse {
  final String status;
  final String message;

  PhotoResponse({
    required this.status,
    required this.message,
  });

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? 'Unknown error occurred',
    );
  }

  bool get isSuccess => status == 'success';
}