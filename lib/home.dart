import 'package:flutter/material.dart';
import 'package:recipes/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes/search.dart';




late List l = [];

class MyHomePage extends StatefulWidget {
  const MyHomePage(String s, {super.key, required this.title});


  final String title;
 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? hh;
  bool menuu = true;
  late Scaffold s;
  CollectionReference users = FirebaseFirestore.instance.collection('repices');
  // users.doc('12').get().then((DocumentSnapshot documentSnapshot){print('Document data: ${documentSnapshot.data()}');});

  //   void initdatabase() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }
  
  

  void _incrementCounter() {
    setState(() {
     
    });

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
      itemCount: l.length,
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
              child: Text(l[index],
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
        onPressed: (){setState(() {menuu = false;}); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){setState(() {menuu = true;});},
        tooltip: 'Dement',
        child: const Icon(Icons.menu),
      )
    ],
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, 
    );







if (menuu == true){
    s = Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
      ),
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'ilosc',
            ),
            Text(
              '(^◕ᴥ◕^)    ฅ^•ﻌ•^ฅ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
    
      SizedBox(
        width: 300,
       child: FloatingActionButton( 
        onPressed: (){},
        tooltip: 'Dement',
        child: const Icon(Icons.abc_outlined),  
    ),
    ),


      SizedBox(
        width: 300,
       child: FloatingActionButton( 
        onPressed: (){},
        tooltip: 'Dement',
        child: const Icon(Icons.abc),  
    ),
    ),
      
      SizedBox(
        width: 300,
        child: FloatingActionButton(
          onPressed: (){Navigator.pushNamedAndRemoveUntil(context, "/menu", (route) => false);},
          tooltip: 'Dement',
          child: const Icon(Icons.ac_unit),
        ),
      ),
      SizedBox(
        width: 300,
        child: FloatingActionButton(
          onPressed: (){Navigator.pushNamedAndRemoveUntil(context, "/menu", (route) => false);},
          tooltip: 'Dement',
          child: const Icon(Icons.access_time),
        ),
      )
          ],
        ),
      ),
      
bottomNavigationBar: BottomAppBar(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){setState(() {menuu = false;}); },
        tooltip: 'Decrement',
        child: const Icon(Icons.home),
      ),

      SizedBox(width: 50),
      FloatingActionButton(
        onPressed: (){setState(() {menuu = true;});},
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

