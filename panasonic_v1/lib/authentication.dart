import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<String> getName(String email, FirebaseDatabase database);

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    print(email);
    print(password);
    FirebaseUser result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    FirebaseUser user = result;
    return user.uid;
  }

  Future<String> getName(String email, FirebaseDatabase database) async {
    DataSnapshot result = await database.reference().child('Users').orderByValue().equalTo(email).once();
// .then((DataSnapshot snapshot) {
//     print(snapshot.value);
//     String user_uid=snapshot.value.entries.elementAt(0).key;
//     print(user_uid);
//     return snapshot;});
    // print(result.toString());
    // print(result.value);
    // print(result.value.entries.elementAt(0).key);
    // String name = "";
    String name = result.value.entries.elementAt(0).key;
    print(name);
    return name;
    // return "lol";
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}