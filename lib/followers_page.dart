import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/user_page.dart';

class FollowersPage extends StatefulWidget {
  final List<dynamic> followers;

  FollowersPage({required this.followers});

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<dynamic> coments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    for (var follower in widget.followers) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(follower).get();
      if (userDoc.exists) {
        var user = userDoc.data()!;
        coments.add({'username': user['username'], 'avatarUrl': user['avatarUrl'], 'uid': follower});
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('People'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(7),
              child: ListView.builder(
                itemCount: coments.length,
                itemBuilder: (context, index) {
                  var commentData = coments[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 204, 167),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10), 
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                 
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserPage(uidd: commentData['uid']),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(commentData['avatarUrl']),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(commentData['username']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
