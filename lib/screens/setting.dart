import 'dart:io';

import 'package:e_nusantara/api/checkLogin.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../api/auth_service.dart';
import '../api/setting_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Checklogin _checklogin = new Checklogin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          ListTile(
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black38),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
          const Divider(height: 20),
          ListTile(
            title: const Text(
              'Change Password',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black38),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final AuthService _authService = AuthService();

  String id = "";
  String name = "";
  String email = "";
  String profileImage = "";
  String tanggalLahir = "";
  String? selectedGender;
  DateTime? selectedDate;
  File? _profileImage;
  final Checklogin _checklogin = new Checklogin();

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  void _initializeProfile() async {
    _checklogin.checkAndNavigate(context);

    final result = await _authService.decodeProfile(context);
    setState(() {
      id = result['id'];
      profileImage = result['profileImage'] ?? ""; // Gambar profil
      name = result['name'] ?? ""; // Nama dengan fallback
      email = result['email'] ?? "";
      tanggalLahir = result['tanggalLahir'] ?? "";
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a picture"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.parse(tanggalLahir),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveProfile() async {
    final userId = id;
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final Checklogin _checklogin = new Checklogin();

    if (fullName.isEmpty ||
        email.isEmpty ||
        selectedGender == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    try {
      await _checklogin.checkAndNavigate(context);
      final token = await storage.read(key: 'accessToken');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      print(token);

      // Kirim update profile
      final success = await ResetPasswordService().updateUserProfile(
        token: token,
        userId: userId,
        nama: fullName,
        email: email,
        gender: selectedGender,
        tanggalLahir: selectedDate?.toIso8601String(),
      );

      if (_profileImage != null) {
        final imageUpdated = await ResetPasswordService().updateProfileImage(
          userId: userId,
          token: token,
          imageFile: _profileImage!,
        );
        if (!imageUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update image')),
          );
          return;
        }
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: _showImagePickerDialog,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: _profileImage != null
            ? FileImage(_profileImage!)
            : NetworkImage(profileImage),
        child: profileImage == ""
            ? const Icon(Icons.person, size: 50, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String title,
    TextInputType keyboardType = TextInputType.text,
  }) {
    if (controller.text.isEmpty && title != "") {
      controller.text = title;
    }
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      items: ['Male', 'Female'].map((String gender) {
        return DropdownMenuItem<String>(
          value: gender.toLowerCase(),
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedGender = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                : (tanggalLahir.isNotEmpty
                    ? DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(tanggalLahir).toLocal())
                    : "Pilih Tanggal"),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAvatar(),
              const SizedBox(height: 16),
              _buildTextField(
                title: name,
                controller: fullNameController,
                label: 'Full Name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                title: email,
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildGenderDropdown(),
              const SizedBox(height: 16),
              _buildDatePicker(context),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDDA86B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();
  String id = "";
  final Checklogin _checklogin = new Checklogin();

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  void _initializeProfile() async {
    _checklogin.checkAndNavigate(context);
    final result = await _authService.decodeProfile(context);
    setState(() {
      id = result['id'];
    });
  }

  bool _isOldPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  void _showPasswordChangeNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'login_channel',
        title: 'Nusa Chan',
        body: 'Password kamu berhasil dirubah >//<',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  void _validateAndSave() async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog("All fields are required.");
    } else if (newPassword != confirmPassword) {
      _showErrorDialog("Passwords do not match.");
    } else {
      _checklogin.checkAndNavigate(context);
      final resetPasswordService = ResetPasswordService();
      bool success = await resetPasswordService.resetPassword(
          id, oldPassword, newPassword);

      if (success) {
        _showSuccessSnackbar("Password successfully changed!");
        _showPasswordChangeNotification();
      } else {
        _showErrorDialog("Failed to change password. Please try again.");
      }
    }
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: _isOldPasswordHidden,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordHidden = !_isOldPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: _isNewPasswordHidden,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordHidden = !_isNewPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: _isConfirmPasswordHidden,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAndSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDDA86B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'CHANGE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
