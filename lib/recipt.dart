import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipes/home.dart';
import 'package:recipes/main.dart';


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
CollectionReference recipes =  FirebaseFirestore.instance.collection('repices');
bool isLoading = false;
Card compFirst = Card(
  
);
//List<String> favlist = MyApp.favlist;


  @override
  void initState() {
    super.initState();
    loadI(widget.idd);
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
        childCount: imagelist.length+steplist.length+1, // +1 is for compFirst card
    ),
),
        ]
      ),
    );
  }
}