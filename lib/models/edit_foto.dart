class PhotoModel {
  final String fotoPath;

  PhotoModel({
    required this.fotoPath,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      fotoPath: json['foto_path'] ?? '',
    );
  }
}