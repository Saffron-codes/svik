

import 'package:chatapp/services/firebase_services/firestore_services.dart';
import 'package:chatapp/models/search_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SearchTask extends ChangeNotifier{
  //final FirestoreServices _firestoreServices = FirestoreServices();
  //List<SearchTask> _list = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  void searchusers(String searchString)async{
    await _firestore
    .collection("users")
    .snapshots()
    .map((event) => event.docs
    .map((DocumentSnapshot ds) =>SearchUser(ds.get("email"), ds.get("keywords"), ds.get("name"), ds.get("photourl"),ds.get("uid")))
    .toList());
  }

  
}