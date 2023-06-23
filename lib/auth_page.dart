import 'package:flutter/material.dart';
import 'package:koprasi/login.dart';
import 'package:koprasi/sign_up.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onClickedSignUp: toogle)
        : SignUp(
            onClickedSignUp: toogle,
          );
  }

  void toogle() => setState(() {
        isLogin = !isLogin;
      });
}
