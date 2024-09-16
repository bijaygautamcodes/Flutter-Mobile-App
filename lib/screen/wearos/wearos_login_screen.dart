import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/helper/switch_route.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/repository/user_repo.dart';
import 'package:rootnode/screen/wearos/wearos_home_screen.dart';
import 'package:rootnode/widgets/text_field.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:wear/wear.dart';

class WearOsLoginScreen extends ConsumerStatefulWidget {
  final String? email;
  const WearOsLoginScreen({super.key, this.email});

  @override
  ConsumerState<WearOsLoginScreen> createState() => _WearOsLoginScreenState();
}

class _WearOsLoginScreenState extends ConsumerState<WearOsLoginScreen> {
  late final UserRepo _userRepo;
  final _emailFieldController = TextEditingController(text: "anuragbharati");
  final _scrollController = ScrollController();
  final _passwordFieldController = TextEditingController(text: "anurag");
  final _globalkey = GlobalKey<FormState>();

  @override
  void initState() {
    _userRepo = ref.read(userRepoProvider);
    if (widget.email != null) {
      _emailFieldController.text = widget.email!;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    _scrollController.dispose();
  }

  Future<User?> _loginUser() async {
    FocusScope.of(context).unfocus();
    bool res = await _userRepo.loginUser(
      identifier: _emailFieldController.text,
      password: _passwordFieldController.text,
      isEmail: false,
    );
    if (!res) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, "Invalid email or password", Colors.red[400]!);
      return null;
    }
    User? user = await _userRepo.getUserFromToken();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) => AmbientMode(
        builder: (context, mode, child) => Scaffold(
          backgroundColor: const Color(0xFF111111),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              height: double.infinity,
              width: double.infinity,
              child: CustomScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Form(
                        key: _globalkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RootNodeTextField(
                              controller: _emailFieldController,
                              type: TextFieldTypes.email,
                              hintText: "Username or email",
                              compact: true,
                            ),
                            RootNodeTextField(
                              controller: _passwordFieldController,
                              type: TextFieldTypes.password,
                              hintText: "Password",
                              compact: true,
                            ),
                            Container(
                              height: 38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.cyan,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: TextButton(
                                style: ButtonStyle(
                                    alignment: Alignment.center,
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) => EdgeInsets.zero)),
                                onPressed: () async {
                                  if (!_globalkey.currentState!.validate()) {
                                    showSnackbar(context, "Invalid fields",
                                        Colors.red[400]!);
                                    return;
                                  }
                                  showSnackbar(context, "Logging in..",
                                      Colors.green[400]!,
                                      dismissable: false);
                                  User? user = await _loginUser();
                                  if (user != null) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();

                                    // ignore: use_build_context_synchronously
                                    return switchRouteByPushReplace(
                                        context, WearOsHomeScreen(user: user));
                                  }
                                  // ignore: use_build_context_synchronously
                                  showSnackbar(
                                    context,
                                    "Sorry! Something went wrong",
                                    Colors.red[400]!,
                                  );
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class RootNodeTextLogo extends StatelessWidget {
  const RootNodeTextLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: "ROOT",
          style: TextStyle(
              color: const Color(0xFF111111),
              fontSize: 40,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.cyan[300]!, offset: const Offset(3, -3)),
                Shadow(color: Colors.cyan[400]!, offset: const Offset(-3, 3))
              ]),
        ),
        const TextSpan(
          text: "NODE",
          style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 40,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.white54, offset: Offset(3, -3)),
                Shadow(color: Colors.white70, offset: Offset(-3, 3))
              ]),
        ),
      ]),
    );
  }
}
