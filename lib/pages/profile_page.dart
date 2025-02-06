import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isLightMode = false;

  @override
  void initState() {
    super.initState();
    print(user);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildProfileContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Profile'),
      actions: [
        IconButton(
          onPressed: logout,
          icon: Icon(Icons.logout),
          // color: Colors.white,
        ),
      ],
      backgroundColor: Colors.green[400],
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(height: 50, color: Colors.green[400]),
                _buildProfileAvatar(),
              ],
            ),
            Padding(padding:  const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField('Name', false),
                  const SizedBox(height: 20),
                  _buildTextField('Email', false),
                  const SizedBox(height: 20),
                  _buildTextField('Password', true),
                  const SizedBox(height: 20),
                  _buildLightModeSwitch(),
                  const SizedBox(height: 20),
                  _buildButton('Save', Colors.green[400]!, () {}),
                  const SizedBox(height: 20),
                  _buildButton('Delete Account', Colors.red[400]!, () {}),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildProfileAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: CircleAvatar(
        backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
        child: user.photoURL == null ? const Icon(Icons.person, size: 50) : null,
        radius: 50,
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            suffixIcon: isPassword ? const Icon(Icons.visibility) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLightModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: isLightMode,
            activeColor: Colors.green[400],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          onChanged: (value) {
            setState(() {
              isLightMode = value;
            });
          },
        ),
        const Text('Light Mode'),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
