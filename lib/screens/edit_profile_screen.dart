import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _phoneController = TextEditingController(text: '+91 9876543210');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _addressController = TextEditingController(text: 'Chennai, Tamil Nadu');

  @override
  Widget build(BuildContext context) {
    final primaryGold = Color(0xFFD88226);
    final darkText = Color(0xFF0B192E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkText,
        elevation: 0,
        title: Text('Edit Profile', style: TextStyle(color: primaryGold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save changes and return
              Navigator.pop(context);
            },
            child: Text(
              'SAVE',
              style: TextStyle(
                color: primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryGold.withOpacity(0.1),
                  child:
                      Icon(Icons.person_outline, size: 50, color: primaryGold),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryGold,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.camera_alt, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildTextField(_nameController, 'Full Name', Icons.person_outline),
            _buildTextField(
                _phoneController, 'Phone Number', Icons.phone_outlined),
            _buildTextField(_emailController, 'Email', Icons.email_outlined),
            _buildTextField(
                _addressController, 'Address', Icons.location_on_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFFD88226)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFD88226)),
          ),
        ),
      ),
    );
  }
}
