import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/chat.dart';
import 'package:recipes/createpost.dart';
import 'package:recipes/main.dart';
import 'package:recipes/recipt.dart';
import 'package:recipes/post.dart';
import 'package:recipes/following_page.dart';
import 'package:recipes/followers_page.dart';

class UserPage extends StatefulWidget {
  final String uidd;

 
  UserPage({required this.uidd});


State<UserPage> createState() => _UserPageState();}

class _UserPageState extends State<UserPage> {


  void initState() {
    super.initState();
    getmyInfo();
    getUserInfo(widget.uidd);
  }

 late bool favorite = true, isLoading = false;

 String imageURL = '';
   Map<String,dynamic> imagelist ={};

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var userDoc,myDoc;
  List<dynamic> following = [];
  List<dynamic> myfollowing = [];
  List<dynamic> userfavorites = [], userposts = [];
  

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
   //following = userDoc.data()['following'] ?? [] as List<String>;
    userfavorites = userDoc.data()['fovarites'] ?? [] as List<dynamic>;
  userposts = userDoc.data()['post'] ?? [] as List<dynamic>;
  print(userposts);

    return userDoc.data()!;
  }

    Future<List> getmyInfo() async {
    
    myDoc = await FirebaseFirestore.instance.collection('users').doc(MyApp.user!.uid).get();
    myfollowing = myDoc.data()['following'] ?? [] as List<dynamic>;

    

    return myDoc.data()['following'] ?? [] as List<dynamic>;

  }



  Future<void> loadImage(String id) async {


  try {
      String? imag = "";
 
     DocumentSnapshot recipeSnapshot =
        await FirebaseFirestore.instance.collection('repices').doc(id).get();
    if (recipeSnapshot.exists) {
      imag = recipeSnapshot.get('ImageName');
    }
    
    Reference ref = FirebaseStorage.instance.ref(imag);
    String downloadURL = await ref.getDownloadURL();
    setState(() {
      imageURL = downloadURL;
      imagelist[id]=imageURL;
     
    });
  } catch (error) {
    print("Error loading image: $error");
    
  }
}  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserInfo(widget.uidd),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not found'));
          } else {
            var user = snapshot.data!;
            var username = user['username'] ?? 'No username';
            var email = user['email'] ?? 'No email';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {print("object");
                        
                         final picker = ImagePicker();
                         final pickedFile = await picker.getImage(source: ImageSource.gallery);
                         if (pickedFile != null) {
     final FirebaseStorage  _storage =  FirebaseStorage.instance;
      late Reference reference;
       String gImage = 'defl.png';
      File  _imageFile = File(pickedFile.path);
     
String originalFileName = pickedFile.path.split('/').last;
      String fileName = originalFileName;
      int counter = 1;
            while (await _storage.ref().child(fileName).getDownloadURL().then((url) => url != null).catchError((error) => false)) {
        String extension = originalFileName.split('.').last;
        String baseName = originalFileName.substring(0, originalFileName.lastIndexOf('.'));
        fileName = '${baseName}_$counter.$extension';
        counter++;
      }

  
       reference = _storage.ref().child('$fileName');
  
         gImage = fileName;
       
       
       UploadTask uploadTask = reference.putFile(_imageFile);
       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // // Get download URL of uploaded image
       String imageUrl = await taskSnapshot.ref.getDownloadURL();
      user['avatarUrl'] = imageUrl;
      users.doc(widget.uidd).update({'avatarUrl': imageUrl});
      
    }
                        
                        },
                        child: 
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user['avatarUrl'] ?? '____'),
                        
                      ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 148, 148, 148),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                           children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowersPage(followers: user['followers'] ?? []),
                                  ),
                                );
                              },
                              child: _buildInfoColumn('Followers', user['followers'] ?? []),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowersPage(followers: user['following'] ?? []),
                                  ),
                                );
                              },
                              child: _buildInfoColumn('Following', user['following'] ?? []),
                            ),
                            SizedBox(width: 16),
                            _buildInfoColumn('Posts', user['posts'] ?? []),
                          ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 100,
                  child: 
                  Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  color: Theme.of(context).colorScheme.inversePrimary,
  elevation: 0.0,
  margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 0.0),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 10,),
        FloatingActionButton(
          heroTag: 'seaarsssxzxxxxxddxschjj',
          onPressed:
           (){
            setState(() {
              
//                             Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) =>  PostWidget(postId: 'ioCeNXGEvMSgmBz1rs7C'),
//   ),
// );
           
           favorite = !favorite; 
             
             });
           },
          child: Icon(Icons.favorite)
          
          
          ),FloatingActionButton(
            heroTag: 'seaarasdasschjj',
          onPressed:
           (){

              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) =>  ChatPage(userId: widget.uidd),
  ),
);

            setState(() {
              
              
            });
           },
          child: Icon(Icons.gesture)
          
          
          ),
          FloatingActionButton(
            heroTag: 'seaaxxzrschjj',
          onPressed:
           (){

                            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) =>  AddPost(),
  ),
);

            setState(() {
              
           
             });
           },
          child: Icon(Icons.edit)
          
          
          ),
          FloatingActionButton(
            heroTag: 'seaaweqeqwrschjj',
          onPressed:
           (){

                   
                    List<dynamic> myfollowing = (myDoc.data()['following'] ?? [] as List<dynamic>) as List<dynamic>;
                     List<dynamic> followers = (myDoc.data()['followers'] ?? [] as List<dynamic>) as List<dynamic>;
                    if (myfollowing.contains(widget.uidd)) {
                      myfollowing.remove(widget.uidd);
                     // followers.remove(widget.uidd);
                    } else {
                      myfollowing.add(widget.uidd);
                     // followers.add(widget.uidd);
                    }

                    

                    print(myfollowing);
                    FirebaseFirestore.instance.collection('users').doc(MyApp.user!.uid).update({'following': myfollowing});
                   // FirebaseFirestore.instance.collection('users').doc(widget.uidd).update({'followers': myfollowing});

            setState(() {
              getmyInfo();


             
 });
           },
          child: Icon(Icons.add_alert)
          
          
          ),

SizedBox(width: 10,)
      ]
    ),
  ),
),
                  )
                  ,
                  
                  Expanded(
                    child: _buildlists()
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }


  Widget _buildlists() {
    
    if (favorite){


      
              print(userfavorites);
       if (isLoading == false && userfavorites.length > 0){
     
       for (String id in userfavorites){

              loadImage(id);
              
            }
        isLoading = true;
        
       }
      


    return ListView.builder(



      itemCount: userfavorites.length,  
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height:155 ,
          child: ElevatedButton(
            
        
            style: ElevatedButton.styleFrom(  
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0), 
                
    ),
  ),
            onPressed: () {Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => recipt(idd: userfavorites[index]),
  ),
);},
            child:   Row(
              
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [if(imagelist.length >= index+1 )
                  isLoading && imagelist[userfavorites[index]] != null
                    ?  Image.network(
                    imagelist[userfavorites[index]],
                    fit: BoxFit.cover,
                    
                    width: 120.0,
                    height: 120.0,
                    )
                    : CircularProgressIndicator(), 
                  Expanded(child:
                  Text("  ${userfavorites[index]}",
                  style: TextStyle(color: Color.fromARGB(255, 9, 3, 3)),
                  ),
                  ),
              

                ],
              ),
         

            
          ),
        );
      },
    );
    
    }
    else{
      return ListView.builder(
                      itemCount: userposts.length,///(user['postList'] as List<dynamic>).length,
                      itemBuilder: (context, index) {
                        //var postList = user['postList'] as List<dynamic>;
                        print(userposts[index]);
                        
                        return PostWidget(postId: userposts[index]);
                      },
                    );
    }
  }

  Widget _buildInfoColumn(String label, List<dynamic> xx) {
    
    int count = xx.length ?? 0;

    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 171, 171, 171),
          ),
        ),
      ],
    );
  }
}


