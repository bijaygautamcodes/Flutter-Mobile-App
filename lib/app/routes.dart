import 'package:flutter/cupertino.dart';
import 'package:rootnode/screen/auth/login_screen.dart';
import 'package:rootnode/screen/auth/register_screen.dart';
import 'package:rootnode/screen/dashboard/dashboard.dart';
import 'package:rootnode/screen/misc/splash_screen.dart';

var getAppRoutes = <String, WidgetBuilder>{
  SplashScreen.route: (context) => const SplashScreen(),
  LoginScreen.route: (context) => const LoginScreen(),
  RegisterScreen.route: (context) => const RegisterScreen(),
  DashboardScreen.route: (context) => const DashboardScreen(),
};
