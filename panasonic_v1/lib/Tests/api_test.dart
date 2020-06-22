import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:panasonic_v1/authentication.dart';

/*
void main() {
  test('Empty Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter Email!');
  });
}*/
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    BaseAuth auth;
    FirebaseDatabase db = FirebaseDatabase.instance;
   test('getIncubators', () async {
    
    var result = await Auth().getIncubators("lim", db);
    print(result);
  });
}