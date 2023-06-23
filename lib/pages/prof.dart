import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:koprasi/forgot_password.dart';
import 'package:koprasi/main.dart';
import 'package:koprasi/notifikasi_page.dart';
import 'package:koprasi/profile_pages/profile_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';

class Prof extends StatefulWidget {
  const Prof({Key? key}) : super(key: key);

  @override
  State<Prof> createState() => _ProfState();
}

class _ProfState extends State<Prof> {
  @override
  void initState() {
    getName();
    super.initState();
  }

  String _getName = '';
  String _getJabatan = '';
  String _getProfile = '';

  void getName() async {
    final DocumentSnapshot identitasDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _getName = identitasDoc.get('nama');
      _getJabatan = identitasDoc.get('jabatan');
      _getProfile = identitasDoc.get('profile');
    });
  }

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Stack(children: [
        //background
        SizedBox(
          height: sizeHeight,
          width: sizeWidth,
          child: const Image(
            image: AssetImage('images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        //background dark
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: sizeWidth,
            height: sizeHeight * 0.70,
            child: Image(
              image: AssetImage('images/Background-dark2.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        //actions
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: sizeWidth,
            height: sizeHeight * 0.70,
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: sizeHeight * 0.10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: sizeHeight * 0.05,
                      ),
                      //profile
                      Button(
                        call: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileSetting()));
                        },
                        sizeHeight: sizeHeight,
                        sizeWidth: sizeWidth,
                        judul: 'Profile',
                        subJudul: 'Data diri, privasi',
                        ikon: Icons.account_circle_outlined,
                      ),
                      //keamanan
                      Button(
                        call: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        sizeHeight: sizeHeight,
                        sizeWidth: sizeWidth,
                        judul: 'Keamanan',
                        subJudul: 'Pemulihan akun, Perizinan',
                        ikon: Icons.verified_user_outlined,
                      ),
                      //notifikasi
                      Button(
                        call: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotifikasiPage()));
                        },
                        sizeHeight: sizeHeight,
                        sizeWidth: sizeWidth,
                        judul: 'Notifikasi',
                        subJudul: 'Pengaturan notifikiasi',
                        ikon: Icons.notifications_none,
                      ),
                      //logout
                      Button(
                        call: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: const Text('LOGOUT'),
                                      content:
                                          const Text('Yakin untuk logout?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainPage()),
                                                (route) => false);
                                            Utils.showSnackBar(
                                                "Berhasil logout", Colors.red);
                                          },
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            'No',
                                          ),
                                        ),
                                      ]));
                        },
                        sizeHeight: sizeHeight,
                        sizeWidth: sizeWidth,
                        judul: 'Logout',
                        subJudul: 'Keluar',
                        ikon: Icons.logout_rounded,
                      )
                    ]),
              ),
            ),
          ),
        ),
        //poto
        Positioned(
          top: sizeHeight * 0.11,
          left: sizeWidth * 0.03,
          child: Container(
            width: sizeWidth * 0.35,
            height: sizeHeight * 0.20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white),
                image: DecorationImage(
                  image: _getProfile == ''
                      ? const AssetImage('images/putih.png') as ImageProvider
                      : NetworkImage(_getProfile.toString()),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        //nama
        Positioned(
            top: sizeHeight * 0.20,
            left: sizeWidth * 0.41,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getName.toString(),
                  style: TextStyle(
                      fontSize: sizeHeight * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  _getJabatan.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sizeWidth * 0.05,
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.sizeHeight,
    required this.sizeWidth,
    required this.judul,
    required this.subJudul,
    required this.ikon,
    required this.call,
  }) : super(key: key);

  final double sizeHeight;
  final double sizeWidth;
  final String judul;
  final String subJudul;
  final IconData ikon;
  final VoidCallback call;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: call,
      child: Container(
        height: sizeHeight * 0.079,
        width: sizeWidth * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(bottom: sizeHeight * 0.05),
        child: Row(
          children: [
            //icon
            Icon(
              ikon,
              size: sizeHeight * 0.08,
              color: Colors.blue,
            ),
            SizedBox(
              width: sizeWidth * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: sizeHeight * 0.01),
                  //judul
                  child: Text(
                    judul,
                    style: TextStyle(
                        fontSize: sizeHeight * 0.03, color: Colors.blue),
                  ),
                ),
                //sub judul
                Text(
                  subJudul,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
