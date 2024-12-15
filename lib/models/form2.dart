class DivisiModel {
  final int idDivisi;
  final String namaDivisi;
  final String? deskripsi;

  DivisiModel({
    required this.idDivisi,
    required this.namaDivisi,
    this.deskripsi,
  });

  factory DivisiModel.fromJson(Map<String, dynamic> json) {
    return DivisiModel(
      idDivisi: int.parse(json['id_divisi'].toString()),
      namaDivisi: json['nama_divisi'] ?? '',
      deskripsi: json['deskripsi'],
    );
  }
}

class PendaftaranTahap2Request {
  final String idUkm;
  final String divisiPilihan1;
  final String divisiPilihan2;

  PendaftaranTahap2Request({
    required this.idUkm,
    required this.divisiPilihan1,
    required this.divisiPilihan2,
  });

  Map<String, String> toJson() {
    return {
      'id_ukm': idUkm,
      'divisi_pilihan_1': divisiPilihan1,
      'divisi_pilihan_2': divisiPilihan2,
    };
  }
}

class ApiResponse {
  final String status;
  final String? message;
  final dynamic data;

  ApiResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? '',
      message: json['message'],
      data: json['data'],
    );
  }

  bool get isSuccess => status == 'success';
}