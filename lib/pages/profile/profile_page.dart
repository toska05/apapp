import 'package:apapp/auth/auth_page.dart';
import 'package:apapp/pages/profile/edit_profile_page.dart';
import 'package:apapp/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apapp/auth/main_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isLightMode = false;

  // Se crean los controladores para 'Name' y 'Email'
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con la información del usuario
    _nameController = TextEditingController(text: user.displayName ?? "");
    _emailController = TextEditingController(text: user.email ?? "");
    print(user);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildProfileContent();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Profile'),
      actions: [
        IconButton(
          onPressed: logout,
          icon: const Icon(Icons.logout),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('Name', _nameController),
                const SizedBox(height: 30),
                _buildTextField('Email', _emailController),
                const SizedBox(height: 30),
                CustomSwitch(),
                const SizedBox(height: 80),
                _buildButton('Edit', Colors.green[400]!, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                  );
                }),
                const SizedBox(height: 20),
                _buildButton('Delete Account', Colors.red[300]!, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFFF9FCFA),
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.',
                            style: TextStyle(color: Colors.black)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteAccount();
                            },
                            child: Text('Delete',
                                style: TextStyle(color: Colors.red[300]!)),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() async {
    //TODO : fix
    try {
      await user.delete().then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  Widget _buildProfileAvatar() {
    return Container(
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
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



class CustomSwitch extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 20,
      children: [
        GestureDetector(
          onTap: () {
            if (appThemeState.isDarkMode) {
              appThemeState.setLightTheme();
            } else {
              appThemeState.setDarkTheme();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 100,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: AssetImage(
                  appThemeState.isDarkMode ? 'assets/night_mode.png' : 'assets/day_mode.png' ,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment:
                  appThemeState.isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (appThemeState.isDarkMode) const Text('Dark Mode'),
        if (!appThemeState.isDarkMode) const Text('Light Mode')
      ],
    );
  }
}
