class TimelineModel {
  final String judulKegiatan;
  final String imagePath;

  TimelineModel({
    required this.judulKegiatan,
    required this.imagePath,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      judulKegiatan: json['judul_kegiatan'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }
}