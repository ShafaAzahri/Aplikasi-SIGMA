class UkmModel {
  final String idUkm;
  final String namaUkm;
  final String deskripsi;
  final String logo;
  final String tahunMulai;
  final String tahunSelesai;

  UkmModel({
    required this.idUkm,
    required this.namaUkm,
    required this.deskripsi,
    required this.logo,
    required this.tahunMulai,
    required this.tahunSelesai,
  });

  factory UkmModel.fromJson(Map<String, dynamic> json) {
    return UkmModel(
      idUkm: json['id_ukm'].toString(),
      namaUkm: json['nama_ukm'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      logo: json['logo_path'] ?? '', 
      tahunMulai: json['tahun_mulai'] ?? '',
      tahunSelesai: json['tahun_selesai'] ?? '',
    );
  }
}