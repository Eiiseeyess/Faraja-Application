import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // File to hold the selected image
  final ImagePicker _picker = ImagePicker();

  // Hardcoded user details
  String _username = "John Doe";
  String _email = "johndoe@example.com";
  String _firstName = "John";
  String _lastName = "Doe";
  String _phone = "123-456-7890";
  String _dob = "1990-01-01";

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showEditProfileDialog() {
    // Temp variables to store updated data
    String tempUsername = _username;
    String tempFirstName = _firstName;
    String tempLastName = _lastName;
    String tempEmail = _email;
    String tempPhone = _phone;
    String tempDob = _dob;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage(
                                "assets/images/profile_placeholder.png")
                            as ImageProvider,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                    "Username", tempUsername, (value) => tempUsername = value),
                _buildTextField("First Name", tempFirstName,
                    (value) => tempFirstName = value),
                _buildTextField(
                    "Last Name", tempLastName, (value) => tempLastName = value),
                _buildTextField(
                    "Email", tempEmail, (value) => tempEmail = value),
                _buildTextField(
                    "Phone", tempPhone, (value) => tempPhone = value),
                _buildTextField(
                    "Date of Birth", tempDob, (value) => tempDob = value),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Update values
                  _username = tempUsername;
                  _firstName = tempFirstName;
                  _lastName = tempLastName;
                  _email = tempEmail;
                  _phone = tempPhone;
                  _dob = tempDob;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage(
                              "assets/images/profile_placeholder.png")
                          as ImageProvider,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              _email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _showEditProfileDialog,
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
