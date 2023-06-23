import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:koprasi/notification.dart';

import 'detail_news_user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    getName();
    print(FirebaseAuth.instance.currentUser!.uid);

    _streamData = _referenceNews.snapshots();
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

  final Query _referenceNews =
      FirebaseFirestore.instance.collection('news').orderBy('tanggal');

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
    print(FirebaseAuth.instance.currentUser!.email);
  }

  //
  final String jam = DateFormat.Hms().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Stack(
      children: [
        SizedBox(
          height: sizeHeight,
          width: sizeWidth,
          child: const Image(
            image: AssetImage('images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: sizeHeight * 0.02),
          width: sizeWidth,
          height: sizeHeight * 0.10,
          child: Row(
            children: [
              //poto
              Container(
                margin: EdgeInsets.only(
                    left: sizeWidth * 0.05, right: sizeWidth * 0.03),
                width: sizeWidth * 0.15,
                height: sizeHeight * 0.10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      image: _getProfile == ''
                          ? const AssetImage('images/putih.png')
                              as ImageProvider
                          : NetworkImage(_getProfile.toString()),
                      fit: BoxFit.cover),
                ),
              ),
              //nama
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: sizeWidth * 0.04,
                    ),
                  ),
                  //jabatan
                  Text(
                    _getJabatan,
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        //notif
        Positioned(
          top: 25,
          right: 1,
          child: IconButton(
            icon: Icon(
              Icons.notifications,
              size: sizeWidth * 0.10,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                ),
                height: sizeHeight * 0.70,
                width: sizeWidth,
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
                ))),
      ],
    ));
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
                      builder: (context) => DetailNewsUser(
                            thisNews['id'],
                          )));
            },
            child: Container(
                margin: EdgeInsets.only(top: sizeHeight * 0.002),
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
