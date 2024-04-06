

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/home.dart';
import 'package:firebase_storage/firebase_storage.dart';


class searchPage extends StatefulWidget {
  const searchPage({super.key});
  @override
  State<searchPage> createState() => _searchPage();
}

class _searchPage extends State<searchPage> {
String imageURL = '';
CollectionReference users = FirebaseFirestore.instance.collection('component');
String searchTerm = '';
List<String> choiceList = [];
List<String> l = [];
List<String> fl =[];
List<String> imagelist =[];
CollectionReference recipes =  FirebaseFirestore.instance.collection('repices');
bool isLoading = false;


  void _incrementCounter() {
    setState(() {
     
    });

  }



  @override
  void initState() {
    super.initState();
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
      imagelist.add(imageURL);
     
    });
  } catch (error) {
    print("Error loading image: $error");
    
  }
}


void _buildlist() async {
  List<String> tempList = [];
  List fl;
  if (searchTerm.length > 1){
  QuerySnapshot querySnapshot = await users.get();

  querySnapshot.docs.forEach((doc) {
    String documentId = doc.id;
    if (documentId.contains(searchTerm) ) {
      if (!choiceList.contains(documentId)){
      tempList.add(documentId);
      }
    }
  });}

  setState(() {
    l = tempList + choiceList;
  });
}



void findRecipesWithComponents(List<String> selectedComponents) async {
  List<String> foundRecipes = [];


    CollectionReference users =  FirebaseFirestore.instance.collection('repices');
  QuerySnapshot querySnapshot = await users.get();

  
 

  for (String component in selectedComponents) {

   // print(querySnapshot.docs);
     for (var doc in querySnapshot.docs) {
     // print(doc.data());
      var d = doc.data();
       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      if (data.containsKey(component)) {
        if(!foundRecipes.contains(component)){
        foundRecipes.add(doc.id);}
        
      }
    
  }

  }

 setState(() {
  
   fl = foundRecipes.toSet().toList();
 });
  
  
}




late bool sea = false;
 

  @override
  Widget build(BuildContext context) {
    //loadImage();
    Scaffold s;
    if (sea == false){
     s = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( 
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [Expanded(child:
        TextField(
            
            onChanged: (value) {
              setState(() {
                searchTerm = value;
               // print(searchTerm);
                
                _buildlist(); 

              });
            },
            decoration: InputDecoration(
              labelText: 'add components',
            ),
          ),
          ),
           FloatingActionButton(
          onPressed: (){findRecipesWithComponents(choiceList);
          ;
          setState(() {

            findRecipesWithComponents(choiceList);
   
            // for (String id in fl){
            //   loadImage(id);
            // }
            /////////////////////////////////////////////////////////////
            sea = true;
          }
          
          );
          },
          tooltip: 'Dement',
          child: const Icon(Icons.ac_unit),
        ),
          ],
        ),
      ),


      body:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
        TextField(
           style: TextStyle(
                  color: Color.fromARGB(255, 224, 224, 224), 
                ),
            onChanged: (value) {
              setState(() {
                searchTerm = value;
               // print(searchTerm);
                l=[];
                _buildlist(); 

              });
            },
            decoration: InputDecoration(
              labelText: 'Search',
              fillColor: Color.fromARGB(255, 224, 224, 224),
            ),
          
          ),
          
            SizedBox(                                 
              
              width: 420,
              height: 440,
              child:  ListView.builder(
      itemCount: l.length,
      itemBuilder: (BuildContext context, int index) {
        //loadImage();
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1), ),
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    
                    Text(l[index],
                    
                      style: TextStyle(fontSize: 20,color: Colors.black,),
                      
                    ),
                    
                  if(!choiceList.contains(l[index]))


                                    ElevatedButton(
                                 onPressed: () {
                                  choiceList.add(l[index]);
                                   _buildlist();
                                  },
                                 child: const Icon(Icons.add)
                                    ),
                  if(!choiceList.contains(l[index]))
                                     ElevatedButton(
                                 onPressed: () {
                                  choiceList.add(l[index]);
                                   _buildlist();
                                  },
                                 child:const Icon(Icons.remove_circle)
                                    ),
                  if(choiceList.contains(l[index]))
                                   ElevatedButton(
                                 onPressed: () {
                                  choiceList.remove(l[index]);
                                  _buildlist();
                                  },
                                 child:const Icon(Icons.remove)
                                    ),

                   ],
                 ),
            ],
          ),
        );

      },
    ),   
              ),


          ],
        
      ),
     
      
bottomNavigationBar: BottomAppBar(
  color: Theme.of(context).colorScheme.primaryContainer, 
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
            onPressed: (){
              
              
            },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){},
        tooltip: 'Dement',
        child: const Icon(Icons.menu),
      )
    ],
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
    );}


    else



    {
      
        
     setState(() {
       if (isLoading == false && fl.length > 0){
     
       for (String id in fl){
              loadImage(id);
            }
        isLoading = true;
       }
      });   

      s = Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [Expanded(child:
        TextField(
          
            onChanged: (value) {
              setState(() {
                searchTerm = value;
               // print(searchTerm);
                l=[];
                _buildlist(); 

              });
            },
            decoration: InputDecoration(
              labelText: 'Search',
            ),
          ),
          ),
           FloatingActionButton(
          onPressed: (){Navigator.pushNamedAndRemoveUntil(context, "/search", (route) => false);},
          tooltip: 'Dement',
          child: const Icon(Icons.ac_unit),
        ),
          ],


        ),

        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 420,
              height: 480,
              child:  ListView.builder(
      itemCount: fl.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height:150 ,
          child: ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0), 
    ),
  ),
            onPressed: () {print('Button $index pressed');},
            child:  Card(
              child:Row(
                children: [
                  if(imagelist.length >= index+1 )
                  isLoading
                    ?  Image.network(imagelist[index])
                    : CircularProgressIndicator(), //////////////////////////////////////////
                  
                  SizedBox(width: 10),
                  Text(fl[index],
                    style: TextStyle(fontSize: 20,color: Colors.black),
                  
                  ),
                ],
              )
              
            

            ),
          ),
        );
      },
    ),),
          ],
        ),
      ),
      
bottomNavigationBar: BottomAppBar(
  color: Theme.of(context).colorScheme.primaryContainer, 
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
            onPressed: (){
              
              
            },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){setState(() {
          sea = false;
        }); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){},
        tooltip: 'Dement',
        child: const Icon(Icons.menu),
      )
    ],
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
    );
    }
    return s;
  }
}



 
