// lib/screens/edit_password_page.dart
import 'package:flutter/material.dart';
import 'package:latihan/service/edit_password.dart';

class EditPasswordPage extends StatefulWidget {
 @override
 _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
 final _formKey = GlobalKey<FormState>();
 final _editPasswordService = EditPasswordService();
 bool _isLoading = false;

 final _oldPasswordController = TextEditingController();
 final _newPasswordController = TextEditingController();
 final _confirmPasswordController = TextEditingController();

 bool _obscureOldPassword = true;
 bool _obscureNewPassword = true;
 bool _obscureConfirmPassword = true;

 @override
 void dispose() {
   _oldPasswordController.dispose();
   _newPasswordController.dispose();
   _confirmPasswordController.dispose();
   super.dispose();
 }

 Future<void> _updatePassword() async {
   if (!_formKey.currentState!.validate()) return;

   setState(() => _isLoading = true);

   try {
     final success = await _editPasswordService.updatePassword(
       oldPassword: _oldPasswordController.text,
       newPassword: _newPasswordController.text,
     );

     if (success) {
       Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Password berhasil diperbarui')),
       );
     }
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(e.toString())),
     );
   } finally {
     setState(() => _isLoading = false);
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(
         'Ganti Password',
         style: TextStyle(color: const Color.fromARGB(255, 22, 29, 111)),
       ),
       backgroundColor: const Color.fromARGB(255, 255, 252, 230),
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 22, 29, 111)),
         onPressed: () => Navigator.of(context).pop(),
       ),
     ),
     body: SingleChildScrollView(
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
                         'Password baru minimal 6 karakter',
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
               controller: _oldPasswordController,
               obscureText: _obscureOldPassword,
               decoration: InputDecoration(
                 labelText: 'Password Lama',
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 suffixIcon: IconButton(
                   icon: Icon(
                     _obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                   ),
                   onPressed: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                 ),
               ),
               validator: (value) {
                 if (value == null || value.isEmpty) {
                   return 'Password lama harus diisi';
                 }
                 return null;
               },
             ),
             SizedBox(height: 16),
             TextFormField(
               controller: _newPasswordController,
               obscureText: _obscureNewPassword,
               decoration: InputDecoration(
                 labelText: 'Password Baru',
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 suffixIcon: IconButton(
                   icon: Icon(
                     _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                   ),
                   onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                 ),
               ),
               validator: (value) {
                 if (value == null || value.isEmpty) {
                   return 'Password baru harus diisi';
                 }
                 if (value.length < 6) {
                   return 'Password minimal 6 karakter';
                 }
                 return null;
               },
             ),
             SizedBox(height: 16),
             TextFormField(
               controller: _confirmPasswordController,
               obscureText: _obscureConfirmPassword,
               decoration: InputDecoration(
                 labelText: 'Konfirmasi Password Baru',
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 suffixIcon: IconButton(
                   icon: Icon(
                     _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                   ),
                   onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                 ),
               ),
               validator: (value) {
                 if (value != _newPasswordController.text) {
                   return 'Password tidak cocok';
                 }
                 return null;
               },
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
                 onPressed: _isLoading ? null : _updatePassword,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.transparent,
                   shadowColor: Colors.transparent,
                   padding: EdgeInsets.symmetric(vertical: 15),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10),
                   ),
                 ),
                 child: _isLoading
                     ? SizedBox(
                         height: 20,
                         width: 20,
                         child: CircularProgressIndicator(
                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                           strokeWidth: 2,
                         ),
                       )
                     : Text(
                         'Update Password',
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