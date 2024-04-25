import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes/recip.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/home.dart';
import 'package:recipes/search.dart';
import 'package:recipes/result.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipes/favorite.dart';
import 'package:recipes/cart.dart';
import 'package:recipes/recip.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // CollectionReference users = FirebaseFirestore.instance.collection('repices');
  // users.doc('12').get().then((DocumentSnapshot documentSnapshot){print('Document data: ${documentSnapshot.data()}');});
  
  runApp(const MyApp());
  MyApp.favadd('-None00101');
  MyApp.cartadd('-None00101');
  createRecipe();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  static List<String> favlist =[];
  static List<String> cartlist =[];
  
static Future<void> favadd(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
   favlist = prefs.getStringList('fav') ?? [];
   
  if(id == '-None00101'){return;}

  if (!favlist.contains(id)) {
    
    favlist.add(id);
    await prefs.setStringList('fav', favlist);

  }else{
    favlist.remove(id);
    await prefs.setStringList('fav', favlist);
  }
  
   
}
static Future<void> cartadd(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
   cartlist = prefs.getStringList('cart') ?? [];
  if(id == '-None00101'){return;}
  if (!cartlist.contains(id)) {
    
    cartlist.add(id);
    await prefs.setStringList('cart', cartlist);

  }else{
    cartlist.remove(id);
    await prefs.setStringList('cart', cartlist);
  }
  
   
}

  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      title: 'Flutter',
      theme: ThemeData(
        useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 150, 52)).copyWith(background: const Color.fromARGB(255, 32, 32, 32),secondaryContainer:  Color.fromARGB(255, 255, 237, 212),),
          primaryColor: Color.fromARGB(255, 255, 130, 58),
          cardColor: Color.fromARGB(255, 255, 237, 212),
          textTheme: TextTheme(
          headlineMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
              
      ),
   // builder: (context, child) { 
  //  return Navigator(
     // onGenerateRoute: (settings) {
       // return PageRouteBuilder(
          //pageBuilder: (context, Animation, secondaryAnimation) => child!,
          //transitionDuration: Duration(seconds: 0), // Нулевая продолжительность анимации
         // transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // return child;
         // },
      //  );
    //  },
  //  );
 // },

    initialRoute: "/",
    routes: {
      "/":(context) => MyHomePage("flutter", title: 'fluter',),
      "/search":(context) => searchPage(),
      "/result":(context) => FirestoreImageDisplay(),
       "/add":(context) => AddRecipePage(),
       "/cart":(context) => cartt(),
      
    },

      
    );
  }
}

