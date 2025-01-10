// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {

//   final user = FirebaseAuth.instance.currentUser!;

//   void logout() {
//     FirebaseAuth.instance.signOut();
//   }

//   Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
//     return await FirebaseFirestore.instance.collection('users').doc(uid).get(); // id
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         future: getUserDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           } else if (snapshot.hasData) {
//             Map<String, dynamic>? user = snapshot.data!.data();

//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     padding: const EdgeInsets.all(25),
//                     child: const Icon(
//                       Icons.person,
//                       size: 64,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   Text(
//                     user!['username'],
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   Text(
//                     user['email'],
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Text('No data');
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page', style: TextStyle(fontSize: 24)),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final user = FirebaseAuth.instance.currentUser!;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();

//   void logout() {
//     FirebaseAuth.instance.signOut();
//   }

//   Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
//     return await _firestore.collection('users').doc(user.uid).get();
//   }

//   Future<void> updateUserDetails(String username, String email) async {
//     await _firestore.collection('users').doc(user.uid).update({
//       'username': username,
//       'email': email,
//     });
//     setState(() {}); // Refresh UI after update
//   }

//   Future<void> deleteUserAccount() async {
//     await _firestore.collection('users').doc(user.uid).delete();
//     await user.delete();
//     FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         title: Text('Profile Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: logout,
//           ),
//         ],
//       ),
//       body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         future: getUserDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Text("Error: ${snapshot.error}");
//           } else if (snapshot.hasData) {
//             Map<String, dynamic>? userDetails = snapshot.data!.data();

//             _usernameController.text = userDetails!['username'];
//             _emailController.text = userDetails['email'];

//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     padding: const EdgeInsets.all(25),
//                     child: const Icon(
//                       Icons.person,
//                       size: 64,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _usernameController,
//                     decoration: InputDecoration(
//                       labelText: 'Username',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           await updateUserDetails(
//                             _usernameController.text.trim(),
//                             _emailController.text.trim(),
//                           );
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Profile Updated!')),
//                           );
//                         },
//                         child: Text('Update'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final shouldDelete = await showDialog<bool>(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Delete Account'),
//                               content: Text(
//                                   'Are you sure you want to delete your account? This action is irreversible.'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(false),
//                                   child: Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(true),
//                                   child: Text('Delete'),
//                                 ),
//                               ],
//                             ),
//                           );
//                           if (shouldDelete ?? false) {
//                             await deleteUserAccount();
//                             Navigator.of(context).pop();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         child: Text('Delete Account'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Text('No data');
//           }
//         },
//       ),
//     );
//   }
// }
