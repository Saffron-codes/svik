import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String message;
  String from;
  Timestamp time;
  String type;
  String reactions;
  String id;

  Message(this.message,this.from,this.time,this.type,this.reactions,this.id);
}