import 'package:intl/intl.dart';

class UkmDetail {
  final String bannerPath;
  final List<TimelineModel> proker;
  final List<TimelineModel> agenda;

  UkmDetail({
    required this.bannerPath,
    required this.proker,
    required this.agenda,
  });

  factory UkmDetail.fromJson(Map<String, dynamic> json) {
    return UkmDetail(
      // Ubah ini untuk menerima string langsung
      bannerPath: json['banner'] ?? '',  // Ubah dari json['banner']['banner_path']
      proker: ((json['proker'] as List?) ?? [])
          .map((e) => TimelineModel.fromJson(e))
          .toList(),
      agenda: ((json['agenda'] as List?) ?? [])
          .map((e) => TimelineModel.fromJson(e))
          .toList(),
    );
  }
}

class TimelineModel {
  final int idTimeline;
  final String judulKegiatan;
  final String deskripsi;
  final String tanggalKegiatan;
  final String waktuMulai;
  final String waktuSelesai;
  final String imagePath;
  final String jenis;
  final String status;
  final List<PanitiaModel> panitia;
  final List<RapatModel>? rapat;
  final List<DokumentasiModel>? dokumentasi;

  TimelineModel({
    required this.idTimeline,
    required this.judulKegiatan,
    required this.deskripsi,
    required this.tanggalKegiatan,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.imagePath,
    required this.jenis,
    required this.status,
    required this.panitia,
    this.rapat,
    this.dokumentasi,
  });

  String get formattedTanggal {
    try {
      final date = DateTime.parse(tanggalKegiatan);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return tanggalKegiatan;
    }
  }

  String get formattedWaktu {
    return '$waktuMulai - $waktuSelesai';
  }

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      idTimeline: json['id_timeline'] ?? 0,
      judulKegiatan: json['judul_kegiatan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tanggalKegiatan: json['tanggal_kegiatan'] ?? '',
      waktuMulai: json['waktu_mulai'] ?? '',
      waktuSelesai: json['waktu_selesai'] ?? '',
      imagePath: json['image_path'] ?? '',
      jenis: json['jenis'] ?? '',
      status: json['status'] ?? '',
      panitia: (json['panitia'] as List? ?? [])
          .map((e) => PanitiaModel.fromJson(e))
          .toList(),
      rapat: json['jenis'] == 'proker' && json['rapat'] != null
          ? (json['rapat'] as List).map((e) => RapatModel.fromJson(e)).toList()
          : null,
      dokumentasi: json['jenis'] == 'agenda' && json['dokumentasi'] != null
          ? (json['dokumentasi'] as List)
              .map((e) => DokumentasiModel.fromJson(e))
              .toList()
          : null,
    );
  }
}

class PanitiaModel {
  final String nama;
  final String jabatan;
  final int level;

  PanitiaModel({
    required this.nama,
    required this.jabatan,
    required this.level,
  });

  factory PanitiaModel.fromJson(Map<String, dynamic> json) {
    return PanitiaModel(
      nama: json['nama'] ?? '',
      jabatan: json['jabatan'] ?? '',
      level: json['level'] ?? 0,
    );
  }
}

class RapatModel {
  final int idRapat;
  final String judul;
  final String tanggal;
  final String notulensiPath;
  final List<DokumentasiModel> dokumentasi;

  RapatModel({
    required this.idRapat,
    required this.judul,
    required this.tanggal,
    required this.notulensiPath,
    required this.dokumentasi,
  });

  String get formattedTanggal {
    try {
      final date = DateTime.parse(tanggal);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return tanggal;
    }
  }

  factory RapatModel.fromJson(Map<String, dynamic> json) {
    return RapatModel(
      idRapat: json['id_rapat'] ?? 0,
      judul: json['judul'] ?? '',
      tanggal: json['tanggal'] ?? '',
      notulensiPath: json['notulensi_path'] ?? '',
      dokumentasi: (json['dokumentasi'] as List? ?? [])
          .map((e) => DokumentasiModel.fromJson(e))
          .toList(),
    );
  }
}

class DokumentasiModel {
  final String fotoPath;

  DokumentasiModel({
    required this.fotoPath,
  });

  factory DokumentasiModel.fromJson(Map<String, dynamic> json) {
    return DokumentasiModel(
      fotoPath: json['foto_path'] ?? '',
    );
  }
}