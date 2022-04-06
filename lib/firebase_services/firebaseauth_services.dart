import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //convert firebase user to custom class

  User? _convertUser(User? user) {
    return user !=null?user:null;
  }

  Stream<UserModel> get userprofile{
    return _firestore.collection("users")
    .doc(_auth.currentUser!.uid)
    .snapshots().map((event) => UserModel(event.get("name"), event.get("email"), event.get("photourl")));
  }

  Stream<User?> get user=>_auth.authStateChanges();


  Future<String> _getBannerInfo(String? username) async {
    return _firestore
        .collection("users")
        .doc(username)
        .get()
        .then((document) => document.get("banner_color"));
  }

  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      final userBannerInfo = await _getBannerInfo(user!.displayName);
      return _convertUser(user);
    } catch (error) {
      print(error);
    }
  }

  Future registerUser(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      final userBannerInfo = await _getBannerInfo(user!.displayName);
      return _convertUser(user);
    } catch (error) {
      print(error);
    }
  }

  Future signOut() async {
    try {
      googleSignIn.signOut();
      return await _auth.signOut();
    } catch (error) {
      print(error);
    }
  }

  Future<User?> signupwithgoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        user = userCredential.user;
        List<String> keywords = [];

        for (int i = 1; i <= user!.displayName!.length; i++) {
          keywords.add(user.displayName!.substring(0, i));
          keywords.add(user.displayName!.toLowerCase().substring(0, i));
        }

        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .set({
          "name": user.displayName,
          "email": user.email,
          "uid": _auth.currentUser!.uid,
          "photourl": user.photoURL,
          "keywords": keywords,
          "banner_color": "0xffFFC0CB"
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                  "The account already exists with a different credential.")));
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                  "Error occurred while accessing credentials. Try again.")));
          print('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Error occurred using Google Sign-In. Try again.")));
        print('Error occurred using Google Sign-In. Try again.');
      }
    }
    // final userBannerInfo = await _getBannerInfo(user!.displayName);
    // print(userBannerInfo);
    return _convertUser(user);
  }

  Future<User?> signinwithgoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final userBannerInfo = await _getBannerInfo(user!.displayName);
        print(userBannerInfo);
        return _convertUser(user);
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'account-exists-with-different-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(behavior: SnackBarBehavior.floating,content: Text("The account already exists with a different credential."))
          // );
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(behavior: SnackBarBehavior.floating,content: Text("Error occurred while accessing credentials. Try again."))
          // );
          print('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        //  ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(behavior: SnackBarBehavior.floating,content: Text("Error occurred using Google Sign-In. Try again."))
        //   );
      }
    }
  }
}
