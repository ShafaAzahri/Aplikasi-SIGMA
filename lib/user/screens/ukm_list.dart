import 'package:flutter/material.dart';
import 'package:latihan/user/util/navbar_function.dart';
import 'package:latihan/service/ukm.dart';
import 'package:latihan/models/ukm.dart';
import 'package:latihan/service/api_url.dart';

// Constants
const _kColors = {
  'cream': Color(0xFFFFF8DC),
  'deepCream': Color(0xFFDEB887),
  'accent': Color(0xFF8B4513),
  'text': Color(0xFF4A4A4A),
};

class ListUKM extends StatefulWidget {
  @override
  _ListUKMState createState() => _ListUKMState();
}

class _ListUKMState extends State<ListUKM> {
  final UkmService _ukmService = UkmService();
  int _selectedIndex = 1;

  void _navigateToDetail(UkmModel ukm) {
    Navigator.pushNamed(
      context,
      '/ukm_detail',
      arguments: {
        'ukmId': ukm.idUkm.toString(),
        'ukmName': ukm.namaUkm,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kColors['cream'],
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: buildBottomNavBar(_selectedIndex, context, _onItemTapped),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Daftar UKM',
        style: TextStyle(
          color: _kColors['accent'],
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: _kColors['cream'],
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<UkmModel>>(
      future: _ukmService.getUkmRekomendasi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: _kColors['accent'],
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorState('Error: ${snapshot.error}');
        }

        final ukms = snapshot.data ?? [];
        if (ukms.isEmpty) {
          return _buildEmptyState();
        }

        return _buildUkmGrid(ukms);
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: _kColors['text']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 64,
            color: _kColors['deepCream']?.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada UKM tersedia',
            style: TextStyle(
              color: _kColors['text'],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUkmGrid(List<UkmModel> ukms) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: ukms.length,
      itemBuilder: (context, index) => _buildUkmCard(ukms[index]),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 5;
    if (width > 600) return 4;
    if (width > 400) return 3;
    return 2;
  }

  Widget _buildUkmCard(UkmModel ukm) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(ukm),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _buildUkmImage(ukm.logo),
            ),
            Expanded(
              flex: 2,
              child: _buildUkmInfo(ukm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUkmImage(String logoPath) {
    return Container(
      decoration: BoxDecoration(
        color: _kColors['deepCream']?.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.all(12),
      child: Image.network(
        '${AppConfig.assetBaseUrl}/$logoPath',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported,
          color: _kColors['deepCream']?.withOpacity(0.5),
          size: 32,
        ),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: _kColors['accent'],
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUkmInfo(UkmModel ukm) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ukm.namaUkm,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _kColors['accent'],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            ukm.deskripsi,
            style: TextStyle(
              fontSize: 12,
              color: _kColors['text'],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    final routes = {
      0: '/beranda',
      2: '/profile',
    };

    if (routes.containsKey(index)) {
      Navigator.pushReplacementNamed(context, routes[index]!);
    }
  }
}