import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../utils.dart';
import 'detail_absen.dart';

class ViewAbsen extends StatefulWidget {
  const ViewAbsen({super.key});

  @override
  State<ViewAbsen> createState() => _ViewAbsenState();
}

class _ViewAbsenState extends State<ViewAbsen> {
  @override
  void initState() {
    _streamData = _referenceNews.snapshots();
    super.initState();
  }

  late Stream<QuerySnapshot> _streamData;

  List parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List listUser = listDocs
        .map((e) => {
              'id': e['id'],
              'user_nama': e['nama'],
              'user_jabatan': e['jabatan'],
              'user_email': e['email'],
              'user_profile': e['profile'],
            })
        .toList();

    return listUser;
  }

  final Query _referenceNews =
      FirebaseFirestore.instance.collection('users').orderBy('nama');

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: const Text('LOGOUT'),
                            content: const Text('Yakin untuk logout?'),
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
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: sizeHeight,
            width: sizeWidth,
            child: Image(
              image: AssetImage('images/Background-dark.png'),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  ),
              width: sizeWidth,
              height: sizeHeight,
              child: StreamBuilder<QuerySnapshot>(
                stream: _streamData,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    List users = parseData(snapshot.data!);
                    return listview(users);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView listview(List usersItem) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: usersItem.length,
        itemBuilder: (context, index) {
          Map thisUsers = usersItem[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailAbsen(
                            userId: thisUsers['id'],
                          )));
            },
            child: Container(
              margin: EdgeInsets.only(top: sizeHeight * 0.03),
              height: sizeHeight * 0.08,
              width: sizeWidth,
              // color: Colors.red,
              child: Stack(
                children: [
                  Positioned(
                    top: sizeHeight * 0.006,
                    left: sizeWidth * 0.16,
                    child: Container(
                      height: sizeHeight * 0.07,
                      width: sizeWidth * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: sizeHeight * 0.01,
                                left: sizeHeight * 0.04),
                            child: Padding(
                              padding: EdgeInsets.only(left: sizeWidth * 0.03),
                              child: Text(
                                thisUsers['user_nama'],
                                style: TextStyle(
                                    fontSize: sizeWidth * 0.05,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: sizeHeight * 0.005,
                                    left: sizeHeight * 0.05),
                                child: Center(
                                  child: Text(
                                    thisUsers['user_jabatan'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: sizeWidth * 0.06,
                    child: Container(
                      height: sizeHeight * 0.08,
                      width: sizeWidth * 0.20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF208BD8)),
                          color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(thisUsers['user_profile']),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
