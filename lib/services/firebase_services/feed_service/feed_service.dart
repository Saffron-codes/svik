import 'package:chatapp/models/app_user.dart';
import 'package:chatapp/providers/feed_provider/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<QuerySnapshot> getPosts(
    int limit, {
    DocumentSnapshot? startAfter,
  }) async {
    final posts = _firestore
        .collection("feeds")
        .doc(_auth.currentUser!.uid)
        .collection("posts")
        .orderBy("time", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return posts.get();
    } else {
      return posts.startAfterDocument(startAfter).get();
    }
  }

  getPostDetails(userID, postId) async {
    final user = await _firestore.collection("users").doc(userID).get();
    final post = await _firestore
        .collection("posts")
        .doc(userID)
        .collection("posts")
        .doc(postId)
        .get();
    return {"user": user.data(), "post": post.data()};
  }

  Stream<AppUser> getPostUser(String userId) {
    return _firestore.collection("users").doc(userId).snapshots().map(
          (ds) => AppUser.fromFirestore(
            ds.data()!,
          ),
        );
  }

  Stream<Post> getPost(String userId, String postId) {
    return _firestore
        .collection("posts")
        .doc(userId)
        .collection("posts")
        .doc(postId)
        .snapshots()
        .map((doc) {
      return Post.fromFirestore(
        doc.data()!,
      );
    });
  }

  Stream<List<Post>> getUserPosts() {
    return _firestore
        .collection("posts")
        .doc(_auth.currentUser!.uid)
        .collection("posts")
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (post) => Post.fromFirestore(
                  post.data(),
                ),
              )
              .toList(),
        );
  }
}
