

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/main.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _ingredientController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _stepController = TextEditingController();
  Map<String, String> ingredients = {};
  Map<String, String> steps = {};
  String time = '';
  String calories = '';
  String iddokument = '';
  int green = 0; 
  String veryfiName = 'Name';
  String gImage = 'defl.png';
 String sImage = '';
  late Reference reference;
   Map<String, Reference> referenceStep = {};

final FirebaseStorage _storage = FirebaseStorage.instance;
  late File _imageFile;

   String imageUrl = '';
  Map<String, File> _imageFileStep = {};

Future<void> createPost() async {
  CollectionReference recipes = FirebaseFirestore.instance.collection('posts');

   CollectionReference ussers = FirebaseFirestore.instance.collection('users');
var userDoc = await FirebaseFirestore.instance.collection('users').doc(MyApp.uid).get();
   //following = userDoc.data()['following'] ?? [] as List<String>;
   List<dynamic> posts = userDoc.data()?['post'] ?? [] as List<dynamic>;

  
  

  Map<String, dynamic> newrecipes = {};
  newrecipes.addAll(ingredients);
  
  Map<String, String> stepformated = {};
  int i = 0;
  for (String step in steps.keys) {
    stepformated["step${i}"] = step;
    if (steps[step] != "") {
    stepformated["imageName${i}"] = steps[step]!;}
    i++;
  }
  
  
 

  try {
    // Add recipe
    DocumentReference docRef = await recipes.add(
      {"text": iddokument,
      "ImageName": imageUrl ,
      "user": MyApp.uid,}
    );

  
   String docId = docRef.id;

   posts.add(docId);

   ussers.doc(MyApp.uid).update({"post": posts});
  

    print("Recipe Added");

 
    
    print("Component Documents Added");
  } catch (error) {
    print("Failed to add recipe or components: $error");
  }
 
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add Post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Post', style: TextStyle(fontSize: 18.0)),
                Column(
                  children: ingredients.entries.map((entry) {
                    return ListTile(
                      title: Text('${entry.key} - ${entry.value}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            ingredients.remove(entry.key);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
               
              
                SizedBox(height: 16.0),
               // Text('text:', style: TextStyle(fontSize: 18.0)),
                Column(
             //     children:
//                    steps.keys.toList().asMap().entries.map((entry) {
//                     return  Card(
                      
//                       child:  Row(
//                         children: [  Expanded(child: Text(entry.value)),IconButton( // add step
//   onPressed: () async {
    
//     // Choose image from gallery
//     if (steps[entry.value] != "") {
//       setState(() {
//         steps[entry.value] == "";
//       });
//     }
//     else{
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     // Upload image to Firebase Storage
//     if (pickedFile != null) {
//       setState(() {
//         _imageFileStep[entry.value] = File(pickedFile.path);
//       });
// String originalFileName = pickedFile.path.split('/').last;
//       String fileName = originalFileName;
//       int counter = 1;
//             while (await _storage.ref().child(fileName).getDownloadURL().then((url) => url != null).catchError((error) => false)) {
//         String extension = originalFileName.split('.').last;
//         String baseName = originalFileName.substring(0, originalFileName.lastIndexOf('.'));
//         fileName = '${baseName}_$counter.$extension';
//         counter++;
//       }

  
//        referenceStep[entry.value] = _storage.ref().child('$fileName');
//        setState(() {
//          sImage = fileName;
//           steps[entry.value] = fileName;
//        });
       
//       // UploadTask uploadTask = reference.putFile(_imageFile);
//       // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

//       // // Get download URL of uploaded image
//       // String imageUrl = await taskSnapshot.ref.getDownloadURL();

      
      
//     }}
//   },
//   icon:  steps[entry.value] != "" ? Icon(Icons.photo_library) : Icon(Icons.library_add),
// ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () {
//                               setState(() {
                                
//                                 steps.remove(entry.value);
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
                ),
                Row(
                  children: [
                    // Expanded(
                    //   child:
                    // TextField(
                    //   controller: _stepController,
                    //   decoration: InputDecoration(labelText: 'Add Step'),
                    // ),),
                                                        
                  ],
                ),
                // ElevatedButton(
                //   onPressed: _addStep,
                //   child: Text('Add Step'),
                // ),
              //  SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: 
                    TextField(
                      onChanged: (value) {iddokument = value;
                      },
                      decoration: InputDecoration(labelText: "Text"),
                    ),
                    ),
                                       ElevatedButton(
  onPressed: () async {
    // Choose image from gallery
    if (gImage != "defl.png") {
      setState(() {
        gImage = "defl.png";
      });
    }
    else{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    // Upload image to Firebase Storage
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
       setState(() {
         gImage = fileName;
       });
       
       UploadTask uploadTask = reference.putFile(_imageFile);
       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // // Get download URL of uploaded image
      imageUrl = await taskSnapshot.ref.getDownloadURL();

      
      
    }}
  },
  child: gImage != "defl.png" ? Icon(Icons.photo_library) : Icon(Icons.library_add),
),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) => time = value,
                  decoration: InputDecoration(labelText: 'teg'),
                ),
                SizedBox(height: 16.0),
                
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    
                    backgroundColor: green == 1 ?MaterialStateProperty.all(Colors.green):green == 2 ? MaterialStateProperty.all(Colors.red) : MaterialStateProperty.all(Color.fromARGB(255, 229, 243, 255)),
                  ),
                  onPressed: () async{
                    green = -1;
                    if (gImage != "defl.png") {
                    UploadTask uploadTask = reference.putFile(_imageFile);
                     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);}
                     for (String step in steps.keys) {
                      if (steps[step] != "") {
                        File s = new File("path");
                        if (_imageFileStep[step] != null){
                         setState(() {
                           
                          s = _imageFileStep[step]!; });
                        }
                       UploadTask uploadTask = referenceStep[step]!.putFile(s);
                       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
                       }
                     }
                    setState(() {
                      
                    
                    try {
                    createPost();
                     

      // Get download URL of uploaded image
      // String imageUrl = await taskSnapshot.ref.getDownloadURL();
                    green = 1;
                    } catch (e) {
                      green = 2;
                    }});
                  },
                  child: green == 0 ? Text('Post') : green == 1 ? Text('Posted successfully') :green == -1 ? CircularProgressIndicator(strokeAlign: 0.02,) : Text('!error!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
