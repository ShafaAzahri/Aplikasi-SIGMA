class EditProfileModel {
  final String? nama;
  final String? jenisKelamin;
  final String? kelas;
  final String? alamat;
  final String? noWhatsapp;
  final String? email;

  EditProfileModel({
    this.nama,
    this.jenisKelamin,
    this.kelas,
    this.alamat,
    this.noWhatsapp,
    this.email,
  });

  Map<String, String> toJson() {
    final Map<String, String> data = {};
    
    if (nama != null) data['nama'] = nama!;
    if (jenisKelamin != null) data['jenis_kelamin'] = jenisKelamin!;
    if (kelas != null) data['kelas'] = kelas!;
    if (alamat != null) data['alamat'] = alamat!;
    if (noWhatsapp != null) data['no_whatsapp'] = noWhatsapp!;
    if (email != null) data['email'] = email!;
    
    return data;
  }
}