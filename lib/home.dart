import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes/recip.dart';
import 'package:recipes/recipt.dart';
import 'package:recipes/search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipes/recipt.dart';
import 'package:recipes/favorite.dart';
import 'dart:io';




late List l = [];

class MyHomePage extends StatefulWidget {
  const MyHomePage(String s, {super.key, required this.title});


  final String title;
 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? hh;
  String imageURL = '';
  bool menuu = true;
  bool favor = false;
  late Scaffold s;
  CollectionReference users = FirebaseFirestore.instance.collection('repices');
  List<String> fl =[];
  Map<String,dynamic> imagelist ={};
  bool isLoading = false;
  bool menufav = false;
  int idmenufav = -1;
  
  // users.doc('12').get().then((DocumentSnapshot documentSnapshot){print('Document data: ${documentSnapshot.data()}');});

  //   void initdatabase() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }
  

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


  void _incrementCounter() {
    setState(() {
     
    });

  }
static void favadd(String id) async {
      String filePath = "fav.txt";
      // Read the file
      File file = new File(filePath);
      String fileContent = await file.readAsString();
      
      if (!fileContent.contains(id)) {
          await file.writeAsString('$fileContent\n$id', mode: FileMode.write);
      }
      
  }

  late Map hh2;
  var hhh;
  String searchTerm = '';

 void _buildlist() async {
  List tempList = [];
  CollectionReference users =  FirebaseFirestore.instance.collection('repices');
  QuerySnapshot querySnapshot = await users.get();

  querySnapshot.docs.forEach((doc) {
    String documentId = doc.id;
    if (documentId.contains(searchTerm)) {
      tempList.add(documentId);
    }
  });

  setState(() {
    l = tempList;
  });
}

  

  @override
  Widget build(BuildContext context) {
   
  

   if ( menuu == false && favor == false){
    setState(() {
      //imagelist = [];
       if (isLoading == false && l.length > 0){
     
       for (String id in l){

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
               
                l=[];
                _buildlist(); 
                 imagelist = {};
                 isLoading = false;
       
              });
              
            },
            decoration: InputDecoration(
              labelText: 'Search',
            ),
          ),
          ),
           FloatingActionButton(
            heroTag: 'seaamm,mnr',
          onPressed: (){Navigator.pushNamedAndRemoveUntil(context, "/search", (route) => false);},
          tooltip: 'Dement',
          child: const Icon(Icons.saved_search_rounded),
        ),
          ],


        ),

        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Expanded(child: ListView.builder(
      itemCount: l.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height:155 ,
          child: ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), 
    ),
  ),
            onPressed: () {Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => recipt(idd: l[index]),
  ),
);},
            child:   Row(
                
                children: [if(imagelist.length >= index+1 )
                  isLoading && imagelist[l[index]] != null
                    ?  Image.network(
                    imagelist[l[index]],
                    fit: BoxFit.cover,
                    width: 120.0,
                    height: 120.0,
)
                    : CircularProgressIndicator(), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      Text("      ${l[index]}",),
                    ],
                  ),
                 // style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                 
                  
                ],
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
        heroTag: 'searcjkjkhxz',
        onPressed: (){setState(() {
         menuu = false;
         favor = false; 
          });},
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ),
      SizedBox(width: 50),
      FloatingActionButton(
        heroTag: 'jjkkkkkkkkkkkkk',
        onPressed: (){setState(() {
           menuu = false;favor = true; isLoading = false;
          }); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        heroTag: 'ressultzjjxckkax',
        onPressed: (){setState(() {menuu = true;favor=false;});},
        tooltip: 'Dement',
        child: const Icon(Icons.menu),
      )
    ],
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
    );


   }



///////////////////////////////////////  menuu ////////////////////////////////////////////////////////////////
if (menuu == true){
    s = Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
      ),
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Text(
              'ฅ^•ﻌ•^ฅ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
    
    SizedBox(
        width: 300,
       child: FloatingActionButton( 
        heroTag: 'searagggvbcsdwch',
        onPressed: (){Navigator.pushNamed(context, "/add");},
        tooltip: 'Dement',
        child: Text("add recipe"),

    ),
    ),
      SizedBox(
        width: 300,
        child: FloatingActionButton(
          heroTag: 'seaarschjj',
          onPressed: (){Navigator.pushNamedAndRemoveUntil(context, "/search", (route) => false);},
         
          child: Text("componet search"),
        ),
      ),
      SizedBox(
        width: 300,
       child: FloatingActionButton( 
        heroTag: 'searasdwch',
        onPressed: (){},
        tooltip: 'Dement',
        child: Text("Settings"),

    ),
    ),


      SizedBox(
        width: 300,
       child: FloatingActionButton( 
        heroTag: 'searwch',
        onPressed: (){},
        tooltip: 'Dement',
        child: Text("donate"),    
    ),
    ),
      
      
      
          ],
        ),
      ),
      
bottomNavigationBar: BottomAppBar(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FloatingActionButton(
        heroTag: 'searcjkjkhxz',
        onPressed: (){setState(() {
         menuu = false;
         favor = false;
          });},
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ),
      SizedBox(width: 50),
      FloatingActionButton(
        heroTag: 'jjkkkkkkkkkkkkk',
        onPressed: (){setState(() {
           menuu = false;favor = true; isLoading = false;
          }); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        heroTag: 'ressultzjjxckkax',
        onPressed: (){setState(() {menuu = true;favor=false;});},
        tooltip: 'Dement',
        child: const Icon(Icons.menu),
      )
    ],
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
    );


    }


    ///////////////////////////////////////  favorite ////////////////////////////////////////////////////////////////
    if (menuu == false && favor == true){


            setState(() {    
              print(MyApp.favlist);
       if (isLoading == false && MyApp.favlist.length > 0){
     
       for (String id in MyApp.favlist){

              loadImage(id);
              
            }
        isLoading = true;
        
       }
      });
        

         s = Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Favorites"),
           FloatingActionButton(
            heroTag: 'sejkkkkkkkkkkkkaraa',
          onPressed: (){Navigator.pushNamed(context, "/cart");},
          tooltip: 'Dement',
          child: const Icon(Icons.shopping_cart_rounded),
        ),
          ],//children
        ),

        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
              Expanded(child: ListView.builder(
      itemCount: MyApp.favlist.length,  
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
    builder: (context) => recipt(idd: MyApp.favlist[index]),
  ),
);},
            child:   Row(
              
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [if(imagelist.length >= index+1 )
                  isLoading && imagelist[MyApp.favlist[index]] != null
                    ?  Image.network(
                    imagelist[MyApp.favlist[index]],
                    fit: BoxFit.cover,
                    
                    width: 120.0,
                    height: 120.0,
                    )
                    : CircularProgressIndicator(), 
                  Expanded(child:
                  Text("  ${MyApp.favlist[index]}",
                  style: TextStyle(color: Color.fromARGB(255, 9, 3, 3)),
                  ),
                  ),
               Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
  if( idmenufav == index) IconButton(
  
  icon: Icon(Icons.delete),
  onPressed: () {
    MyApp.favadd(MyApp.favlist[index]);
    setState(() {
      
    });
  },),

  IconButton(
  icon: Icon(Icons.menu),
  onPressed: () {
    setState(() {
  if(idmenufav == index) idmenufav = -1;else idmenufav = index;

 });
  },
),

  if(idmenufav == index) IconButton(
  icon: Icon(MyApp.cartlist.contains(MyApp.favlist[index]) ? (Icons.add_shopping_cart) : (Icons.remove_shopping_cart)),
  onPressed: () {
    setState(() {
      MyApp.cartadd(MyApp.favlist[index]);
    });
 
  },),])

                ],
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
        heroTag: 'searcjkjkhxz',
        onPressed: (){setState(() {
         menuu = false;
         favor = false;
          });},
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ),
      SizedBox(width: 50),
      FloatingActionButton(
        heroTag: 'jjkkkkkkkkkkkkk',
        onPressed: (){setState(() {
           menuu = false;favor = true; isLoading = false;
          }); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        heroTag: 'ressultzjjxckkax',
        onPressed: (){setState(() {menuu = true;favor=false;});},
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

