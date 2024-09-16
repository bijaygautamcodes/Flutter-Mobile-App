import 'package:flutter/material.dart';
import 'package:rootnode/screen/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String route = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 64,
              width: 64,
              child: Image.asset("assets/images/icon.png"),
            ),
            const SizedBox(height: 10),
            const Text(
              "ROOTNODE",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            const RootNodeSlogan(),
            const SizedBox(height: 20),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white10,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "v0.0.1",
              style: TextStyle(color: Colors.white24),
            )
          ],
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
