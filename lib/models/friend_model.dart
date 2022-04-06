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
  Map<String, dynamic> toMap() {
    return {
      'added@':added,
      'keywords':keywords,
      'lastmessage':'',
      'lastmessagetime':Timestamp.now(),
      'name':name,
      'photourl':photourl,
      'uid':uid
    };
    
  }

  Friend fromMap(){
    return Friend(added, name, photourl, lastmessage, lastmessagetime, keywords, uid);
  }
}
