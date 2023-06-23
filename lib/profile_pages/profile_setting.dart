import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:koprasi/profile_pages/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  String _getName = '';
  String _getNoHp = '';
  String _getJabatan = '';
  String _getProfile = '';

  Future getProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _getName = doc.get('nama');
      _getNoHp = doc.get('no_hp');
      _getJabatan = doc.get('jabatan');
      _getProfile = doc.get('profile');
    });
  }

  Future setProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'profile': imageUrl,
    });
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    //textStyle
    TextStyle judul =
        TextStyle(color: Colors.white, fontSize: sizeWidth * 0.05);
    TextStyle isi = TextStyle(color: Colors.blue, fontSize: sizeWidth * 0.05);

    //sizedbox
    SizedBox spasi = SizedBox(height: sizeHeight * 0.03);

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
        body: Stack(children: [
          //background
          SizedBox(
            height: sizeHeight,
            width: sizeWidth,
            child: const Image(
              image: AssetImage('images/Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: sizeHeight * 0.78,
              width: sizeWidth,
              child: const Image(
                image: AssetImage('images/Background-dark2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(children: [
            //arrow back
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: sizeHeight * 0.025,
              ),
            ),
            //poto
            Container(
              margin: EdgeInsets.only(top: sizeHeight * 0.04),
              height: sizeHeight * 0.25,
              width: sizeWidth * 0.75,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      image: _getProfile == ''
                          ? const AssetImage('images/putih.png')
                              as ImageProvider
                          : NetworkImage(_getProfile),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: sizeHeight * 0.05,
            ),
            //data diri
            Container(
              width: sizeWidth * 0.80,
              height: sizeHeight * 0.41,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama', style: judul),
                  Container(
                    margin: EdgeInsets.only(bottom: sizeHeight * 0.02),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(_getName, style: isi),
                    ),
                  ),
                  Text('Email', style: judul),
                  Container(
                    margin: EdgeInsets.only(bottom: sizeHeight * 0.02),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          style: isi),
                    ),
                  ),
                  Text('Jabatan', style: judul),
                  Container(
                    margin: EdgeInsets.only(bottom: sizeHeight * 0.02),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(_getJabatan, style: isi),
                    ),
                  ),
                  Text('No Handphone', style: judul),
                  Container(
                    margin: EdgeInsets.only(bottom: sizeHeight * 0.02),
                    width: sizeWidth,
                    height: sizeHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(_getNoHp, style: isi),
                    ),
                  ),
                ],
              ),
            ),
            //edit
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
              },
              child: Container(
                margin: EdgeInsets.only(top: sizeHeight * 0.03),
                height: sizeHeight * 0.05,
                width: sizeWidth * 0.35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.edit_outlined,
                      size: sizeHeight * 0.029, color: Colors.white),
                  SizedBox(
                    width: sizeWidth * 0.01,
                  ),
                  Text('EDIT',
                      style: TextStyle(
                          fontSize: sizeHeight * 0.02, color: Colors.white))
                ]),
              ),
            ),
          ]),

          //edit poto
          Center(
              child: SizedBox(
            height: sizeHeight * 0.36,
            width: sizeWidth * 0.30,
            child: Column(
              children: [
                Container(
                  height: sizeHeight * 0.08,
                  width: sizeWidth,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF155584),
                    border: Border.all(color: Colors.black),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: sizeHeight * 0.05,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      //pick image from gallery
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);

                      if (file == null) return;

                      //upload image to firebase storage
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImage =
                          referenceRoot.child('profile');
                      Reference referenceImageToUpload = referenceDirImage
                          .child(FirebaseAuth.instance.currentUser!.uid);
                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (e) {
                        Utils.showSnackBar(e.toString(), Colors.red);
                      }

                      setProfile();
                    },
                  ),
                )
              ],
            ),
          )),
        ]),
      ),
    );
  }
}
