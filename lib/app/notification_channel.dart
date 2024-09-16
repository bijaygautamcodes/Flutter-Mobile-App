import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationChannel {
  static final NotificationChannel testChannel = NotificationChannel(
    channelGroupKey: 'test_channel_group',
    channelDescription: 'Notification test using test channel',
    channelKey: 'test_channel',
    channelName: 'Test Notification',
    defaultColor: Colors.cyan,
    importance: NotificationImportance.Max,
    ledColor: Colors.amber,
    channelShowBadge: true,
  );
  static final NotificationChannelGroup testgroup = NotificationChannelGroup(
      channelGroupKey: 'test_channel_group', channelGroupName: 'Test group');
}
