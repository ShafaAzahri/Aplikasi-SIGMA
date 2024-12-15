// lib/screens/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:latihan/models/edit_profile_model.dart';
import 'package:latihan/service/edit_profile.dart';
import 'package:latihan/service/mahasiswa.dart';

class EditProfilePage extends StatefulWidget {
 @override
 _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
 final _formKey = GlobalKey<FormState>();
 final _editProfileService = EditProfileService();
 final _mahasiswaService = ProfileService();
 bool _isLoading = false;
 bool _isSubmitting = false;

 final _nameController = TextEditingController();
 final _kelasController = TextEditingController();
 final _alamatController = TextEditingController();
 final _whatsappController = TextEditingController();
 final _emailController = TextEditingController();
 String? _selectedJenisKelamin;

 @override
 void initState() {
   super.initState();
   _loadCurrentProfile();
 }

 @override
 void dispose() {
   _nameController.dispose();
   _kelasController.dispose();
   _alamatController.dispose();
   _whatsappController.dispose();
   _emailController.dispose();
   super.dispose();
 }

 Future<void> _loadCurrentProfile() async {
   try {
     setState(() => _isLoading = true);
     final profile = await _mahasiswaService.getMahasiswaProfile();
     
     setState(() {
       _nameController.text = profile.profile.namaLengkap;
       _kelasController.text = profile.profile.kelas ?? '';
       _alamatController.text = profile.profile.alamat ?? '';
       _whatsappController.text = profile.profile.noWhatsapp ?? '';
       _emailController.text = profile.profile.email ?? '';
       _selectedJenisKelamin = profile.profile.jenisKelamin;
     });
   } catch (e) {
     if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Gagal memuat data profil: $e')),
       );
     }
   } finally {
     if (mounted) {
       setState(() => _isLoading = false);
     }
   }
 }

 Future<void> _updateProfile() async {
   if (!_formKey.currentState!.validate()) return;

   setState(() => _isSubmitting = true);

   try {
     final profileModel = EditProfileModel(
       nama: _nameController.text,
       jenisKelamin: _selectedJenisKelamin,
       kelas: _kelasController.text,
       alamat: _alamatController.text,
       noWhatsapp: _whatsappController.text,
       email: _emailController.text,
     );

     final success = await _editProfileService.updateProfile(profileModel);

     if (success) {
       Navigator.pop(context, true);
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Profil berhasil diperbarui')),
       );
     }
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Gagal memperbarui profil: $e')),
     );
   } finally {
     if (mounted) {
       setState(() => _isSubmitting = false);
     }
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(
         'Edit Profil',
         style: TextStyle(color: const Color.fromARGB(255, 22, 29, 111)),
       ),
       backgroundColor: const Color.fromARGB(255, 255, 252, 230),
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 22, 29, 111)),
         onPressed: () => Navigator.of(context).pop(),
       ),
     ),
     body: _isLoading 
       ? Center(child: CircularProgressIndicator())
       : SingleChildScrollView(
           padding: EdgeInsets.all(16),
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Card(
                   elevation: 0,
                   color: Colors.blue.shade50,
                   child: Padding(
                     padding: EdgeInsets.all(12),
                     child: Row(
                       children: [
                         Icon(Icons.info_outline, color: Colors.blue),
                         SizedBox(width: 12),
                         Expanded(
                           child: Text(
                             'Perbarui informasi profil Anda',
                             style: TextStyle(
                               color: Colors.blue.shade900,
                               fontSize: 13,
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 24),
                 TextFormField(
                   controller: _nameController,
                   decoration: InputDecoration(
                     labelText: 'Nama Lengkap',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Nama harus diisi';
                     }
                     return null;
                   },
                 ),
                 SizedBox(height: 16),
                 DropdownButtonFormField<String>(
                   value: _selectedJenisKelamin,
                   decoration: InputDecoration(
                     labelText: 'Jenis Kelamin',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   items: ['Laki-laki', 'Perempuan'].map((String value) {
                     return DropdownMenuItem<String>(
                       value: value,
                       child: Text(value),
                     );
                   }).toList(),
                   onChanged: (newValue) {
                     setState(() {
                       _selectedJenisKelamin = newValue;
                     });
                   },
                 ),
                 SizedBox(height: 16),
                 TextFormField(
                   controller: _kelasController,
                   decoration: InputDecoration(
                     labelText: 'Kelas',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                 ),
                 SizedBox(height: 16),
                 TextFormField(
                   controller: _alamatController,
                   decoration: InputDecoration(
                     labelText: 'Alamat',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                 ),
                 SizedBox(height: 16),
                 TextFormField(
                   controller: _whatsappController,
                   decoration: InputDecoration(
                     labelText: 'No. WhatsApp',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   keyboardType: TextInputType.phone,
                 ),
                 SizedBox(height: 16),
                 TextFormField(
                   controller: _emailController,
                   decoration: InputDecoration(
                     labelText: 'Email',
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   keyboardType: TextInputType.emailAddress,
                 ),
                 SizedBox(height: 24),
                 Container(
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       colors: [
                         const Color.fromARGB(255, 22, 29, 111),
                         const Color.fromARGB(255, 45, 56, 180),
                       ],
                       begin: Alignment.centerLeft,
                       end: Alignment.centerRight,
                     ),
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: ElevatedButton(
                     onPressed: _isSubmitting ? null : _updateProfile,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.transparent,
                       shadowColor: Colors.transparent,
                       padding: EdgeInsets.symmetric(vertical: 15),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                     ),
                     child: _isSubmitting
                         ? SizedBox(
                             height: 20,
                             width: 20,
                             child: CircularProgressIndicator(
                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                               strokeWidth: 2,
                             ),
                           )
                         : Text(
                             'Simpan Perubahan',
                             style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                               letterSpacing: 1,
                             ),
                           ),
                   ),
                 ),
               ],
             ),
           ),
         ),
   );
 }
}