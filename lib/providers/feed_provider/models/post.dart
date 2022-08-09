import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String id;
  final String caption;
  final String posturl;
  final Timestamp time;
  final int like;

  Post(this.uid, this.id, this.caption, this.posturl, this.time, this.like);

  Post.fromFirestore(Map<String, dynamic> firestoreMap)
      : uid = firestoreMap['uid'],
        id = firestoreMap['id'],
        caption = firestoreMap['caption'],
        posturl = firestoreMap['post_url'],
        time = firestoreMap['time'],
        like = firestoreMap['like'];

}
