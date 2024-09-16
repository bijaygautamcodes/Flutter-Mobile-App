import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rootnode/main.dart' as app;

String generateRandomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

void main(List<String> args) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  String name = '';
  String email = '';
  setUp(() {
    String randomStr = generateRandomString(5);
    name = "i-$randomStr";
    email = "i.$randomStr@gmail.com";
  });
  testWidgets(
      "Given a new user"
      "Try login and registration "
      "And reach the homepage", (WidgetTester tester) async {
    app.main(args);
    await tester.pumpAndSettle();

    Finder txtFirst = find.byKey(const ValueKey('emailField'));
    Finder txtSecond = find.byKey(const ValueKey('pwdField'));
    Finder loginBtn = find.byKey(const ValueKey('loginBtn'));
    Finder gotoRegBtn = find.byKey(const ValueKey('gotoRegBtn'));

    await tester.enterText(txtFirst, email);
    await tester.enterText(txtSecond, "test");
    await tester.pumpAndSettle();

    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // API communication may take time
    await tester.pump(const Duration(seconds: 2));

    expect(find.textContaining('Invalid'), findsWidgets);

    await tester.tap(gotoRegBtn);
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    // Register
    Finder fnameField = find.byKey(const ValueKey('fnameField'));
    Finder lnameField = find.byKey(const ValueKey('lnameField'));
    Finder emailField = find.byKey(const ValueKey('emailField'));
    Finder pwdField = find.byKey(const ValueKey('pwdField'));
    Finder cpwdField = find.byKey(const ValueKey('cpwdField'));
    Finder registerBtn = find.byKey(const ValueKey('regBtn'));

    await tester.enterText(fnameField, name);
    await tester.enterText(lnameField, name);
    await tester.enterText(emailField, email);
    await tester.enterText(pwdField, "test");
    await tester.enterText(cpwdField, "test");
    await tester.pumpAndSettle();

    await tester.tap(registerBtn);
    await tester.pumpAndSettle();

    // API communication may take time
    await tester.pump(const Duration(seconds: 2));

    await tester.enterText(txtFirst, email);
    await tester.enterText(txtSecond, "test");
    await tester.pumpAndSettle();

    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // API communication may take time
    await tester.pump(const Duration(seconds: 2));

    String reference = 'Home';
    expect(find.text(reference), findsWidgets);
    expect(find.textContaining(name), findsWidgets);
  });
}
