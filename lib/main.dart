import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/app.dart';
import 'package:rootnode/app/notification_channel.dart';
import 'package:rootnode/helper/objectbox.dart';
import 'package:rootnode/state/objectbox_state.dart';

void main(List<String> args) async {
  AwesomeNotifications().initialize(
    'resource://drawable/launcher',
    [LocalNotificationChannel.testChannel],
    channelGroups: [LocalNotificationChannel.testgroup],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  // ObjectBoxInstance.deleteDatabase();
  // Create an Object for ObjectBoxInstance
  ObjectBoxState.objectBoxInstance = await ObjectBoxInstance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(const ProviderScope(child: MyApp())),
  );
}
