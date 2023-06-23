import 'package:flutter/material.dart';

class DataProfile extends StatefulWidget {
  const DataProfile({Key? key}) : super(key: key);

  @override
  State<DataProfile> createState() => _DataProfileState();
}

class _DataProfileState extends State<DataProfile> {
  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
      child: Container(
        margin: EdgeInsets.only(
            top: sizeHeight * 0.10 + MediaQuery.of(context).padding.top,
            bottom: sizeHeight * 0.10),
        width: sizeWidth * 0.75,
        height: sizeHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            //Halo
            Text('Halo Mr.Kepo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Please Insert Your Profile'),
            //nisn/nip
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ))),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
