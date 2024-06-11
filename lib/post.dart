import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/main.dart';
import 'package:recipes/user_page.dart';

class PostWidget extends StatefulWidget {
  final String postId;

  const PostWidget({Key? key, required this.postId}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String avatar = ' ';
  String text = "";
  String imag = "";
  String uider = " ";
  String usename = ' ';
  List<dynamic> likelist = [],postes = [];

  Future<void> getInfo(String uid) async {
    var userDoc = await FirebaseFirestore.instance.collection('posts').doc(uid).get();
    text = userDoc.data()?['text'] ?? ' ';
    imag = userDoc.data()?['ImageName'] ?? 'No image';
    uider = userDoc.data()?['user'] ?? " ";
    likelist = userDoc.data()?['like'] ?? [];

    userDoc = await FirebaseFirestore.instance.collection('users').doc(uider).get();
    avatar = userDoc.data()?['avatarUrl'] ?? 'No avatar';
    usename = userDoc.data()?['username'] ?? 'No username';
    postes = userDoc.data()?['posts'] ?? [];
    

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfo(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    if (uider !=  " "){
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 204, 167), // Background color for each comment
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10), // Rounded corners for each comment
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to user page with the provided uid
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage(uidd: uider),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatar),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(usename),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(text),
                  SizedBox(height: 5),
                  imag.length > 0 ? Image(image: NetworkImage(imag), fit: BoxFit.cover) : Text(""),
                  //Image(image: NetworkImage(imag), fit: BoxFit.cover),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          setState(() {
                            if (likelist.contains(MyApp.uid)) {
                              likelist.remove(MyApp.uid);
                            } else {
                              likelist.add(MyApp.uid);

                            }
                            FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({'like': likelist});
                            getInfo(widget.postId);
                          });
                          
                        },
                      ),
                      Text("${likelist.length}"),
                      if (uider == MyApp.user!.uid)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            
                            FirebaseFirestore.instance.collection('posts').doc(widget.postId).delete();
                            postes.remove(widget.postId);
                            FirebaseFirestore.instance.collection('users').doc(uider).update({'posts': postes});
                          });
                        },
                        icon: Icon(Icons.delete),
                        )

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  else{
    return Text(" ");
  }
  }
}
