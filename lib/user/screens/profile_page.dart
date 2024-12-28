import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latihan/service/api_url.dart';
import 'package:latihan/user/util/navbar_function.dart';
import 'package:latihan/models/mahasiswa.dart';
import 'package:latihan/models/ukm_keanggotaan.dart';
import 'package:latihan/service/mahasiswa.dart';
import 'package:latihan/service/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latihan/service/edit_foto.dart';

// Tema warna
const Color creamColor = Color(0xFFFFF8DC);      // Cream
const Color deepCream = Color(0xFFDEB887);       // BurlyWood
const Color accentColor = Color(0xFF8B4513);     // SaddleBrown
const Color lightCream = Color(0xFFFAF3E0);      // Light cream for cards
const Color textColor = Color(0xFF4A4A4A);       // Dark gray for text

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProfileService _profileService = ProfileService();
  late Future<ProfileResponse> _profileFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _profileFuture = _profileService.getMahasiswaProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: creamColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Profil',
          style: TextStyle(
            color: accentColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: deepCream.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.edit_outlined, color: accentColor),
              onPressed: () => _showEditProfileOptions(),
            ),
          ),
        ],
      ),
      body: FutureBuilder<ProfileResponse>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: accentColor),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text(
                    'Data tidak tersedia',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final profileData = snapshot.data!;
          return Column(
            children: [
              _buildProfileHeader(profileData.profile),
              SizedBox(height: 20),
              _buildCustomTabBar(),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: lightCream,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUKMList(profileData.ukmAktif, isActive: true),
                      _buildUKMList(profileData.ukmHistori),
                      _buildPendingUKMList(),
                    ],
                  ),
                ),
              ),
              _buildLogoutButton(),
            ],
          );
        },
      ),
      bottomNavigationBar: buildBottomNavBar(2, context, _onNavBarTapped),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Gambar dengan gesture detector untuk zoom dan pan
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black87,
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Tombol close
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(MahasiswaModel profile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showFullScreenImage(
                  '${AppConfig.assetBaseUrl}/profile/${profile.fotoPath}',
                ),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: deepCream, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: 'profileImage',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: deepCream.withOpacity(0.2),
                      backgroundImage: NetworkImage(
                        '${AppConfig.assetBaseUrl}/profile/${profile.fotoPath}',
                      ),
                      onBackgroundImageError: (e, s) {
                        print('Error loading profile image: $e');
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 20, color: accentColor),
                    onPressed: () => _showImageEditOptions(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            profile.namaLengkap,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: deepCream.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: deepCream.withOpacity(0.3)),
            ),
            child: Text(
              profile.nim,
              style: TextStyle(
                fontSize: 16,
                color: accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        // Menggunakan indicator custom
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Color(0xFF161D6F), // Warna accent yang sama dengan tema aplikasi
            width: 3, // Ketebalan garis
          ),
          insets: EdgeInsets.symmetric(horizontal: 16), // Padding horizontal untuk garis
        ),
        labelColor: Color(0xFF161D6F), // Warna text saat aktif
        unselectedLabelColor: Colors.grey[600], // Warna text saat tidak aktif
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: [
          Tab(
            text: 'UKM Aktif',
            height: 46, // Tinggi tab yang konsisten
          ),
          Tab(
            text: 'Riwayat',
            height: 46,
          ),
          Tab(
            text: 'Pendaftaran',
            height: 46,
          ),
        ],
      ),
    );
  }

  Widget _buildUKMList(List<UkmKeanggotaanModel> ukms, {bool isActive = false}) {
    if (ukms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 64,
              color: deepCream.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada UKM',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: ukms.length,
      itemBuilder: (context, index) {
        final ukm = ukms[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: isActive ? () => _navigateToUKMDetail(ukm) : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: deepCream.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        '${AppConfig.assetBaseUrl}/${ukm.logoUkm}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, color: deepCream),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ukm.namaUkm,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Periode: ${ukm.periode}',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(ukm.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ukm.status,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(ukm.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Icon(
                      Icons.chevron_right,
                      color: accentColor,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.green;
      case 'tidak aktif':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPendingUKMList() {
    return FutureBuilder<ProfileResponse>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        }

        if (!snapshot.hasData || snapshot.data!.ukmPendaftaran.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 64,
                  color: deepCream.withOpacity(0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'Tidak ada pendaftaran yang sedang diproses',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.ukmPendaftaran.length,
          itemBuilder: (context, index) {
            final ukm = snapshot.data!.ukmPendaftaran[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: deepCream.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          '${AppConfig.assetBaseUrl}/${ukm.logoUkm}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, color: deepCream),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ukm.namaUkm,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPendingStatusColor(ukm.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getStatusText(ukm.status),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getPendingStatusColor(ukm.status),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getPendingStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING_TAHAP1':
      case 'PENDING_TAHAP2':
      case 'PENDING_TAHAP3':
        return Colors.orange;
      case 'ACC_TAHAP1':
      case 'ACC_TAHAP2':
      case 'ACC_TAHAP3':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING_TAHAP1':
        return 'Menunggu Konfirmasi Tahap 1';
      case 'ACC_TAHAP1':
        return 'Diterima Tahap 1';
      case 'PENDING_TAHAP2':
        return 'Menunggu Konfirmasi Tahap 2';
      case 'ACC_TAHAP2':
        return 'Diterima Tahap 2';
      case 'PENDING_TAHAP3':
        return 'Menunggu Konfirmasi Tahap 3';
      case 'ACC_TAHAP3':
        return 'Diterima Tahap 3';
      default:
        return status;
    }
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded),
            SizedBox(width: 8),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageEditOptions() {
    final _photoService = PhotoService();
    final _picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deepCream.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.photo_library, color: accentColor),
              ),
              title: Text('Pilih dari Galeri'),
              onTap: () => _pickImage(ImageSource.gallery, _photoService),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deepCream.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.camera_alt, color: accentColor),
              ),
              title: Text('Ambil Foto'),
              onTap: () => _pickImage(ImageSource.camera, _photoService),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, PhotoService photoService) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        final file = File(image.path);

        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Upload foto
        final response = await photoService.updateProfilePhoto(file);

        // Hide loading
        Navigator.pop(context);

        if (response.isSuccess) {
          Navigator.of(context).pop(); // Close bottom sheet

          // Refresh profile
          setState(() {
            _profileFuture = _profileService.getMahasiswaProfile();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Foto profil berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      Navigator.pop(context); // Hide loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deepCream.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person_outline, color: accentColor),
              ),
              title: Text('Edit Profil'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deepCream.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lock_outline, color: accentColor),
              ),
              title: Text('Ganti Password'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit_password');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final authService = AuthService();
              final success = await authService.logout();

              if (success) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal logout. Silakan coba lagi.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
                'Keluar',
                style: TextStyle(color: Colors.white),
                ),
          ),
        ],
      ),
    );
  }

  void _navigateToUKMDetail(UkmKeanggotaanModel ukm) {
    Navigator.pushNamed(
      context,
      '/ukm_detail_registered',
      arguments: ukm.namaUkm,
    );
  }

  void _onNavBarTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/beranda');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/ukm_list');
    }
  }
}