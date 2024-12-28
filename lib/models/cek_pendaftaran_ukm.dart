class UkmPendaftaranModel {
  final String namaUkm;
  final String logoUkm;
  final String status;

  UkmPendaftaranModel({
    required this.namaUkm,
    required this.logoUkm,
    required this.status,
  });

  factory UkmPendaftaranModel.fromJson(Map<String, dynamic> json) {
    return UkmPendaftaranModel(
      namaUkm: json['nama_ukm'] ?? '',
      logoUkm: json['logo_ukm'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_ukm': namaUkm,
      'logo_ukm': logoUkm,
      'status': status,
    };
  }
}