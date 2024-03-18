import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/home.dart';


class searchPage extends StatefulWidget {
  const searchPage({super.key});


  
 
  @override
  State<searchPage> createState() => _searchPage();
}

class _searchPage extends State<searchPage> {

CollectionReference users = FirebaseFirestore.instance.collection('component');
String searchTerm = '';
List<String> choiceList = [];
List<String> l = [];
List<String> fl =[];





  void _incrementCounter() {
    setState(() {
     
    });

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

    print(querySnapshot.docs);
     for (var doc in querySnapshot.docs) {
      print(doc.data());
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
                print(searchTerm);
                
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
          setState(() {
            findRecipesWithComponents(choiceList);
            
            sea = true;
          });
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
                print(searchTerm);
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
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1), ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(l[index]),
                 Row(
                   children: [
                      
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
      s = Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [Expanded(child:
        TextField(
          
            onChanged: (value) {
              setState(() {
                searchTerm = value;
                print(searchTerm);
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
              child: Text(fl[index],
              selectionColor: Colors.black,
              ),
            

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
        onPressed: (){ },
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



 
