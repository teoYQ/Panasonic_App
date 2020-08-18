import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/test.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:panasonic_v1/authentication.dart';
/*
void main() {
  test('Empty Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter Email!');
  });
}*/
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase db = FirebaseDatabase.instance;
void main(){
  test('getIncubators', (){
    var result = Auth().getIncubators("lim", db);
    print(result);
  });
}