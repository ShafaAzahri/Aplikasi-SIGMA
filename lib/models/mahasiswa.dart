class MahasiswaModel {
  final String nim;
  final String namaLengkap;
  final int? idProgramStudi;  // Nullable int karena bisa null di database
  final String? kelas;
  final String? jenisKelamin; // enum di database
  final String? alamat;
  final String? noWhatsapp;
  final String? email;
  final String? fotoPath;

  MahasiswaModel({
    required this.nim,
    required this.namaLengkap,
    this.idProgramStudi,
    this.kelas,
    this.jenisKelamin,
    this.alamat,
    this.noWhatsapp,
    this.email,
    this.fotoPath,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nim: json['nim'].toString(),
      namaLengkap: json['nama_lengkap'] ?? '',
      idProgramStudi: json['id_program_studi'] != null ? int.parse(json['id_program_studi'].toString()) : null,
      kelas: json['kelas'],
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
      noWhatsapp: json['no_whatsapp'],
      email: json['email'],
      fotoPath: json['foto_path'] ?? 'profile_default.jpg',
    );
  }
}