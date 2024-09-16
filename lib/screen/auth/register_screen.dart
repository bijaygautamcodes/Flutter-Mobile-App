import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootnode/app/utils/snackbar.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/repository/user_repo.dart';
import 'package:rootnode/screen/auth/login_screen.dart';
import 'package:rootnode/widgets/text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const route = "register";
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final UserRepo userRepo;
  final _fnameFieldController = TextEditingController();
  final _lnameFieldController = TextEditingController();
  final _confirmFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _scrollController = ScrollController();
  final _globalkey = GlobalKey<FormState>();

  @override
  void initState() {
    userRepo = ref.read(userRepoProvider);
    super.initState();
  }

  @override
  void dispose() {
    _fnameFieldController.dispose();
    _lnameFieldController.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            alignment: Alignment.center,
            height: double.infinity,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Form(
                    key: _globalkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => _backToLogin(context, null),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        RootNodeTextField(
                          key: const ValueKey("fnameField"),
                          controller: _fnameFieldController,
                          hintText: "First name",
                          type: TextFieldTypes.email,
                        ),
                        RootNodeTextField(
                          key: const ValueKey("lnameField"),
                          controller: _lnameFieldController,
                          hintText: "Last name",
                          type: TextFieldTypes.email,
                        ),
                        RootNodeTextField(
                          key: const ValueKey("emailField"),
                          controller: _emailFieldController,
                          hintText: "Email",
                          type: TextFieldTypes.email,
                        ),
                        RootNodeTextField(
                          key: const ValueKey("pwdField"),
                          controller: _passwordFieldController,
                          hintText: "Password",
                          type: TextFieldTypes.password,
                        ),
                        RootNodeTextField(
                          key: const ValueKey("cpwdField"),
                          controller: _confirmFieldController,
                          hintText: "Confirm password",
                          type: TextFieldTypes.password,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.cyan,
                          ),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 10, bottom: 40),
                          child: TextButton(
                            key: const ValueKey("regBtn"),
                            style:
                                const ButtonStyle(alignment: Alignment.center),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_globalkey.currentState!.validate()) {
                                _saveUser();
                              } else {
                                showSnackbar(context, "Invalid fields",
                                    Colors.red[400]!);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveUser() async {
    showSnackbar(context, "Signing Up..", Colors.green[400]!,
        dismissable: false);

    User user = User(
      fname: _fnameFieldController.text,
      lname: _lnameFieldController.text,
      email: _emailFieldController.text,
      password: _passwordFieldController.text,
    );

    int status = await userRepo.registerUser(user);
    _switch(status);
  }

  _switch(status) {
    String msg;
    msg = status > 0 ? "Registered Successfully!" : "Something went wrong!";
    Color color = status > 0 ? Colors.green : Colors.red;

    showSnackbar(context, msg, color);
    if (status > 0) {
      _backToLogin(context, _emailFieldController.text);
    }
  }

  void _backToLogin(BuildContext context, String? email) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(email: email)));
  }
}
