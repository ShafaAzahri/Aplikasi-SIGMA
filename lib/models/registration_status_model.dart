class RegistrationStatusResponse {
  final bool status;
  final RegistrationStatusData? data;

  RegistrationStatusResponse({
    required this.status,
    this.data,
  });

  factory RegistrationStatusResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationStatusResponse(
      status: json['status'] == 'success',
      data: json['data'] != null ? RegistrationStatusData.fromJson(json['data']) : null,
    );
  }
}

class RegistrationStatusData {
  final String status;
  final bool? isTahap2Valid;
  final bool? isTahap3Valid;
  final String? catatan;

  RegistrationStatusData({
    required this.status,
    this.isTahap2Valid,
    this.isTahap3Valid,
    this.catatan,
  });

  factory RegistrationStatusData.fromJson(Map<String, dynamic> json) {
    return RegistrationStatusData(
      status: json['status'] ?? 'BELUM_DAFTAR',
      isTahap2Valid: json['is_tahap2_valid'],
      isTahap3Valid: json['is_tahap3_valid'],
      catatan: json['catatan'],
    );
  }
}