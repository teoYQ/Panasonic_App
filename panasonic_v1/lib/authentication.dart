import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<String> getName(String email, FirebaseDatabase database);

  Future<int> getTemp(String name, FirebaseDatabase database);
  Future<int> getIncubatorTemp(
      String name, String incubatorName, FirebaseDatabase database);

  Future<int> getDose(String name, FirebaseDatabase database);
  Future<int> getIncubatorDose(
      String name, String incubatorName, FirebaseDatabase database);

  Future<String> getIncubatorLight(
      String name, String incubatorName, FirebaseDatabase database);
  Future<List> getActiveIncubators(String name, FirebaseDatabase database);
  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<List> getIncubators(String name, FirebaseDatabase database);

  Future<Map> getIncubatorMap(String name, FirebaseDatabase database);

  Future<List> getIncubatorDetails(String name, FirebaseDatabase database);
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
    DataSnapshot result = await database
        .reference()
        .child('Users')
        .orderByValue()
        .equalTo(email)
        .once();
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

  Future<int> getTemp(String name, FirebaseDatabase database) async {
    DataSnapshot result =
        await database.reference().child(name).child("temperature").once();
    print(result.value);
    // String value = int.parse(result.value);
    // return value;
    return result.value;
  }

  Future<List> getIncubators(String name, FirebaseDatabase database) async {
    DataSnapshot result = await database.reference().child(name).once();
    //var users = [];
    //for (var key in result.value.keys) print(key);
    var _list = result.value.keys.toList();
    //result.value.forEach((v) => print(v));
    print(_list);
    // String value = int.parse(result.value);
    // return value;
    return _list;
  }

  Future<Map> getIncubatorMap(String name, FirebaseDatabase database) async {
    DataSnapshot result = await database.reference().child(name).once();
    //var users = [];
    //for (var key in result.value.keys) print(key);
    var _list = result.value;
    //result.value.forEach((v) => print(v));
    print(_list);
    // String value = int.parse(result.value);
    // return value;
    return _list;
  }

  Future<List> getIncubatorDetails(
      String name, FirebaseDatabase database) async {
    DataSnapshot result = await database.reference().child(name).once();
    //var users = [];
    //for (var key in result.value.keys) print(key);
    var _list = result.value.values.toList();
    //result.value.forEach((v) => print(v));
    print(_list);
    // String value = int.parse(result.value);
    // return value;
    return _list;
  }

  Future<int> getIncubatorTemp(
      String name, String incubator_name, FirebaseDatabase database) async {
    DataSnapshot result = await database
        .reference()
        .child(name)
        .child(incubator_name)
        .child("temperature")
        .once();
    print(result.value);
    // String value = int.parse(result.value);
    // return value;
    return result.value;
  }

  Future<int> getDose(String name, FirebaseDatabase database) async {
    DataSnapshot result =
        await database.reference().child(name).child("dose").once();
    print(result.value);
    // String value = int.parse(result.value);
    // return value;
    return result.value;
  }

  Future<int> getIncubatorDose(
      String name, String incubator_name, FirebaseDatabase database) async {
    DataSnapshot result = await database
        .reference()
        .child(name)
        .child(incubator_name)
        .child("dose")
        .once();
    print(result.value);
    // String value = int.parse(result.value);
    // return value;
    return result.value;
  }

  Future<String> getIncubatorLight(
      String name, String incubator_name, FirebaseDatabase database) async {
    DataSnapshot result = await database
        .reference()
        .child(name)
        .child(incubator_name)
        .child("lights")
        .once();
    print(result.value);
    // String value = int.parse(result.value);
    // return value;
    return result.value;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result;
    return user.uid;
  }

  Future<List> getActiveIncubators(
      String name, FirebaseDatabase database) async {
    DataSnapshot result =
        await database.reference().child("Active Incubators").once();
    //var users = [];
    //for (var key in result.value.keys) print(key);
    print("HAHHSDAU");
    var _list = result.value.keys.toList();
    //result.value.forEach((v) => print(v));
    print(_list);
    // String value = int.parse(result.value);
    // return value;
    return _list;
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
