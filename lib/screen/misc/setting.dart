import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/helper/socket_service.dart';

import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/helper/notification_helper.dart';
import 'package:rootnode/screen/auth/login_screen.dart';
import 'package:rootnode/widgets/radio_button.dart';
import 'package:rootnode/widgets/switch_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late User rootnode;
  @override
  void initState() {
    LocalNotificationHelper.checkNotificationEnabled();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: RootNodeFontStyle.header,
        ),
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Boxicons.bx_chevron_left,
            color: Colors.white70,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111111),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: double.infinity,
                  child: RootNodeRadioButton<String>(
                    selected: 1,
                    name: "Parameter",
                    options: const ["Yes", "No"],
                    onChanged: (value) {},
                    value: const ['yes', 'no'],
                  )),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RootNodeSwitchButton(
                  isChecked: true,
                  name: "Darkmode",
                  onChanged: (value) => {},
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RootNodeSwitchButton(
                  isChecked: true,
                  name: "Test",
                  onChanged: (value) => {},
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RootNodeSwitchButton(
                  isChecked: true,
                  name: "Test2",
                  onChanged: (value) => {},
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                                id: 1,
                                channelKey: 'test_channel',
                                title: "Got notified yet?",
                                body: "Test notification has been recieved!"));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Text(
                          "Notify",
                          style: RootNodeFontStyle.body,
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Consumer(builder: (context, ref, child) {
                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () => _logout(ref),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            "Logout",
                            style: RootNodeFontStyle.body,
                          ),
                        )),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(WidgetRef ref) {
    ref.read(socketServiceProvider).disconnect();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LoginScreen.route, (route) => false);
  }
}
