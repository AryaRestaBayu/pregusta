import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koprasi/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  //controller
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();

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
                    height: sizeHeight * 0.80,
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
                          height: sizeHeight * 0.18,
                          child: const Image(
                              image: AssetImage('images/pregusta.png')),
                        ),
                        //form
                        SizedBox(
                          height: sizeHeight * 0.60,
                          width: sizeWidth * 0.65,
                          child: Form(
                            key: formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //nama
                                  const Text('Nama',
                                      style: TextStyle(color: Colors.blue)),
                                  SizedBox(
                                    height: sizeHeight * 0.07,
                                    child: TextFormField(
                                      maxLength: 18,
                                      textInputAction: TextInputAction.next,
                                      controller: namaController,
                                      validator: RequiredValidator(
                                          errorText: "Nama tidak boleh kosong"),
                                      decoration: InputDecoration(
                                        counterText: '',
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
                                    height: sizeHeight * 0.01,
                                  ),
                                  //email
                                  const Text('Email',
                                      style: TextStyle(color: Colors.blue)),
                                  SizedBox(
                                    height: sizeHeight * 0.08,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Email tidak boleh kosong"),
                                        EmailValidator(
                                            errorText: "Format email salah"),
                                      ]),
                                      decoration: InputDecoration(
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
                                    height: sizeHeight * 0.01,
                                  ),
                                  //kata sandi
                                  const Text('Kata sandi',
                                      style: TextStyle(color: Colors.blue)),
                                  SizedBox(
                                    height: sizeHeight * 0.06,
                                    child: TextFormField(
                                      controller: passwordController,
                                      textInputAction: TextInputAction.next,
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
                                  SizedBox(
                                    height: sizeHeight * 0.01,
                                  ),
                                  //konfirmasi kata sandi
                                  const Text('Konfirmasi kata sandi',
                                      style: TextStyle(color: Colors.blue)),
                                  SizedBox(
                                    height: sizeHeight * 0.06,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Kata sandi tidak boleh kosong";
                                        }
                                        return MatchValidator(
                                                errorText:
                                                    "Kata sandi tidak sama")
                                            .validateMatch(
                                                val, passwordController.text);
                                      },
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
                                  SizedBox(
                                    height: sizeHeight * 0.02,
                                  ),
                                  //button daftar
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        signUp();
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
                                            'Daftar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight * 0.02,
                                  ),
                                  //text masuk
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'Sudah memiliki akun? ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: sizeHeight * 0.022),
                                          children: [
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    widget.onClickedSignUp,
                                              text: 'Masuk',
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ));

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) => FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.uid)
                  .set({
                'id': value.user!.uid,
                'email': emailController.text,
                'nama': namaController.text,
                'jabatan': '',
                'no_hp': '',
                'profile': '',
                'role': 'user',
              }));
      Utils.showSnackBar(
          "Sign in as " + FirebaseAuth.instance.currentUser!.email.toString(),
          Colors.blue);
    } on FirebaseAuthException catch (_) {
      Utils.showSnackBar("Email telah digunakan", Colors.red);
      Navigator.pop(context);
    }
  }
}
