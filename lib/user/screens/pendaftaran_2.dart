import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:latihan/models/form2.dart';
import 'package:latihan/service/form2.dart';

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
    setState(() {
      isLoading = true;
    });

    try {
      print('Loading divisi for UKM: ${widget.ukmId}');
      final response = await _pendaftaranService.getDivisiUkm(widget.ukmId);
      print('Divisi response: ${response.status}');
      print('Divisi data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        setState(() {
          // Karena response.data sudah berupa List<DivisiModel>
          divisiList = response.data;
          print('Loaded ${divisiList.length} divisi');
          // Debug print setiap divisi
          divisiList.forEach((divisi) {
            print('Divisi: ${divisi.idDivisi} - ${divisi.namaDivisi}');
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Gagal memuat data divisi')),
        );
      }
    } catch (e) {
      print('Error loading divisi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    print('Selected Divisi 1: $selectedDivisi1');
    print('Selected Divisi 2: $selectedDivisi2');
    print('Izin Ortu File: ${izinOrtuFile?.path}');
    print('Sertifikat Warna File: ${sertifikatWarnaFile?.path}');
    print('Sertifikat LKMM File: ${sertifikatLKMMFile?.path}');
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

    setState(() {
      isLoading = true;
    });

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
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          barrierDismissible: false, // User harus menekan tombol untuk menutup
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Pendaftaran tahap 2 berhasil dilakukan'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Pop dialog dan navigasi ke halaman UKM
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF161D6F),
                    ),
                  ),
                ),
              ],
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
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran ${widget.ukmName}'),
        backgroundColor: Color(0xFF161D6F),
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
              'Formulir Pendaftaran Tahap Kedua',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF161D6F),
              ),
            ),
            SizedBox(height: 24),
            _buildDropdownField(
              'Divisi Pilihan 1', 
              selectedDivisi1,
              (value) => setState(() => selectedDivisi1 = value),
            ),
            _buildDropdownField(
              'Divisi Pilihan 2',
              selectedDivisi2,
              (value) => setState(() => selectedDivisi2 = value),
            ),
            _buildFileField(
              'Surat Pernyataan Izin Ortu',
              'Format: PDF/JPG/PNG, Maks: 2MB',
              izinOrtuFileName ?? '',
              () => _pickFile('izinOrtu'),
            ),
            _buildFileField(
              'Sertifikat WaRna/Pesima/LDK',
              'Format: PDF/JPG/PNG, Maks: 2MB',
              sertifikatWarnaFileName ?? '',
              () => _pickFile('sertifikatWarna'),
            ),
            _buildFileField(
              'Sertifikat LKMM Dasar/Pendas/LKMM Madya',
              'Format: PDF/JPG/PNG, Maks: 2MB',
              sertifikatLKMMFileName ?? '',
              () => _pickFile('sertifikatLKMM'),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF161D6F),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
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
              hintText: 'Pilih Divisi',
              border: UnderlineInputBorder(),
            ),
            isExpanded: true, // Tambahkan ini agar dropdown bisa memanjang
          ),
        ],
      ),
    );
  }

  Widget _buildFileField(
    String label,
    String format,
    String selectedFile,
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
                  selectedFile.isEmpty ? format : selectedFile,
                  style: TextStyle(
                    color: selectedFile.isEmpty ? Colors.grey : Colors.black,
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
}