import 'dart:async';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:rootnode/app/constant/api.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/model/user/user.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.node,
  });
  final User node;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  double _proximityValue = 0.0;
  final List<StreamSubscription<dynamic>> _streamSubscription = [];
  bool toggle = false;
  @override
  void initState() {
    _streamSubscription.add(proximityEvents!.listen((event) {
      setState(() {
        _proximityValue = event.proximity;
      });
      if (!(_proximityValue >= 4)) {
        if (toggle) return;
        toggle = true;
        _showPostOptions(context);
      } else {
        if (!toggle) return;
        toggle = false;
        Navigator.of(context, rootNavigator: true).pop("");
      }
    }));
    super.initState();
  }

  @override
  void dispose() {
    _proximityValue = 0;
    toggle = false;
    for (StreamSubscription<dynamic> subs in _streamSubscription) {
      subs.cancel();
    }
    _streamSubscription.clear();
    super.dispose();
  }

  void _showPostOptions(BuildContext context) {
    showDialog(
      barrierColor: const Color(0x55000000),
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ShaderMask(
          blendMode: BlendMode.dstOut,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF111111), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.01, 0.1],
          ).createShader(bounds),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                height: 256,
                width: 256,
                child: FadeInImage.assetNetwork(
                  height: 256,
                  width: 256,
                  image: "${ApiConstants.baseUrl}/${widget.node.avatar!}",
                  placeholder: 'assets/images/image_grey.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.node.fullname,
                  style: RootNodeFontStyle.header,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 30,
                children: [
                  IconButton(
                    color: Colors.white70,
                    onPressed: () {},
                    icon: const Icon(
                      Boxicons.bx_message_alt_dots,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    color: Colors.lime,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Boxicons.bx_phone_off,
                      size: 64,
                    ),
                  ),
                  IconButton(
                    color: Colors.white70,
                    onPressed: () {},
                    icon: const Icon(
                      Boxicons.bx_video_off,
                      size: 32,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
