import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:koprasi/admin/add_news.dart';
import 'package:koprasi/admin/detail_news.dart';
import 'package:koprasi/auth_page.dart';
import 'package:koprasi/main.dart';

import '../utils.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to exit an App'),
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

  @override
  void initState() {
    _streamData = _referenceNews.snapshots();
    super.initState();
  }

  late Stream<QuerySnapshot> _streamData;

  List parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List listNews = listDocs
        .map((e) => {
              'id': e.id,
              'news_judul': e['judul'],
              'news_tanggal': e['tanggal']
            })
        .toList();

    return listNews;
  }

  Query _referenceNews =
      FirebaseFirestore.instance.collection('news').orderBy('tanggal');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
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
                                            builder: (context) => MainPage()),
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
                icon: Icon(Icons.logout))
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage('images/Background-dark.png'),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(),
              child: StreamBuilder<QuerySnapshot>(
                stream: _streamData,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    List news = parseData(snapshot.data!);
                    return listview(news);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNews(),
                ));
          },
          child: Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  ListView listview(List newsItems) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          Map thisNews = newsItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailNews(
                            thisNews['id'],
                          )));
            },
            child: Container(
                height: sizeHeight * 0.15,
                width: sizeWidth,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: sizeHeight * 0.11,
                      width: sizeWidth * 0.22,
                      decoration: BoxDecoration(
                          color: Color(0xFF155584),
                          borderRadius: BorderRadius.circular(15)),
                      child: Image(
                        image: AssetImage('images/terompet.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    //pengumuman
                    Container(
                      height: sizeHeight * 0.11,
                      width: sizeWidth * 0.65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF208BD8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: sizeHeight * 0.010,
                                left: sizeWidth * 0.03,
                                right: sizeWidth * 0.02),
                            child: Text(
                              thisNews['news_judul'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: sizeWidth * 0.043,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: sizeHeight * 0.007,
                                left: sizeWidth * 0.03,
                                bottom: sizeHeight * 0.008),
                            child: Text(
                              thisNews['news_tanggal'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
