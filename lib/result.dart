import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes/home.dart';
import 'package:recipes/search.dart';



Future<List<DocumentSnapshot>> findRecipesWithAllComponents(List<String> selectedComponents) async {
  CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');
  
  // Список для хранения всех запросов
  List<QuerySnapshot> querySnapshots = [];
  
  // Выполняем запрос для каждого компонента
  for (String component in selectedComponents) {
    QuerySnapshot querySnapshot = await recipesRef.where('components', arrayContains: component).get();
    querySnapshots.add(querySnapshot);
  }
  
  // Находим общие рецепты, которые содержат все компоненты
  List<DocumentSnapshot> commonRecipes = [];
  if (querySnapshots.isNotEmpty) {
    // Используем первый запрос в качестве отправной точки
    for (DocumentSnapshot doc in querySnapshots.first.docs) {
      bool isCommon = true;
      for (QuerySnapshot snapshot in querySnapshots.skip(1)) {
        // Проверяем, есть ли текущий рецепт в остальных запросах
        if (!snapshot.docs.any((element) => element.id == doc.id)) {
          isCommon = false;
          break;
        }
      }
      if (isCommon) {
        commonRecipes.add(doc);
      }
    }
  }
  
  return commonRecipes;
}