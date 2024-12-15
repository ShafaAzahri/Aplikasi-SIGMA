class RegistrationPeriodResponse {
  final bool status;
  final bool isOpen;
  final RegistrationPeriodData? data;
  final String? message;

  RegistrationPeriodResponse({
    required this.status,
    required this.isOpen,
    this.data,
    this.message,
  });

  factory RegistrationPeriodResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationPeriodResponse(
      status: json['status'] == 'success',
      isOpen: json['is_open'] ?? false,
      data: json['data'] != null ? RegistrationPeriodData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class RegistrationPeriodData {
  final int idPeriode;
  final String tanggalTutup;
  final int batasWaktuTahap1;
  final int batasWaktuTahap2;
  final int batasWaktuTahap3;

  RegistrationPeriodData({
    required this.idPeriode,
    required this.tanggalTutup,
    required this.batasWaktuTahap1,
    required this.batasWaktuTahap2,
    required this.batasWaktuTahap3,
  });

  factory RegistrationPeriodData.fromJson(Map<String, dynamic> json) {
    return RegistrationPeriodData(
      idPeriode: json['id_periode'] ?? 0,
      tanggalTutup: json['tanggal_tutup'] ?? '',
      batasWaktuTahap1: json['batas_waktu_tahap1'] ?? 0,
      batasWaktuTahap2: json['batas_waktu_tahap2'] ?? 0,
      batasWaktuTahap3: json['batas_waktu_tahap3'] ?? 0,
    );
  }
}