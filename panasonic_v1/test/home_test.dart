import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panasonic_v1/activities.dart';
import 'package:panasonic_v1/AuthProvider.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements BaseAuth{
  

}
void main() {

  Widget makeTestableWidget({Widget child, BaseAuth auth}) {
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }
  testWidgets('',(WidgetTester tester) async{
    MockAuth mockAuth = MockAuth();
    String email =  "yongquan13s105@gmail.com";
    FirebaseDatabase database = FirebaseDatabase.instance;
  //when(mockAuth.signInWithEmailAndPassword('email', 'password')).thenAnswer((invocation) => Future.value('uid'));
    when(mockAuth.getName(email, database)).thenAnswer((realInvocation) => Future.value("Tester"));
    ActivitiesPage page = ActivitiesPage(email:email ,auth: mockAuth,);
    
    await tester.pumpWidget(makeTestableWidget(child: page,auth:mockAuth ));
    expect(find.byKey(Key('Welcome')), findsOneWidget);
    expect(find.byType(FlatButton), findsNWidgets(4));

  });
  
  }