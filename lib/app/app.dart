import 'package:flutter/material.dart';
import 'package:rootnode/app/routes.dart';
import 'package:rootnode/app/theme.dart';
import 'package:rootnode/screen/auth/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RootNode',
      debugShowCheckedModeBanner: false,
      theme: getApplicationThemeData(),
      initialRoute: LoginScreen.route,
      routes: getAppRoutes,
    );
  }
}
