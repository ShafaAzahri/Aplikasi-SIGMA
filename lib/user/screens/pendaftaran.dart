// registration_page.dart
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final List<String> genders = ['Laki-laki', 'Perempuan'];
  final List<String> majors = ['Teknik Informatika', 'Sistem Informasi', 'Manajemen'];
  final List<String> studyPrograms = ['S1', 'D3', 'Pascasarjana'];

  String? selectedGender;
  String? selectedMajor;
  String? selectedStudyProgram;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController motivationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran'),
        backgroundColor: Color(0xFF1E1D67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formulir Pendaftaran Tahapan Pertama',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(nameController, 'Nama Lengkap'),
                  _buildTextField(nimController, 'NIM'),
                  _buildDropdown('Jenis Kelamin', genders, (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  }, selectedGender),
                  _buildDropdown('Jurusan', majors, (value) {
                    setState(() {
                      selectedMajor = value;
                    });
                  }, selectedMajor),
                  _buildDropdown('Program Studi', studyPrograms, (value) {
                    setState(() {
                      selectedStudyProgram = value;
                    });
                  }, selectedStudyProgram),
                  _buildTextField(classController, 'Kelas'),
                  _buildTextField(addressController, 'Alamat'),
                  _buildTextField(whatsappController, 'No WhatsApp'),
                  _buildTextField(motivationController, 'Motivasi'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Edit action here
                          // You can add your logic to reset the form or go back
                          // For example, clear all fields
                          nameController.clear();
                          nimController.clear();
                          classController.clear();
                          addressController.clear();
                          whatsappController.clear();
                          motivationController.clear();
                          setState(() {
                            selectedGender = null;
                            selectedMajor = null;
                            selectedStudyProgram = null;
                          });
                        },
                        child: Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Edit button color
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Submit action here
                          // You can add your submission logic
                          // For example, printing the form data
                          print('Name: ${nameController.text}');
                          print('NIM: ${nimController.text}');
                          print('Gender: $selectedGender');
                          print('Major: $selectedMajor');
                          print('Study Program: $selectedStudyProgram');
                          print('Class: ${classController.text}');
                          print('Address: ${addressController.text}');
                          print('WhatsApp: ${whatsappController.text}');
                          print('Motivation: ${motivationController.text}');
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E1D67), // Submit button color
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, ValueChanged<String?> onChanged, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: selectedValue,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
