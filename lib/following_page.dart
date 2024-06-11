import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingPage extends StatelessWidget {
  final List<dynamic> following;

  FollowingPage({required this.following});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: ListView.builder(
        itemCount: following.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(following[index]).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('User not found');
                } else {
                  var user = snapshot.data!;
                  return Text(user['username']);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
