import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/home.dart';
import 'package:recipes/main.dart';
import 'package:recipes/user_page.dart';


class recipt extends StatefulWidget {
  recipt({Key? key, required this.idd}) : super(key: key);
  String idd ;
  @override
  State<recipt> createState() => _recipt();
}

class _recipt extends State<recipt> {
String imageURL = '';
CollectionReference users = FirebaseFirestore.instance.collection('component');

String searchTerm = '';
List<String> choiceList = [];
List<String> l = [];
List<String> fl =[];
List<String> imagelist =[];
List<String> steplist =[];
var myDoc = null;
CollectionReference recipes =  FirebaseFirestore.instance.collection('repices');
CollectionReference userz =  FirebaseFirestore.instance.collection('users');
bool isLoading = false;
  List<Map<String, dynamic>> comments = [];
TextEditingController commentController = TextEditingController();
Card compFirst = Card(
  
);
//List<String> favlist = MyApp.favlist;


  @override
  void initState() {
    super.initState();
    loadI(widget.idd);
    getmyInfo(widget.idd);
    loadComments() ;
  }


  Future<void> loadComments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('repices')
        .doc(widget.idd)
        .collection('comments')
        .get();

    setState(() {
      comments = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>?) ?? {})
          .toList();
    });
  }

   Future<List> getmyInfo(String whay) async {
    
    

    myDoc = await FirebaseFirestore.instance.collection('users').doc(MyApp.user!.uid).get();
    //myfollowing = myDoc.data()['whay'] ?? [] as List<dynamic>;
    return myDoc.data()['whay'] ?? [] as List<dynamic>;
  }

  Future<void> addComment(String comment) async {

    await FirebaseFirestore.instance
        .collection('repices')
        .doc(widget.idd)
        .collection('comments')
        .add({
      'text': comment,
      'username': myDoc.data()['username'] ?? 'No username',
      'avatarUrl': myDoc.data()['avatarUrl'] ?? 'No avatar',
      'uid': MyApp.user!.uid,
    });

    loadComments();
  }


Future<void> loadI(String id) async {

   DocumentSnapshot rSnapshot =
        await FirebaseFirestore.instance.collection('repices').doc(id).get();
        Reference reff ;
        String firs = "";
        String downl = "";
    if (rSnapshot.exists) {
      Map<String, dynamic> data = rSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> instructions = data['instr'] ?? {' ': ''};
      String kk = "składniki : ";
      String kk2 = "¯\\_(ツ)_/¯      ";
             data.forEach((key, value) {
        
        if (!key.startsWith("ImageName") && !key.startsWith("instr") && !key.startsWith("kalorie") && !key.startsWith("_time")) {
            kk = """${kk}
   ${key}:   ${value}""";
        }
        else if (key.startsWith("ImageName")) {
            firs = value;
        }
        else if (key.startsWith("kalorie")) {
            kk2 = value;
        }
        else if (key.startsWith("_time")) {
            kk2 = """${kk2}
            
czas: ${value}""";
        }
       });

       if (firs != "") {
          Reference reff = FirebaseStorage.instance.ref(firs);
           downl = await reff.getDownloadURL();
      
       }
      compFirst = Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              firs != "" ? Image.network(downl) :
              
              Text(""),

                        
              Padding(
                padding: EdgeInsets.all(8.0),
                child:
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(kk),
                     Text("kalorie: ${kk2}"),
                   ],
                 ),
                
              ),
            ],
          )
        );


       instructions.forEach((key, value) async {
        
      if (key.startsWith("imageName")) {
        
       Reference ref = FirebaseStorage.instance.ref(value);
       String downloadURL = await ref.getDownloadURL();
       

    setState(() {
      imageURL = downloadURL;
      imagelist.add(imageURL);
      
     
    }); 
      }
      else{
        setState(() {
          steplist.add(value);
        });
      }
    });

    }

}

late bool sea = false;

@override
Widget build(BuildContext context) {
  steplist = steplist.reversed.toList();
  
  return Scaffold(
    body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          floating: true,
          title: Text(widget.idd),
          actions: <Widget>[
            SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 'izbr',
              onPressed: () {
                setState(() {
                  MyApp.favadd(widget.idd);

                });
              },
              child: MyApp.favlist.contains(widget.idd)? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 'izsssbr',
              onPressed: () {
                setState(() {
                  MyApp.cartadd(widget.idd);
                });
              },
              child:  (MyApp.cartlist.contains(widget.idd))? Icon(Icons.remove_shopping_cart) : Icon(Icons.add_shopping_cart),
            ),
            SizedBox(width: 10),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: [
                  if (index == 0) compFirst,
                  
                  if (index > 0 && index <= imagelist.length) Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      child: Image.network(imagelist[index-1]),
                    ),
                  ),

                  if (index > 0 && index <= steplist.length) Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(steplist[index-1]),
                    ),
                  ),
                ],
              );
            },
            childCount: imagelist.length + steplist.length + 1, // +1 is for compFirst card
          ),
        ),
SliverPadding(
  padding: EdgeInsets.all(7),
  sliver: SliverList(
    delegate: SliverChildListDelegate(
      [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 250, 201, 156), // Set your desired background color here
            borderRadius: BorderRadius.circular(10),
             // Set the border radius here
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (var commentData in comments)
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
                        SizedBox(height: 5),
                        Text(commentData['text']),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  ),
),


SliverPadding(
  padding: EdgeInsets.all(7),
  sliver: SliverList(
    delegate: SliverChildListDelegate(
      [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 240, 204, 173), // Set your desired background color here
            borderRadius: BorderRadius.circular(10), // Set the border radius here
          ),
          child: Column(
            children: [
              TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Add a comment',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String comment = commentController.text.trim();
                  if (comment.isNotEmpty) {
                    addComment(comment);
                    commentController.clear();
                  }
                },
                child: Text('Post Comment'),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),


      ],
    ),
  );
}
}