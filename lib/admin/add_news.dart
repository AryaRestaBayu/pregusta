import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  TextEditingController isiC = TextEditingController();
  TextEditingController judulC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
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
                child: Column(
                  children: [
                    SizedBox(
                      height: sizeHeight * 0.01,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: sizeHeight * 0.78,
                        width: sizeWidth * 0.90,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //judul
                            Container(
                              margin: EdgeInsets.only(
                                  left: sizeWidth * 0.09,
                                  top: sizeHeight * 0.02),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Judul',
                                  style: TextStyle(
                                    fontSize: sizeWidth * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: sizeWidth * 0.75,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: judulC,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: sizeHeight * 0.05,
                            ),
                            //isi
                            Container(
                              margin: EdgeInsets.only(left: sizeWidth * 0.09),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Isi',
                                  style: TextStyle(
                                    fontSize: sizeWidth * 0.06,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: sizeWidth * 0.75,
                              height: sizeHeight * 0.50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: isiC,
                                textAlignVertical: TextAlignVertical.top,
                                minLines: null,
                                maxLines: null,
                                expands: true,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: sizeHeight * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.03,
                    ),
                    //button
                    SizedBox(
                      height: sizeHeight * 0.05,
                      width: sizeWidth * 0.35,
                      child: ElevatedButton(
                        onPressed: () {
                          saveNews();
                          Navigator.pop(context);
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String tanggal = DateFormat.yMMMMd().format(DateTime.now());

  void saveNews() async {
    try {
      await FirebaseFirestore.instance.collection('news').doc(judulC.text).set({
        'judul': judulC.text.trim(),
        'isi': isiC.text.trim(),
        'tanggal': tanggal.trim(),
      });
      Utils.showSnackBar("Pengumuman berhasil ditambahkan", Colors.blue);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar("Pengumuman gagal ditambahkan", Colors.red);
    }
  }
}
