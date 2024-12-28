import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:latihan/models/form2.dart';
import 'package:latihan/service/form2.dart';

// Constants
const Color primaryColor = Color(0xFFFFF8DC);    // Cream background
const Color secondaryColor = Color(0xFFDEB887);  // BurlyWood
const Color accentColor = Color(0xFF8B4513);     // SaddleBrown
const Color textColor = Color(0xFF4A4A4A);       // Dark gray

class RegistrationStep2Page extends StatefulWidget {
  final String ukmId;
  final String ukmName;

  const RegistrationStep2Page({
    Key? key,
    required this.ukmId,
    required this.ukmName,
  }) : super(key: key);

  @override
  _RegistrationStep2PageState createState() => _RegistrationStep2PageState();
}

class _RegistrationStep2PageState extends State<RegistrationStep2Page> {
  final PendaftaranTahap2Service _pendaftaranService = PendaftaranTahap2Service();
  List<DivisiModel> divisiList = [];
  String? selectedDivisi1;
  String? selectedDivisi2;
  File? izinOrtuFile;
  File? sertifikatWarnaFile;
  File? sertifikatLKMMFile;
  bool isLoading = false;
  String? izinOrtuFileName;
  String? sertifikatWarnaFileName;
  String? sertifikatLKMMFileName;

  @override
  void initState() {
    super.initState();
    _loadDivisi();
  }

  Future<void> _loadDivisi() async {
    setState(() => isLoading = true);

    try {
      final response = await _pendaftaranService.getDivisiUkm(widget.ukmId);
      if (response.isSuccess && response.data != null) {
        setState(() => divisiList = response.data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Gagal memuat data divisi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;

        setState(() {
          switch (type) {
            case 'izinOrtu':
              izinOrtuFile = file;
              izinOrtuFileName = fileName;
              break;
            case 'sertifikatWarna':
              sertifikatWarnaFile = file;
              sertifikatWarnaFileName = fileName;
              break;
            case 'sertifikatLKMM':
              sertifikatLKMMFile = file;
              sertifikatLKMMFileName = fileName;
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error memilih file: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (selectedDivisi1 == null || selectedDivisi2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih divisi terlebih dahulu')),
      );
      return;
    }

    if (izinOrtuFile == null || sertifikatWarnaFile == null || sertifikatLKMMFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload semua dokumen yang diperlukan')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = PendaftaranTahap2Request(
        idUkm: widget.ukmId,
        divisiPilihan1: selectedDivisi1!,
        divisiPilihan2: selectedDivisi2!,
      );

      final response = await _pendaftaranService.submitTahap2(
        request: request,
        izinOrtu: izinOrtuFile,
        sertifikatWarna: sertifikatWarnaFile,
        sertifikatLkmm: sertifikatLKMMFile,
      );

      if (response.isSuccess) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Sukses!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pendaftaran tahap 2 berhasil dilakukan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Gagal mengirim data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          'Pendaftaran ${widget.ukmName}',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: accentColor))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressBar(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Formulir Pendaftaran Tahap Kedua',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildDivisiSection(),
                      SizedBox(height: 24),
                      _buildDocumentSection(),
                      SizedBox(height: 24),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildProgressStep(1, 'TAHAP 1', false),
          Expanded(child: _buildProgressLine(true)),
          _buildProgressStep(2, 'TAHAP 2', true),
          Expanded(child: _buildProgressLine(false)),
          _buildProgressStep(3, 'TAHAP 3', false),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? accentColor : Colors.white,
            border: Border.all(
              color: isActive ? accentColor : secondaryColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? accentColor.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? accentColor : secondaryColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? accentColor : secondaryColor.withOpacity(0.3),
    );
  }

  Widget _buildDivisiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilihan Divisi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        SizedBox(height: 16),
        _buildDropdownField(
          'Divisi Pilihan 1',
          selectedDivisi1,
              (value) => setState(() => selectedDivisi1 = value),
        ),
        SizedBox(height: 16),
        _buildDropdownField(
          'Divisi Pilihan 2',
          selectedDivisi2,
              (value) => setState(() => selectedDivisi2 = value),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      String label,
      String? value,
      Function(String?) onChanged,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 8),
            child: Text(
              label,
              style: TextStyle(
                color: accentColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            items: divisiList.map((divisi) {
              return DropdownMenuItem<String>(
                value: divisi.idDivisi.toString(),
                child: Text(divisi.namaDivisi),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
            icon: Icon(Icons.arrow_drop_down, color: accentColor),
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      'Dokumen Persyaratan',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
    ),
    SizedBox(height: 16),
    _buildFileField(
    'Surat Pernyataan Izin Ortu',
    'Format: PDF/JPG/PNG, Maks: 2MB',
    izinOrtuFileName ?? '',
    () => _pickFile('izinOrtu'),
    ),
    SizedBox(height: 16),
    _buildFileField(
    'Sertifikat WaRna/Pesima/LDK',
    'Format: PDF/JPG/PNG, Maks: 2MB',
    sertifikatWarnaFileName ?? '',
    () => _pickFile('sertifikatWarna'),
    ),
    SizedBox(height: 16),
        _buildFileField(
          'Sertifikat LKMM Dasar/Pendas/LKMM Madya',
          'Format: PDF/JPG/PNG, Maks: 2MB',
          sertifikatLKMMFileName ?? '',
              () => _pickFile('sertifikatLKMM'),
        ),
      ],
    );
  }

  Widget _buildFileField(
      String label,
      String format,
      String selectedFile,
      VoidCallback onPick,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: accentColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile.isEmpty ? format : selectedFile,
                    style: TextStyle(
                      color: selectedFile.isEmpty ? Colors.grey : textColor,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.upload_file_rounded,
                      color: accentColor,
                    ),
                    onPressed: onPick,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor,
            accentColor.withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : Text(
          'Submit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}