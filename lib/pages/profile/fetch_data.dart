import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserInfo extends StatelessWidget {
  final String documentId;

  GetUserInfo({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(documentId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("User not found");
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${data['first name']} ${data['last name']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "${data['email']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "${data['age']} years old",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
