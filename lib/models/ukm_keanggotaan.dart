class UkmKeanggotaanModel {
  final String namaUkm;
  final String? logoUkm;
  final String status;
  final String statusPeriode;
  final String periode;

  UkmKeanggotaanModel({
    required this.namaUkm,
    this.logoUkm,
    required this.status,
    required this.statusPeriode,
    required this.periode,
  });

  factory UkmKeanggotaanModel.fromJson(Map<String, dynamic> json) {
    return UkmKeanggotaanModel(
      namaUkm: json['nama_ukm'] ?? '',
      logoUkm: json['logo_ukm'],
      status: json['status'] ?? 'anggota',
      statusPeriode: json['status_periode'] ?? 'tidak aktif',
      periode: json['periode'] ?? '',  // Langsung ambil periode dari response
    );
  }
}