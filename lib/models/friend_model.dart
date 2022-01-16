import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  Timestamp added;
  String name;
  String photourl;
  String lastmessage;
  Timestamp lastmessagetime;
  List<dynamic> keywords;
  String uid;
  Friend(this.added, this.name, this.photourl, this.lastmessage,this.lastmessagetime,this.keywords,this.uid);
}
