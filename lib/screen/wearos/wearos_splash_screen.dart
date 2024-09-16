import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rootnode/app/constant/font.dart';
import 'package:rootnode/screen/wearos/wearos_login_screen.dart';
import 'package:wear/wear.dart';

class WearOsSplashScreen extends StatefulWidget {
  const WearOsSplashScreen({super.key});

  @override
  State<WearOsSplashScreen> createState() => _WearOsSplashScreenState();
}

class _WearOsSplashScreenState extends State<WearOsSplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const WearOsLoginScreen()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) => AmbientMode(
        builder: (context, mode, child) => Scaffold(
          backgroundColor: const Color(0xFF111111),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Lottie.asset(
                    'assets/json/rootpot.json',
                    height: 120,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: "ROOTNODE",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: 0),
                Text("v0.0.1", style: RootNodeFontStyle.labelSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RootNodeSlogan extends StatelessWidget {
  const RootNodeSlogan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RichText(
          text: TextSpan(children: [
            const TextSpan(
              text: "be the ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "root ",
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 18,
              ),
            ),
            const TextSpan(
              text: "node,",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ]),
        ),
        RichText(
          text: const TextSpan(children: [
            TextSpan(
              text: "discover",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "() && ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "add",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "()",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "new ",
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 18,
              ),
            ),
            const TextSpan(
              text: "Connection",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
              ),
            ),
            const TextSpan(
              text: "();",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
