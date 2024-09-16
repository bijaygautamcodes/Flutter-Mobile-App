import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RNLiveMessage extends StatelessWidget {
  const RNLiveMessage({
    super.key,
  });

  // TODO Live stuffs | Just a dummy rn

  @override // this feature can be paired w/ call and proximity sensor :)
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(children: [
        Lottie.asset(
          "assets/json/particals_transparent.json",
          frameRate: FrameRate(60),
          width: double.infinity,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: double.infinity,
              width: 160,
              decoration: const BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.cyan),
                  ),
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white10,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    )
                  ]),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AvatarGlow(
                    endRadius: 20,
                    repeatPauseDuration: Duration(seconds: 2),
                    glowColor: Colors.purple,
                    child: CircleAvatar(
                      maxRadius: 10,
                      foregroundColor: Colors.purple,
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: 160,
              decoration: const BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.cyan),
                  ),
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white10,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    )
                  ]),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AvatarGlow(
                    endRadius: 20,
                    repeatPauseDuration: Duration(seconds: 2),
                    glowColor: Colors.pink,
                    child: CircleAvatar(
                        maxRadius: 10,
                        foregroundColor: Colors.pink,
                        backgroundColor: Colors.pink),
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
