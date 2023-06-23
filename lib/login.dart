import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koprasi/forgot_password.dart';
import 'package:koprasi/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//ngepush

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  //controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  //will pop
  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text('Keluar'),
                    content: const Text('Keluar dari aplikasi?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ]))) ??
        false;
  }

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: sizeHeight,
                width: sizeWidth,
                child: const Image(
                    image: AssetImage('images/Background.png'),
                    fit: BoxFit.cover),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: sizeHeight * 0.73,
                    width: sizeWidth * 0.90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        //logo
                        SizedBox(
                          width: sizeWidth,
                          height: sizeHeight * 0.25,
                          child: const Image(
                              image: AssetImage('images/pregusta.png')),
                        ),
                        //form
                        SizedBox(
                          height: sizeHeight * 0.45,
                          width: sizeWidth * 0.65,
                          child: Form(
                            key: formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //email
                                  const Text('Email',
                                      style: TextStyle(color: Colors.blue)),
                                  SizedBox(
                                    height: sizeHeight * 0.06,
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Email tidak boleh kosong"),
                                        EmailValidator(
                                            errorText: "Format email salah"),
                                      ]),
                                      controller: emailController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        errorBorder: errorBorder(),
                                        focusedErrorBorder: errorBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight * 0.03,
                                  ),
                                  //kata sandi
                                  const Text('Kata sandi',
                                      style: TextStyle(color: Colors.blue)),
                                  SizedBox(
                                    height: sizeHeight * 0.06,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      controller: passwordController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Kata sandi tidak boleh kosong"),
                                        MinLengthValidator(6,
                                            errorText: "Minimal 6 karakter"),
                                      ]),
                                      obscureText: showPassword,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        errorBorder: errorBorder(),
                                        focusedErrorBorder: errorBorder(),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          child: Icon(
                                              showPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.blue),
                                        ),
                                        suffixIconColor: Colors.black,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //lupa kata sandi
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: const Text(
                                        'Lupa kata sandi?',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForgotPassword()));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight * 0.01,
                                  ),
                                  //button masuk
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        signIn();
                                      },
                                      child: Container(
                                          width: sizeWidth * 0.60,
                                          height: sizeHeight * 0.07,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                              child: Text(
                                            'Masuk',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight * 0.03,
                                  ),
                                  //text daftar
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'Belum memiliki akun? ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: sizeHeight * 0.022),
                                          children: [
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    widget.onClickedSignUp,
                                              text: 'Daftar',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: sizeHeight * 0.022),
                                            )
                                          ]),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.red),
      borderRadius: BorderRadius.circular(20),
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Utils.showSnackBar(
          "Sign in as " + FirebaseAuth.instance.currentUser!.email.toString(),
          Colors.blue);
    } on FirebaseAuthException catch (_) {
      Utils.showSnackBar(
          "Email belum terdaftar atau kata sandi salah", Colors.red);
    }
    Navigator.pop(context);
  }
}
