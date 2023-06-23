import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailNewsUser extends StatelessWidget {
  DetailNewsUser(
    this.itemId, {
    super.key,
  }) {
    _reference = FirebaseFirestore.instance.collection('news').doc(itemId);
    _futureData = _reference.get();
  }

  final String itemId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;

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
            child: Image(
              image: AssetImage('images/Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: sizeWidth * 0.85,
              height: sizeHeight * 0.80,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: FutureBuilder<DocumentSnapshot>(
                future: _futureData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }

                  if (snapshot.hasData) {
                    DocumentSnapshot documentSnapshot = snapshot.data!;
                    Map data = documentSnapshot.data() as Map;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: sizeHeight * 0.05),
                          Container(
                            margin: EdgeInsets.only(left: sizeWidth * 0.05),
                            child: Text(
                              '${data['judul']}',
                              style: TextStyle(
                                fontSize: sizeWidth * 0.06,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sizeHeight * 0.05,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: sizeWidth * 0.05),
                            child: Text(
                              '${data['isi']}',
                              style: TextStyle(fontSize: sizeWidth * 0.04),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          )
        ],
      )),
    );
  }
}
