class UkmDetailNotRegistered {
  final UkmData ukmDetail;
  final List<StrukturOrganisasi> strukturOrganisasi;
  final List<Timeline> timeline;

  UkmDetailNotRegistered({
    required this.ukmDetail,
    required this.strukturOrganisasi,
    required this.timeline,
  });

  factory UkmDetailNotRegistered.fromJson(Map<String, dynamic> json) {
    return UkmDetailNotRegistered(
      ukmDetail: UkmData.fromJson(json['ukm_detail']),
      strukturOrganisasi: (json['struktur_organisasi'] as List)
          .map((data) => StrukturOrganisasi.fromJson(data))
          .toList(),
      timeline: (json['timeline'] as List)
          .map((data) => Timeline.fromJson(data))
          .toList(),
    );
  }
}

class UkmData {
  final int idUkm;
  final String namaUkm;
  final String bannerPath;
  final String deskripsi;
  final String visi;
  final String misi;

  UkmData({
    required this.idUkm,
    required this.namaUkm,
    required this.bannerPath,
    required this.deskripsi,
    required this.visi,
    required this.misi,
  });

  factory UkmData.fromJson(Map<String, dynamic> json) {
    return UkmData(
      idUkm: json['id_ukm'] ?? 0,
      namaUkm: json['nama_ukm'] ?? '',
      bannerPath: json['banner_path'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      visi: json['visi'] ?? '',
      misi: json['misi'] ?? '',
    );
  }
}

class StrukturOrganisasi {
  final String namaLengkap;
  final String namaJabatan;
  final int jabatanHierarki;
  final String fotoPath;
  final String tahunMulai;
  final String tahunSelesai;
  final String namaDivisi;
  final int divisiHierarki;

  StrukturOrganisasi({
    required this.namaLengkap,
    required this.namaJabatan,
    required this.jabatanHierarki,
    required this.fotoPath,
    required this.tahunMulai,
    required this.tahunSelesai,
    required this.namaDivisi,
    required this.divisiHierarki,
  });

  factory StrukturOrganisasi.fromJson(Map<String, dynamic> json) {
    return StrukturOrganisasi(
      namaLengkap: json['nama_lengkap'] ?? '',
      namaJabatan: json['nama_jabatan'] ?? '',
      jabatanHierarki: json['jabatan_hierarki'] ?? 0,
      fotoPath: json['foto_path'] ?? '',
      tahunMulai: json['tahun_mulai'] ?? '',
      tahunSelesai: json['tahun_selesai'] ?? '',
      namaDivisi: json['nama_divisi'] ?? '',
      divisiHierarki: json['divisi_hierarki'] ?? 0,
    );
  }
}

class Timeline {
  final int idTimeline;
  final String judulKegiatan;
  final String deskripsi;
  final String tanggalKegiatan;
  final String waktuMulai;
  final String waktuSelesai;
  final String imagePath;
  final String jenis;

  Timeline({
    required this.idTimeline,
    required this.judulKegiatan,
    required this.deskripsi,
    required this.tanggalKegiatan,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.imagePath,
    required this.jenis,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      idTimeline: json['id_timeline'] ?? 0,
      judulKegiatan: json['judul_kegiatan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tanggalKegiatan: json['tanggal_kegiatan'] ?? '',
      waktuMulai: json['waktu_mulai'] ?? '',
      waktuSelesai: json['waktu_selesai'] ?? '',
      imagePath: json['image_path'] ?? '',
      jenis: json['jenis'] ?? '',
    );
  }
}