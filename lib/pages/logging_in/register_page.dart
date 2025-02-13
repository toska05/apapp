import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  bool isPasswordVisible = false;
  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future signUp() async {
    // Reset the error message at the start.
    setState(() {
      errorMessage = '';
    });

    // Check if any required field is empty.
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmpasswordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    // Check if passwords match.
    if (!passwordConfirmed()) {
      setState(() {
        errorMessage =
            'Passwords do not match. Please re-enter your password correctly.';
      });
      return;
    }

    try {
      // Create the user
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add user details to Firestore
      await addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        credentials.user!.uid.trim(),
        int.parse(_ageController.text.trim()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getFriendlyErrorMessage(e.code, e.message);
      });
    }
  }

  Future addUserDetails(String firstName, String lastName, String email,
      String uid, int age) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
    });
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmpasswordController.text.trim();
  }

  // Map Firebase error codes to user-friendly messages.
  String getFriendlyErrorMessage(String errorCode, String? errorMessage) {
    switch (errorCode) {
      case 'invalid-password':
        return "The provided value for the password user property is invalid. It must be a string with at least six characters.";
      case 'email-already-in-use':
        return "An account with that email already exists. Try logging in.";
      case 'invalid-email':
        return "The email address is invalid. Please check and try again.";
      default:
        return errorMessage ??
            "An unexpected error occurred. Please try again later.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello There',
                style: GoogleFonts.bebasNeue(
                  fontSize: 55,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Register below with your details',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              // First name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 26, 14, 84)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'First Name',
                    fillColor: Colors.grey[100],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Last name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 26, 14, 84)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Last Name',
                    fillColor: Colors.grey[100],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Age
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 26, 14, 84)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Age',
                    fillColor: Colors.grey[100],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 26, 14, 84)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.grey[100],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 26, 14, 84)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey[100],
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Confirm Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _confirmpasswordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 26, 14, 84)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Confirm Password',
                    fillColor: Colors.grey[100],
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Error message display in a friendly container
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 25),
              // Sign up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Log in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.green[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
