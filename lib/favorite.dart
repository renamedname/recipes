

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
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
  Map<String, File> _imageFileStep = {};

Future<void> createRecipe() async {
  CollectionReference recipes = FirebaseFirestore.instance.collection('repices');
  CollectionReference components = FirebaseFirestore.instance.collection('component');
  
  if(!iddokument.isEmpty && !iddokument.contains(recipes.id)){
    
  

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
  
  
   newrecipes["kalorie"] = calories;
  newrecipes["_time"] = time;
  newrecipes["ImageName"] = gImage;
  print(newrecipes);

  try {
    // Add recipe
    await recipes.doc(iddokument).set(
      {"instr": stepformated,},
    );
    await recipes.doc(iddokument).update(
      newrecipes
    );
    print("Recipe Added");

    // Add components
    for (String ingredi in ingredients.keys) {
      await components.doc(ingredi).set({'title': ingredi});
    }
    
    print("Component Documents Added");
  } catch (error) {
    print("Failed to add recipe or components: $error");
  }}
  else{
    setState(() {
      green = 2;
      veryfiName = 'Recipe already exists !!! (dodaj naprzykad "smaczny")';
    });
  }
}



   void veryfi() async {
    var rec = await FirebaseFirestore.instance.collection('repices').get();
    
    List<dynamic> dsa = rec.docs.map((doc) => doc.id).toList();

     setState(() {
      
       if (!dsa.contains(iddokument)){
         veryfiName = 'Name';
       }
       else{
         
         veryfiName = 'Name already exists !!! (add for example "yummy")';
       }
     });
   }


  void _addIngredient() {
    setState(() {
      if (_ingredientController.text.isNotEmpty) {
        ingredients[_ingredientController.text] = _quantityController.text;
        _ingredientController.clear();
        _quantityController.clear();
      }
    });
  }

  void _addStep() {
    setState(() {
      if (_stepController.text.isNotEmpty) {
        

        steps.addAll({_stepController.text: '',});
        _stepController.clear();
        
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add Recipe'),
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
                Text('Ingredients:', style: TextStyle(fontSize: 18.0)),
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ingredientController,
                        decoration: InputDecoration(labelText: 'Ingredient'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        decoration: InputDecoration(labelText: 'Quantity'),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addIngredient,
                  child: Text('Add Ingredient'),
                ),
                SizedBox(height: 16.0),
                Text('Steps:', style: TextStyle(fontSize: 18.0)),
                Column(
                  children: steps.keys.toList().asMap().entries.map((entry) {
                    return  Card(
                      
                      child:  Row(
                        children: [  Expanded(child: Text(entry.value)),IconButton( // add step
  onPressed: () async {
    
    // Choose image from gallery
    if (steps[entry.value] != "") {
      setState(() {
        steps[entry.value] == "";
      });
    }
    else{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    // Upload image to Firebase Storage
    if (pickedFile != null) {
      setState(() {
        _imageFileStep[entry.value] = File(pickedFile.path);
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

  
       referenceStep[entry.value] = _storage.ref().child('$fileName');
       setState(() {
         sImage = fileName;
          steps[entry.value] = fileName;
       });
       
      // UploadTask uploadTask = reference.putFile(_imageFile);
      // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // // Get download URL of uploaded image
      // String imageUrl = await taskSnapshot.ref.getDownloadURL();

      
      
    }}
  },
  icon:  steps[entry.value] != "" ? Icon(Icons.photo_library) : Icon(Icons.library_add),
),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                
                                steps.remove(entry.value);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                    TextField(
                      controller: _stepController,
                      decoration: InputDecoration(labelText: 'Add Step'),
                    ),),
                                                        
                  ],
                ),
                ElevatedButton(
                  onPressed: _addStep,
                  child: Text('Add Step'),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: 
                    TextField(
                      onChanged: (value) {iddokument = value;
                      veryfi();  },
                      decoration: InputDecoration(labelText: veryfiName),
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
       
      // UploadTask uploadTask = reference.putFile(_imageFile);
      // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // // Get download URL of uploaded image
      // String imageUrl = await taskSnapshot.ref.getDownloadURL();

      
      
    }}
  },
  child: gImage != "defl.png" ? Icon(Icons.photo_library) : Icon(Icons.library_add),
),
                  ],
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) => time = value,
                  decoration: InputDecoration(labelText: 'Time'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) => calories = value,
                  decoration: InputDecoration(labelText: 'Calories'),
                ),
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
                    createRecipe();
                     

      // Get download URL of uploaded image
      // String imageUrl = await taskSnapshot.ref.getDownloadURL();
                    green = 1;
                    } catch (e) {
                      green = 2;
                    }});
                  },
                  child: green == 0 ? Text('Save Recipe') : green == 1 ? Text('saved successfully') :green == -1 ? CircularProgressIndicator(strokeAlign: 0.02,) : Text('!error!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
