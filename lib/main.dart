import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/home.dart';
import 'package:recipes/search.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // CollectionReference users = FirebaseFirestore.instance.collection('repices');
  // users.doc('12').get().then((DocumentSnapshot documentSnapshot){print('Document data: ${documentSnapshot.data()}');});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 150, 52)).copyWith(background: const Color.fromARGB(255, 32, 32, 32)),
          primaryColor: Color.fromARGB(255, 255, 130, 58),
          textTheme: TextTheme(
          headlineMedium: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 254, 254, 254)),),
              
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
      
    },

      
    );
  }
}

