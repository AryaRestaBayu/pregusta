import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:koprasi/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forgotC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: sizeHeight * 0.06,
          backgroundColor: Colors.white,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                  )),
              SizedBox(
                width: sizeWidth * 0.03,
              ),
              Text(
                'Kembali',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: sizeHeight,
              width: sizeWidth,
              child: const Image(
                image: AssetImage('images/Background-dark.png'),
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  height: sizeHeight * 0.70,
                  width: sizeWidth * 0.80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: sizeHeight * 0.30,
                        width: sizeWidth * 0.70,
                        margin: EdgeInsets.only(
                            bottom: sizeHeight * 0.04, top: sizeHeight * 0.07),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/mail.png'),
                          fit: BoxFit.cover,
                        )),
                      ),
                      //textfield
                      SizedBox(
                        height: sizeHeight * 0.08,
                        width: sizeWidth * 0.65,
                        child: TextFormField(
                          controller: forgotC,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: sizeHeight * 0.02),
                            errorBorder: errorBorder(),
                            focusedErrorBorder: errorBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      //texfield end
                      SizedBox(
                        height: sizeHeight * 0.08,
                      ),
                      //button
                      GestureDetector(
                        onTap: () {
                          resetEmail();
                        },
                        child: Container(
                            width: sizeWidth * 0.35,
                            height: sizeHeight * 0.06,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                                child: Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  Future resetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: forgotC.text.trim(),
      );
      Utils.showSnackBar("Email telah dikirim ", Colors.blue);
      Navigator.pop(context);
    } on FirebaseAuthException catch (_) {
      Utils.showSnackBar("Email tidak terdaftar", Colors.red);
    }
  }
}
