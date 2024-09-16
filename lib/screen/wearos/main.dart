import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/theme.dart';
import 'package:rootnode/helper/objectbox.dart';
import 'package:rootnode/screen/wearos/wearos_splash_screen.dart';
import 'package:rootnode/state/objectbox_state.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // ObjectBoxInstance.deleteDatabase();
  // Create an Object for ObjectBoxInstance
  ObjectBoxState.objectBoxInstance = await ObjectBoxInstance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(ProviderScope(
      child: MaterialApp(
        title: 'RootNode',
        debugShowCheckedModeBanner: false,
        theme: getApplicationThemeData(),
        home: const WearOsSplashScreen(),
      ),
    )),
  );
}
