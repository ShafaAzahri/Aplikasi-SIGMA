import 'package:flutter/material.dart';
import 'package:latihan/models/registration_status_model.dart';
import 'package:latihan/service/button_pendaftaran.dart';
import 'package:latihan/user/screens/pendaftaran_2.dart';
import 'package:latihan/user/screens/pendaftaran_3.dart';

// Tema warna konsisten
const Color creamColor = Color(0xFFFFF8DC);      // Cream background
const Color deepCream = Color(0xFFDEB887);       // BurlyWood for accents
const Color accentColor = Color(0xFF8B4513);     // SaddleBrown for text/icons
const Color lightCream = Color(0xFFFAF3E0);      // Light cream for cards
const Color textColor = Color(0xFF4A4A4A);       // Dark gray for text

class RegistrationStatusPage extends StatefulWidget {
  final String idUkm;
  final String ukmName;

  const RegistrationStatusPage({
    Key? key,
    required this.idUkm,
    required this.ukmName,
  }) : super(key: key);

  @override
  _RegistrationStatusPageState createState() => _RegistrationStatusPageState();
}

class _RegistrationStatusPageState extends State<RegistrationStatusPage> {
  final RegistrationService _registrationService = RegistrationService();
  bool isLoading = true;
  String? error;
  RegistrationStatusData? statusData;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final status = await _registrationService.checkRegistrationStatus(widget.idUkm);
      setState(() {
        statusData = status;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  int _getCurrentStep() {
    if (statusData == null) return 1;
    if (statusData!.status.contains('TAHAP_3') ||
        statusData!.status.contains('ACC_TAHAP3') ||
        statusData!.status.contains('PENDING_TAHAP3')) {
      return 3;
    } else if (statusData!.status.contains('TAHAP_2') ||
        statusData!.status.contains('ACC_TAHAP2') ||
        statusData!.status.contains('PENDING_TAHAP2')) {
      return 2;
    }
    return 1;
  }

  String _getStatusType() {
    if (statusData == null) return 'pending';
    if (statusData!.status == 'DITOLAK') {
      return 'reject';
    } else if (statusData!.status.contains('ACC')) {
      return 'acc';
    }
    return 'pending';
  }

  void _handleNextStep() {
    final currentStep = _getCurrentStep();
    if (currentStep < 3) {
      if (currentStep == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationStep2Page(
              ukmId: widget.idUkm,
              ukmName: widget.ukmName,
            ),
          ),
        );
      } else if (currentStep == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationStep3Page(
              ukmId: widget.idUkm,
              ukmName: widget.ukmName,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: creamColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: accentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Status Pendaftaran',
          style: TextStyle(
            color: accentColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: accentColor,
        onRefresh: _loadStatus,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: isLoading
              ? Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Center(
              child: CircularProgressIndicator(color: accentColor),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUkmHeader(),
                SizedBox(height: 24),
                _buildProgressBar(),
                SizedBox(height: 32),
                _buildStatusCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUkmHeader() {
    return Card(
      elevation: 0,
      color: lightCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: deepCream.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.school_outlined, color: accentColor, size: 32),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ukmName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Proses Pendaftaran',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final currentStep = _getCurrentStep();
    return Column(
      children: [
        Row(
          children: [
            _buildProgressStep(1, 'Tahap 1', currentStep >= 1),
            Expanded(child: _buildProgressLine(currentStep > 1)),
            _buildProgressStep(2, 'Tahap 2', currentStep >= 2),
            Expanded(child: _buildProgressLine(currentStep > 2)),
            _buildProgressStep(3, 'Tahap 3', currentStep >= 3),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? accentColor : Colors.transparent,
            border: Border.all(
              color: isActive ? accentColor : deepCream,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive
                ? Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : deepCream,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? accentColor : textColor.withOpacity(0.5),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? accentColor : deepCream.withOpacity(0.3),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final status = _getStatusType();
    final currentStep = _getCurrentStep();

    return Card(
      elevation: 0,
      color: lightCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStatusIcon(status),
            SizedBox(height: 24),
            _buildStatusContent(status, currentStep),
            SizedBox(height: 32),
            _buildActionButtons(context, status, currentStep),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (status) {
      case 'acc':
        icon = Icons.check_circle_outline;
        color = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      case 'pending':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      case 'reject':
        icon = Icons.cancel_outlined;
        color = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 48,
        color: color,
      ),
    );
  }

  Widget _buildStatusContent(String status, int currentStep) {
    String title;
    String description;
    Color statusColor;

    switch (status) {
      case 'acc':
        title = 'Tahapan Ke-$currentStep Telah Selesai';
        description = currentStep == 3
            ? 'Selamat! Anda telah menyelesaikan semua tahapan pendaftaran.'
            : 'Berkas Anda telah dikonfirmasi oleh Admin UKM, silakan lanjutkan ke tahap berikutnya!';
        statusColor = Colors.green;
        break;
      case 'pending':
        title = 'Menunggu Konfirmasi';
        description = 'Berkas Anda sedang dalam proses review oleh Admin UKM';
        statusColor = Colors.orange;
        break;
      case 'reject':
        title = 'Pendaftaran Ditolak';
        description = statusData?.catatan ?? 'Mohon maaf, berkas Anda tidak memenuhi persyaratan';
        statusColor = Colors.red;
        break;
      default:
        title = '';
        description = '';
        statusColor = accentColor;
    }

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: textColor.withOpacity(0.7),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (status == 'reject') ...[
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Catatan Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  statusData?.catatan ?? 'Tidak ada catatan detail dari admin',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, String status, int currentStep) {
    if (status == 'pending') {
      return _buildButton(
        text: 'Kembali',
        onPressed: () => Navigator.pop(context),
        isPrimary: false,
      );
    }

    if (status == 'reject') {
      return Column(
        children: [
          SizedBox(height: 12),
          _buildButton(
            text: 'Kembali',
            onPressed: () => Navigator.pop(context),
            isPrimary: false,
          ),
        ],
      );
    }

    if (status == 'acc') {
      if (currentStep < 3) {
        return _buildButton(
          text: 'Lanjutkan Tahap ${currentStep + 1}',
          onPressed: _handleNextStep,
          isPrimary: true,
        );
      } else {
        return _buildButton(
          text: 'Kembali',
          onPressed: () => Navigator.pop(context),
          isPrimary: false,
        );
      }
    }

    return SizedBox();
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? accentColor : Colors.grey[300],
        foregroundColor: isPrimary ? Colors.white : textColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showRejectionNote(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Catatan Admin',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.red,
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              statusData?.catatan ?? 'Tidak ada catatan dari admin',
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                height: 1.5,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.all(24),
        actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: accentColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Tutup',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ],
        ),
    );
  }
}