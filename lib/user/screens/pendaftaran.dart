import 'package:flutter/material.dart';
import 'package:latihan/service/form.dart';

class RegistrationPage extends StatefulWidget {
  final String ukmId;
  final String ukmName;
  final int periodId;

  const RegistrationPage({
    Key? key,
    required this.ukmId,
    required this.ukmName,
    required this.periodId,
  }) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _mahasiswaService = MahasiswaService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMahasiswaData();
  }

  Future<void> _loadMahasiswaData() async {
    try {
      setState(() => _isLoading = true);
      final mahasiswaData = await _mahasiswaService.getMahasiswaFormData();
      
      if (mahasiswaData != null) {
        nameController.text = mahasiswaData.namaLengkap;
        nimController.text = mahasiswaData.nim;
        genderController.text = mahasiswaData.jenisKelamin;
        majorController.text = mahasiswaData.programStudi;
        classController.text = mahasiswaData.kelas;
        addressController.text = mahasiswaData.alamat;
        whatsappController.text = mahasiswaData.noWhatsapp;
        emailController.text = mahasiswaData.email;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    {bool readOnly = false}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF161D6F)),
          ),
          enabled: !readOnly,
        ),
        style: TextStyle(
          color: readOnly ? Colors.grey[600] : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran ${widget.ukmName}'),
        backgroundColor: Color(0xFF161D6F),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Form Pendaftaran Tahap 1',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF161D6F),
                              ),
                            ),
                            SizedBox(height: 24),
                            _buildTextField(nameController, 'Nama Lengkap', readOnly: true),
                            _buildTextField(nimController, 'NIM', readOnly: true),
                            _buildTextField(genderController, 'Jenis Kelamin', readOnly: true),
                            _buildTextField(majorController, 'Program Studi', readOnly: true),
                            _buildTextField(classController, 'Kelas', readOnly: true),
                            _buildTextField(addressController, 'Alamat', readOnly: true),
                            _buildTextField(whatsappController, 'No WhatsApp', readOnly: true),
                            _buildTextField(emailController, 'Email', readOnly: true),
                            _buildTextField(
                              motivationController,
                              'Motivasi',
                              readOnly: false,
                            ),
                            SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF161D6F),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }

void _submitForm() async {
  if (_formKey.currentState?.validate() ?? false) {
    try {
      setState(() => _isLoading = true);

      // Validasi motivasi tidak boleh kosong
      if (motivationController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Motivasi tidak boleh kosong')),
        );
        return;
      }

      final success = await _mahasiswaService.submitPendaftaranTahap1(
        idUkm: widget.ukmId,
        motivasi: motivationController.text,
      );

      if (success) {
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Berhasil!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 16),
                  Text('Anda berhasil mendaftar tahap 1'),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendaftar. Silakan coba lagi.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    nimController.dispose();
    genderController.dispose();
    majorController.dispose();
    classController.dispose();
    addressController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    motivationController.dispose();
    super.dispose();
  }
}