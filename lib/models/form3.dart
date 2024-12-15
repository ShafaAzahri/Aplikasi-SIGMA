class SubmitTahap3Response {
  final bool status;
  final String message;

  SubmitTahap3Response({
    required this.status,
    required this.message,
  });

  factory SubmitTahap3Response.fromJson(Map<String, dynamic> json) {
    return SubmitTahap3Response(
      status: json['status'] == 'success',
      message: json['message'] ?? '',
    );
  }
}