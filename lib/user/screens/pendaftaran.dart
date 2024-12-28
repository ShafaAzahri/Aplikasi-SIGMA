import 'package:flutter/material.dart';
import 'package:latihan/service/form.dart';

// Constants
const Color primaryColor = Color(0xFFFFF8DC);  // Cream background
const Color secondaryColor = Color(0xFFDEB887); // BurlyWood
const Color accentColor = Color(0xFF8B4513);    // SaddleBrown
const Color textColor = Color(0xFF4A4A4A);      // Dark gray

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
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
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
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          color: readOnly ? textColor.withOpacity(0.7) : textColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: accentColor.withOpacity(0.7),
          ),
          floatingLabelStyle: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w600,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor, width: 2),
          ),
          filled: true,
          fillColor: readOnly ? secondaryColor.withOpacity(0.05) : Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildProgressStep(1, 'TAHAP 1', true),
          Expanded(child: _buildProgressLine(false)),
          _buildProgressStep(2, 'TAHAP 2', false),
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
      body: _isLoading
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form Pendaftaran Tahap 1',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
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
                        _buildTextField(motivationController, 'Motivasi'),
                        SizedBox(height: 24),
                        Container(
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
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() => _isLoading = true);

        if (motivationController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Motivasi tidak boleh kosong'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final success = await _mahasiswaService.submitPendaftaranTahap1(
          idUkm: widget.ukmId,
          motivasi: motivationController.text,
        );

        if (success) {
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
                        'Berhasil!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pendaftaran tahap 1 telah berhasil',
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
            SnackBar(
              content: Text('Gagal mendaftar. Silakan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
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