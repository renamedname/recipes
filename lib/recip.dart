import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipes/search.dart';

class RecipeInstructionPage extends StatelessWidget {
  final String id;

  const RecipeInstructionPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Instructions'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('repices').doc(id).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          Map<String, dynamic> instructions = data['instr'] ?? 'Instructions not available';
          return Padding(
  padding: EdgeInsets.all(16.0),
  child: ListView.builder(
    itemCount: instructions.length,
    itemBuilder: (BuildContext context, int index) {
      String key = instructions.keys.elementAt(index);
      dynamic value = instructions[key];
      return ListTile(
        title: Text(key),
        subtitle: Text(value.toString()),
      );
    },
  ),
);
        },
      ),
    );
  }
}
