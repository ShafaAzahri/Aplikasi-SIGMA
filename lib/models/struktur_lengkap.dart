// models/struktur_lengkap.dart

class StrukturLengkapResponse {
  final UkmDetailStruktur ukmDetail;
  final List<StrukturOrganisasiLengkap> strukturOrganisasi;

  StrukturLengkapResponse({
    required this.ukmDetail,
    required this.strukturOrganisasi,
  });

  factory StrukturLengkapResponse.fromJson(Map<String, dynamic> json) {
    return StrukturLengkapResponse(
      ukmDetail: UkmDetailStruktur.fromJson(json['ukm_detail']),
      strukturOrganisasi: (json['struktur_organisasi'] as List)
          .map((item) => StrukturOrganisasiLengkap.fromJson(item))
          .toList(),
    );
  }
}

class UkmDetailStruktur {
  final int idUkm;
  final String namaUkm;
  final String bannerPath;

  UkmDetailStruktur({
    required this.idUkm,
    required this.namaUkm,
    required this.bannerPath,
  });

  factory UkmDetailStruktur.fromJson(Map<String, dynamic> json) {
    return UkmDetailStruktur(
      idUkm: json['id_ukm'],
      namaUkm: json['nama_ukm'],
      bannerPath: json['banner_path'],
    );
  }
}

class StrukturOrganisasiLengkap {
  final String namaLengkap;
  final String namaJabatan;
  final int jabatanHierarki;
  final String fotoPath;
  final String tahunMulai;
  final String tahunSelesai;
  final String namaDivisi;
  final int divisiHierarki;
  final String divisiDeskripsi;
  final int idDivisi;
  final int idUkm;

  StrukturOrganisasiLengkap({
    required this.namaLengkap,
    required this.namaJabatan,
    required this.jabatanHierarki,
    required this.fotoPath,
    required this.tahunMulai,
    required this.tahunSelesai,
    required this.namaDivisi,
    required this.divisiHierarki,
    required this.divisiDeskripsi,
    required this.idDivisi,
    required this.idUkm,
  });

  factory StrukturOrganisasiLengkap.fromJson(Map<String, dynamic> json) {
    return StrukturOrganisasiLengkap(
      namaLengkap: json['nama_lengkap'] ?? '',
      namaJabatan: json['nama_jabatan'] ?? '',
      jabatanHierarki: json['jabatan_hierarki'] ?? 0,
      fotoPath: json['foto_path'] ?? '',
      tahunMulai: json['tahun_mulai'] ?? '',
      tahunSelesai: json['tahun_selesai'] ?? '',
      namaDivisi: json['nama_divisi'] ?? '',
      divisiHierarki: json['divisi_hierarki'] ?? 0,
      divisiDeskripsi: json['divisi_deskripsi'] ?? '',
      idDivisi: json['id_divisi'] ?? 0,
      idUkm: json['id_ukm'] ?? 0,
    );
  }
}