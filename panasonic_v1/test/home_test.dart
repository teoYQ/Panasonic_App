import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panasonic_v1/activities.dart';
import 'package:panasonic_v1/AuthProvider.dart';
import 'package:panasonic_v1/analyticspage.dart';
import 'package:panasonic_v1/authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:panasonic_v1/forum.dart';
import 'package:panasonic_v1/main.dart';
import 'package:panasonic_v1/DIYpage2.dart';

class MockAuth extends Mock implements BaseAuth {}

void main() async {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  Widget makeTestableWidget({Widget child, BaseAuth auth}) {
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Incubators Page loads properly', (WidgetTester tester) async {
    await binding.setSurfaceSize(Size(1000, 1800));
    MockAuth mockAuth = MockAuth();
    String name = "lim";
    FirebaseDatabase database = FirebaseDatabase.instance;
    //when(mockAuth.signInWithEmailAndPassword('email', 'password')).thenAnswer((invocation) => Future.value('uid'));
    when(mockAuth.getIncubatorMap(name, database))
        .thenAnswer((realInvocation) => Future.value({
              "Incubator 01": {"dose": 0, "lights": "off", "temperature": 25}
            }));
    when(mockAuth.getEmail(name, database)).thenAnswer(
        (realInvocation) => Future.value("yongquan13s105@gmail.com"));
    when(mockAuth.getActiveIncubators(name, database))
        .thenAnswer((realInvocation) => Future.value([]));
    when(mockAuth.getIncubators(name, database))
        .thenAnswer((realInvocation) => Future.value(["Incubator 01"]));

    AnlyticsPage page = AnlyticsPage(
      name: name,
      auth: mockAuth,
    );

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    expect(find.text('Incubators'), findsOneWidget);
    expect(find.byKey(Key('Add')), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNWidgets(1));
    expect(find.byKey(Key('cards')), findsOneWidget);

    expect(find.byIcon(Icons.home), findsNWidgets(1));
  });
  testWidgets('DIY Page loads properly', (WidgetTester tester) async {
    // await binding.setSurfaceSize(Size(800, 640));
    await binding.setSurfaceSize(Size(1000, 1800));

    MockAuth mockAuth = MockAuth();
    String name = "lim";
    FirebaseDatabase database = FirebaseDatabase.instance;
    //when(mockAuth.signInWithEmailAndPassword('email', 'password')).thenAnswer((invocation) => Future.value('uid'));
    when(mockAuth.getIncubatorMap(name, database))
        .thenAnswer((realInvocation) => Future.value({
              "Incubator 01": {"dose": 0, "lights": "off", "temperature": 25}
            }));
    when(mockAuth.getEmail(name, database)).thenAnswer(
        (realInvocation) => Future.value("yongquan13s105@gmail.com"));
    when(mockAuth.getActiveIncubators(name, database))
        .thenAnswer((realInvocation) => Future.value([]));
    when(mockAuth.getIncubators(name, database))
        .thenAnswer((realInvocation) => Future.value(["Incubator 01"]));

    DIYPage page = DIYPage(
      auth: mockAuth,
      name: name,
      temp: 25,
      dose: 0,
      incubatorname: "Incubator 01",
    );

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    /*expect(find.text('Incubators'), findsOneWidget);
    expect(find.byKey(Key('Add')), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNWidgets(1));
    expect(find.byKey(Key('cards')), findsOneWidget);

    expect(find.byIcon(Icons.home), findsNWidgets(1));*/
  });
  testWidgets('Activity Page loads properly', (WidgetTester tester) async {
    MockAuth mockAuth = MockAuth();
    String email = "yongquan13s105@gmail.com";
    FirebaseDatabase database = FirebaseDatabase.instance;
    //when(mockAuth.signInWithEmailAndPassword('email', 'password')).thenAnswer((invocation) => Future.value('uid'));
    when(mockAuth.getName(email, database))
        .thenAnswer((realInvocation) => Future.value("Tester"));
    ActivitiesPage page = ActivitiesPage(
      email: email,
      auth: mockAuth,
    );

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    expect(find.byKey(Key('Welcome')), findsOneWidget);
    expect(find.byType(FlatButton), findsNWidgets(4));
  });
  testWidgets("Forum page loads", (WidgetTester tester) async {
    ForumPage page = ForumPage();
    MockAuth mockAuth = MockAuth();

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    await tester.pumpWidget(ForumPage());
    expect(find.byKey(Key('fb')), findsOneWidget);
  });
  testWidgets('Check log in and sign up page loads',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    await tester.tap(find.text("Sign Up"));
    //expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(3));
  });
}
