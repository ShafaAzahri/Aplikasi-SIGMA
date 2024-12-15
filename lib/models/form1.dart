class MahasiswaFormResponse {
  final bool status;
  final MahasiswaFormData? data;
  final String? message;

  MahasiswaFormResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory MahasiswaFormResponse.fromJson(Map<String, dynamic> json) {
    return MahasiswaFormResponse(
      status: json['status'] == 'success',
      data: json['data'] != null ? MahasiswaFormData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class MahasiswaFormData {
  final String nim;
  final String namaLengkap;
  final String programStudi;
  final String kelas;
  final String jenisKelamin;
  final String alamat;
  final String noWhatsapp;
  final String email;

  MahasiswaFormData({
    required this.nim,
    required this.namaLengkap,
    required this.programStudi,
    required this.kelas,
    required this.jenisKelamin,
    required this.alamat,
    required this.noWhatsapp,
    required this.email,
  });

  factory MahasiswaFormData.fromJson(Map<String, dynamic> json) {
    return MahasiswaFormData(
      nim: json['nim'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      programStudi: json['program_studi'] ?? '',
      kelas: json['kelas'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      alamat: json['alamat'] ?? '',
      noWhatsapp: json['no_whatsapp'] ?? '',
      email: json['email'] ?? '',
    );
  }
}