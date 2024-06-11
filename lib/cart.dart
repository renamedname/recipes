import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/home.dart';
import 'package:recipes/main.dart';


class cartt extends StatefulWidget {
  cartt({Key? key}) : super(key: key);
  
  @override
  State<cartt> createState() => _cartt();
}

class _cartt extends State<cartt> {
  String imageURL = '';
  CollectionReference users = FirebaseFirestore.instance.collection('component');
  static Map<String, dynamic> componentiks = {};


  List<String> imagelist =[];
  List<String> steplist =[];
  Map<String, Color> colorMap = {};
  String addkey = "tap to change";
  String addvalue = "0";
  String kalor = "0";

  CollectionReference recipes =  FirebaseFirestore.instance.collection('repices');
  bool chang = false;

  //List<String> favlist = MyApp.favlist;
  void _incrementCounter() {
    setState(() {

    });
  
  }

  @override
  void initState() {
    super.initState();
    componentiks = MyApp.componentikss;
  }



String similaryti({String a = "", String b = ""})   {
    String wynik = "";
    if (a == "" && b == ""){
      return wynik;
    }
    if (a == ""){
      return b;
    }else if (b == ""){
      return a;
    }
    a = a.toLowerCase();
    b = b.toLowerCase();
    if (a == b){
      wynik = a ;
      return wynik;
    }
    if(a.length > b.length){

      if(a.startsWith(b)){
        wynik = b+"\\"+a.substring(b.length);
      }
    }else if(a.length < b.length){
      if(b.startsWith(a)){
        wynik = a+"\\"+b.substring(a.length);
      }
    }
    else if(a.length == b.length){
      if(a.substring(0,b.length-1) == b.substring(0,b.length-1)){
        wynik =  a+"\\"+b.substring(b.length-1);
      }
    }
          return wynik;  
  }

  void findComponents() async {
    Map<String, dynamic> componentes = {};
    CollectionReference users =  FirebaseFirestore.instance.collection('repices');
    for (String documentId in MyApp.cartlist) {
      DocumentSnapshot querySnapshot = await users.doc(documentId).get();
      Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if(key != "instr" && key != "ImageName" && key != "name" && key != "_time" && key != "kalorie"){
          List<String> listvalue = value.split(' ');
          
          if (componentes.containsKey(key))
          
          {List<String> listcom = componentes[key].split(' ');
            
            if(listvalue.length == 2 && listcom.length == 2 ){
              if(listcom[1] == listvalue[1]){

              componentes[key] =  (double.parse(listcom[0]) + double.parse(listvalue[0])).toString() + " " + listcom[1];

              }else{
                int minl = listcom[1].length<listvalue[1].length?listcom[1].length:listvalue[1].length;
                if(listcom[1].substring(0,minl-1) == listvalue[1].substring(0,minl-1)){

                  componentes[key] =  (double.parse(listcom[0]) + double.parse(listvalue[0])).toString() + " " +
                   similaryti(a: (listcom.length > 1 ? listcom[1] : ""), b: (listvalue.length > 1 ? listvalue[1] : ""));
                
                }
                componentes[key] += " + "+value; 
              }
            }else{
              
              componentes[key] += " + "+value; 
            }
           
          }else{
            bool nis = false;
            List<String> keysstart = componentes.keys.toList();
            for (int i = 0; i < keysstart.length; i++) {
              
              if (keysstart[i].substring(0,keysstart[i].length-1).contains(key.substring(0,key.length-1))) {
                
                componentes[keysstart[i]] = (double.parse(componentes[keysstart[i]].split(' ')[0]) + double.parse(value.split(' ')[0])).toString() + " " 
                + similaryti(a: (componentes[keysstart[i]].split(' ').length > 1? componentes[keysstart[i]].split(' ')[1]: ""), b: (value.split(' ').length > 1? value.split(' ')[1]: ""));//(componentes[keysstart[i]].split(' ').length > 1 ? componentes[keysstart[i]].split(' ')[1] : "");
                nis = true;
                break;
              }
            }
            if(!nis){
              componentes[key] = value; 
            }

          }
          }else if(key == "kalorie"){
            setState(() {
            kalor =( double.parse(kalor) + double.parse(value)).toString();
            }
            );
          }
      });
    
      setState(() {
        componentiks = componentes;
        MyApp.componentikss = componentes;
      });
    }
  }


  late bool sea = false;

  @override
  Widget build(BuildContext context) {

    Scaffold s =Scaffold();
    if(chang== false) {s  =Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: componentiks.length,
        itemBuilder: (context, index){
          print(componentiks);

          String key = componentiks.keys.elementAt(index);
          return Card(
            color: colorMap[key],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(" ${key}     ---     ${componentiks[key].toString()} "),
               
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    setState(() {
                      if(colorMap[key] == Colors.green){colorMap[key] = Colors.white;}
                      else
                      {colorMap[key] = Colors.green;}

                    });
                  },
                )
              ],
            )

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'car nnnnt',
        onPressed: () {
          setState(() {
            chang = true;
          });
          
        },
        child: Icon(Icons.draw),
        backgroundColor: Colors.green,
      ),
    );}

    if(chang == true){
   s  =Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shopping List'),
      ),
      body: Column(
        children: [
          Expanded(child: 
          ListView.builder(
            itemCount: componentiks.length,
            itemBuilder: (context, index){
              
          
              String key = componentiks.keys.elementAt(index);
              return Card(
                color: colorMap[key],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Expanded(
                      child: TextField(
                        controller: TextEditingController()..text = key.toString(),
                        onChanged: (value) => 
                          addkey = value,
                        
                      )
                    ),
                    Text("      -----     ")
                    ,
                    Expanded(
                      child: TextField(
                        controller: TextEditingController()..text = componentiks[key].toString(),
                        onChanged: (value) => 
                          addvalue = value,
                       
                      )),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          componentiks.remove(key);
          
                        });
                      },
                    )
                  ],
                )
          
              );
            },
          ),),
          FloatingActionButton(
            heroTag: 'car nnnnjt',
        onPressed: () {
          setState(() {
            if(addkey != "tap to change" || addvalue != "0"){
              componentiks[addkey] = addvalue;
              addkey = "tap to change";
              addvalue = "0";
            }else{
            componentiks["tap to change"] = "0";}
        });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      SizedBox(height: 10),
           FloatingActionButton(
            heroTag: 'cnt',
        onPressed: () {
          setState(() {
            findComponents();
        });
        },
        child: Icon(Icons.arrow_circle_up),
        backgroundColor: Colors.green,
      ),
      SizedBox(height: 10),
      Text("suma kalorij : ${kalor}"
      ,
      style: TextStyle(color: Colors.white ),)
      ,
      SizedBox(height: 10),
          Expanded(child: 
          ListView.builder(
            itemCount: MyApp.cartlist.length,
            itemBuilder: (context, index){

              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${MyApp.cartlist[index]}  "),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          MyApp.cartadd(MyApp.cartlist[index]);
                        });
                      },
                    )
                  ],
                )
              );
              }
          ),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'c,MNBNMBMNn',
        onPressed: () {
          setState(() {
            if(addkey != "tap to change" || addvalue != "0"){
              componentiks[addkey] = addvalue;
              addkey = "tap to change";
              addvalue = "0";
            }
          chang = false;
        });
        },
        child: Icon(Icons.draw),
        backgroundColor: Colors.green,
      ),
    );
    }
    return s;
  }
}