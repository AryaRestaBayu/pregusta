import 'package:flutter/material.dart';
import 'package:koprasi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final namaController = TextEditingController();
  final noHpController = TextEditingController();
  bool _namaValidate = false;
  bool _hpValidate = false;

  //value
  String vJabatan = 'Guru';

  //item
  var itemJabtan = [
    'Guru',
    'Staff',
    'Kepala Sekolah',
  ];

  @override
  void initState() {
    super.initState();
  }

  Future updateProfile() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'id': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
      'nama': namaController.text,
      'jabatan': vJabatan,
      'no_hp': noHpController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: sizeHeight,
              width: sizeWidth,
              child: const Image(
                  image: AssetImage('images/Background-dark.png'),
                  fit: BoxFit.cover),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  height: sizeHeight * 0.75,
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
                        height: sizeHeight * 0.22,
                        child: const Image(
                            image: AssetImage('images/pregusta.png')),
                      ),
                      //form
                      SizedBox(
                        height: sizeHeight * 0.53,
                        width: sizeWidth * 0.65,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //nama
                              const Text('Nama',
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                height: sizeHeight * 0.08,
                                child: TextFormField(
                                  maxLength: 18,
                                  controller: namaController,
                                  decoration: InputDecoration(
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    errorText: _namaValidate
                                        ? 'Nama tidak boleh kosong'
                                        : null,
                                    counterText: '',
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
                              SizedBox(
                                height: sizeHeight * 0.03,
                              ),
                              //jabatan
                              const Text('Jabatan',
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                width: sizeWidth,
                                height: sizeHeight * 0.08,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.blue,
                                            )),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: Colors.blue,
                                            ))),
                                    value: vJabatan,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    //
                                    items: itemJabtan.map((String itemJabatan) {
                                      return DropdownMenuItem(
                                        value: itemJabatan,
                                        child: Text(itemJabatan),
                                      );
                                    }).toList(),
                                    //
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        vJabatan = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: sizeHeight * 0.03,
                              ),
                              //no handphone
                              const Text('No Handphone',
                                  style: TextStyle(color: Colors.blue)),
                              SizedBox(
                                height: sizeHeight * 0.08,
                                child: TextField(
                                  maxLength: 16,
                                  keyboardType: TextInputType.number,
                                  controller: noHpController,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    errorText: _hpValidate
                                        ? 'No hp tidak boleh kosong'
                                        : null,
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
                              SizedBox(
                                height: sizeHeight * 0.05,
                              ),
                              //button masuk
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      namaController.text.isEmpty
                                          ? _namaValidate = true
                                          : _namaValidate = false;
                                      noHpController.text.isEmpty
                                          ? _hpValidate = true
                                          : _hpValidate = false;
                                    });
                                    if (_namaValidate == true) return;
                                    if (_hpValidate == true) return;

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainPage()),
                                        (route) => false);
                                    updateProfile();
                                  },
                                  child: Container(
                                      width: sizeWidth * 0.40,
                                      height: sizeHeight * 0.07,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        'Simpan',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                                ),
                              ),
                              SizedBox(
                                height: sizeHeight * 0.03,
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
