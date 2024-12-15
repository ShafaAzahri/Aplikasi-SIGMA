import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:latihan/service/form3.dart';
import 'package:path/path.dart' as path;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran ${widget.ukmName}'),
        backgroundColor: Color(0xFF161D6F),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressBar(),
                  SizedBox(height: 24),
                  _buildFormCard(),
                ],
              ),
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
      padding: EdgeInsets.symmetric(horizontal: 16),
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Color(0xFF161D6F) : Colors.white,
            border: Border.all(
              color: isActive ? Color(0xFF161D6F) : Colors.grey,
              width: 2,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Color(0xFF161D6F) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? Color(0xFF161D6F) : Colors.grey[300],
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formulir Pendaftaran Tahap Ketiga',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF161D6F),
              ),
            ),
            SizedBox(height: 24),
            _buildFileField(
              'Scan KTM atau identitas lainnya',
              'Format: PDF/JPG/PNG, Maks: 2MB',
              ktmFileName,
              () => _pickFile('ktm'),
            ),
            _buildFileField(
              'Scan KHS',
              'Format: PDF/JPG/PNG, Maks: 2MB',
              khsFileName,
              () => _pickFile('khs'),
            ),
            _buildFileField(
              'CV',
              'Format: PDF, Maks: 2MB',
              cvFileName,
              () => _pickFile('cv'),
            ),
            _buildFileField(
              'Motivation Letter',
              'Format: PDF, Maks: 2MB',
              motivationLetterFileName,
              () => _pickFile('motivation'),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text('Kembali'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF161D6F),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileField(
    String label,
    String format,
    String? selectedFile,
    VoidCallback onPick,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedFile ?? format,
                  style: TextStyle(
                    color: selectedFile != null ? Colors.black : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: onPick,
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

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

        // Debug print
        print('Picked file for $type:');
        print('Path: ${file.path}');
        print('Name: $fileName');
        print('Size: ${await file.length()} bytes');
        print('Extension: ${path.extension(fileName)}');

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
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error memilih file: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (ktmFile == null || 
        khsFile == null || 
        cvFile == null || 
        motivationLetter == null) {
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
            return AlertDialog(
              title: Text('Sukses'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 16),
                  Text(response.message),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.of(context).pushReplacementNamed(
                      '/registration_status',
                      arguments: {
                        'idUkm': widget.ukmId,
                        'ukmName': widget.ukmName,
                      },
                    );
                  },
                ),
              ],
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
}