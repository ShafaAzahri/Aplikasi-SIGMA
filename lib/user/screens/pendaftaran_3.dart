import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:latihan/service/form3.dart';
import 'package:path/path.dart' as path;

// Constants
const Color primaryColor = Color(0xFFFFF8DC);    // Cream background
const Color secondaryColor = Color(0xFFDEB887);  // BurlyWood
const Color accentColor = Color(0xFF8B4513);     // SaddleBrown
const Color textColor = Color(0xFF4A4A4A);       // Dark gray

class RegistrationStep3Page extends StatefulWidget {
  final String ukmId;
  final String ukmName;

  const RegistrationStep3Page({
    Key? key,
    required this.ukmId,
    required this.ukmName,
  }) : super(key: key);

  @override
  _RegistrationStep3PageState createState() => _RegistrationStep3PageState();
}

class _RegistrationStep3PageState extends State<RegistrationStep3Page> {
  final _submitService = SubmitTahap3Service();
  bool _isLoading = false;

  // File state variables
  File? ktmFile;
  File? khsFile;
  File? cvFile;
  File? motivationLetter;

  // File names for display
  String? ktmFileName;
  String? khsFileName;
  String? cvFileName;
  String? motivationLetterFileName;

  Future<void> _pickFile(String type) async {
    try {
      List<String> allowedExtensions;
      if (type == 'cv' || type == 'motivation') {
        allowedExtensions = ['pdf'];
      } else {
        allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;

        setState(() {
          switch (type) {
            case 'ktm':
              ktmFile = file;
              ktmFileName = fileName;
              break;
            case 'khs':
              khsFile = file;
              khsFileName = fileName;
              break;
            case 'cv':
              cvFile = file;
              cvFileName = fileName;
              break;
            case 'motivation':
              motivationLetter = file;
              motivationLetterFileName = fileName;
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
    if (ktmFile == null || khsFile == null || cvFile == null || motivationLetter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua dokumen harus diupload')),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final response = await _submitService.submitTahap3(
        idUkm: widget.ukmId,
        scanKtm: ktmFile!,
        scanKhs: khsFile!,
        cv: cvFile!,
        motivationLetter: motivationLetter!,
      );

      if (response.status) {
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
                      'Pendaftaran tahap 3 berhasil dilakukan',
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
                          Navigator.of(context).pushReplacementNamed(
                            '/registration_status',
                            arguments: {
                              'idUkm': widget.ukmId,
                              'ukmName': widget.ukmName,
                            },
                          );
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
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                            'Formulir Pendaftaran Tahap Ketiga',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
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
          _buildProgressStep(2, 'TAHAP 2', false),
          Expanded(child: _buildProgressLine(true)),
          _buildProgressStep(3, 'TAHAP 3', true),
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
    'Scan KTM atau identitas lainnya',
    'Format: PDF/JPG/PNG, Maks: 2MB',
    ktmFileName,
    () => _pickFile('ktm'),
    ),
    SizedBox(height: 16),
    _buildFileField(
    'Scan KHS',
    'Format: PDF/JPG/PNG, Maks: 2MB',
    khsFileName,
    () => _pickFile('khs'),
    ),
        SizedBox(height: 16),
        _buildFileField(
          'CV',
          'Format: PDF, Maks: 2MB',
          cvFileName,
              () => _pickFile('cv'),
        ),
        SizedBox(height: 16),
        _buildFileField(
          'Motivation Letter',
          'Format: PDF, Maks: 2MB',
          motivationLetterFileName,
              () => _pickFile('motivation'),
        ),
      ],
    );
  }

  Widget _buildFileField(
      String label,
      String format,
      String? selectedFile,
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
                    selectedFile ?? format,
                    style: TextStyle(
                      color: selectedFile != null ? textColor : Colors.grey,
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
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
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