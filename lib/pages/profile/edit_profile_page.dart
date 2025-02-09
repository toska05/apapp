import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user.displayName ?? "";
    _emailController.text = user.email ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isUpdating = true;
    });
    try {
      await user.updateDisplayName(_nameController.text);
      await user.reload();
      FirebaseAuth.instance.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: \$e")),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Update Profile"), backgroundColor: Colors.green[400]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileAvatar(),
            SizedBox(height: 20),
            _buildTextField("Name", _nameController),
            SizedBox(height: 20),
            _buildTextField("Email", _emailController, readOnly: true),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isUpdating ? null : _updateProfile,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
              child: _isUpdating
                  ? CircularProgressIndicator()
                  : Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: _isUpdating ? null : _updateAvatar,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: CircleAvatar(
          backgroundImage:
              user.photoURL != null ? NetworkImage(user.photoURL!) : null,
          child:
              user.photoURL == null ? const Icon(Icons.person, size: 50) : null,
          radius: 50,
        ),
      ),
    );
  }

  Future<void> _updateAvatar() async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUpdating = true;
      });

      try {
        final File file = File(pickedFile.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_avatars/${user.uid}.jpg');
        await storageRef.putFile(file);
        final photoURL = await storageRef.getDownloadURL();

        await user.updatePhotoURL(photoURL);
        await user.reload();
        FirebaseAuth.instance.currentUser;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Avatar updated successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating avatar: $e")),
        );
      } finally {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }
}
