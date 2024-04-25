import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createRecipe() async {

CollectionReference recipes = FirebaseFirestore.instance.collection('repices');
CollectionReference components = FirebaseFirestore.instance.collection('component');

recipes
  .doc("parokwi ciasto francuskim")
  .set({
    'ciasto francuskie': "1 opakowanie",
    
    'parówki': "8 sztuk",
    'cukinia': "1 sztuka",
    'papryka czerwona': "1 sztuka",
    'pieczarki': "4 sztuki",
    'żółty ser': "8 plastrów",
    "kalorie" : "780",
    'jajko': "1 sztuka",
    "_time" : "40 min",
    "ImageName" : "frpr.png",
    "instr" : {
      "imageName1": "par1.png",
      "imageName2": "par2.png",
      "imageName3": "par3.png",
      "imageName4": "par.png",
      "imageName5": "par5.png",
   
      "step1":"Przygotuj dużą deskę do krojenia. Ciasto francuskie pokrój na 8 równych części przypominających prostokąty.",
      "step2":"Cukinię oraz pieczarki umyj i pokrój w cienkie paski. Paprykę umyj, wydrąż gniazdo z ziarnami i pokrój w cienkie piórka.",
      "step3":"Na każdy kawałek ciasta francuskiego wyłóż kilka plasterków pieczarek oraz cukinii. Posyp je pokruszoną Minikostką Smażona cebula Knorr, a następnie dołóż paprykę i plasterek sera żółtego.",
      "step4":"Na każdy z przygotowanych kawałków ciasta z warzywami połóż po jednej surowej parówce tak, aby jeden i drugi koniec wystawał za ciasto. Zawiń ciasto z dodatkami wokół parówki i połóż na wyłożoną papierem do pieczenia blachę.",
      "step5":"Parówki w cieście francuskim posmaruj roztrzepanym jajkiem i piecz w piekarniku nagrzanym do 180 °C przez około 20 minut."
    }
  })
  .then((value) => print("Recipe Added"))
  .catchError((error) => print("Failed to add recipe: $error"));

components
  .doc("ciasto francuskie")
  .set({
    'title': 'ciasto francuskie'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("Przyprawa w Mini kostkach Smażona cebula Knorr")
  .set({
    'title': 'Przyprawa w Mini kostkach Smażona cebula Knorr'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("parówki")
  .set({
    'title': 'parówki'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("cukinia")
  .set({
    'title': 'cukinia'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("papryka czerwona")
  .set({
    'title': 'papryka czerwona'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("pieczarki")
  .set({
    'title': 'pieczarki'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("żółty ser")
  .set({
    'title': 'żółty ser'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));

components
  .doc("jajko")
  .set({
    'title': 'jajko'
  })
  .then((value) => print("Component Document Added"))
  .catchError((error) => print("Failed to add component document: $error"));
    
}

  // CollectionReference recipes = FirebaseFirestore.instance.collection('repices');
  // CollectionReference components = FirebaseFirestore.instance.collection('component');

  // recipes
  //   .doc("placki zieminiaczane")
  //   .set({
  //     'ziemniaki': "1/2 kg",
  //     'mąką prszenna': "1/2 łyżki",
  //     'cebula': "1/4",
  //     'jaja':"1",
  //     "sol" : "",
  //     "olej roslinny" : "",
  //     "kalorie" : "2230 ",
  //     "ImageName" : "",
  //     "_time" : "30 min",
  //     "instr" : {
  //       "step1":"Ziemniaki obrać i zetrzeć na tarce o małych oczkach bezpośrednio do większej i płaskiej miski. Zostawić je w misce bez mieszania, miskę delikatnie przechylić i odstawić tak na ok. 5 minut.",
  //       "step2":"W międzyczasie odlewać zbierający się sok, delikatnie przytrzymując ziemniaki, nadal ich nie mieszać. Na koniec docisnąć dłonią do miski i odlać jeszcze więcej soku. Dodać mąkę, drobno startą cebulę, jajko oraz dwie szczypty soli.",
  //       "step3":"Rozgrzać patelnię, wlać olej. Masę ziemniaczaną wymieszać. Nakładać porcje masy (1 pełna łyżka) na rozgrzany olej i rozprowadzać ją na dość cienki placek. Smażyć na średnim ogniu przez ok. 2 - 3 minuty na złoty kolor, przewrócić na drugą stronę i powtórzyć smażenie.",
  //       "step4":"Odkładać na talerz wyłożony ręcznikami papierowymi. Posypać solą morską z młynka. Placki ziemniaczane najlepsze są prosto z patelni gdy są chrupiące.",
  //       "step5":""" **PROPOZYCJA PODANIA**: 
  //        SOS PIECZARKOWY / SOS GRZYBOWY / AJWAR / GULASZ / cukier lub cukier + oddzielnie gęsta śmietana""",
  //     }
  //   })
  //   .then((value) => print("Recipe Added"))
  //   .catchError((error) => print("Failed to add recipe: $error"));

  // components
  //   .doc("ziemniaki")
  //   .set({
  //     'title': 'zimniaki'
  //   })
  //   .then((value) => print("Component Document Added"))
  //   .catchError((error) => print("Failed to add component document: $error"));

  //   components
  //   .doc("mąką prszenna")
  //   .set({
  //     'title': 'mąką prszenna'
  //   })
  //   .then((value) => print("Component Document Added"))
  //   .catchError((error) => print("Failed to add component document: $error"));
      
  //     components
  //   .doc("olej roslinny")
  //   .set({
  //     'title': 'olej roslinny'
  //   })
  //   .then((value) => print("Component Document Added"))
  //   .catchError((error) => print("Failed to add component document: $error"));

  //    components
  //   .doc("sól")
  //   .set({
  //     'title': 'sól'
  //   })
  //   .then((value) => print("Component Document Added"))
  //   .catchError((error) => print("Failed to add component document: $error"));


  //   components
  //   .doc("sól")
  //   .set({
  //     'title': 'sól'
  //   })
  //   .then((value) => print("Component Document Added"))
  //   .catchError((error) => print("Failed to add component document: $error"));