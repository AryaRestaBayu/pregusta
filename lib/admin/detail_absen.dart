import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class DetailAbsen extends StatefulWidget {
  const DetailAbsen({super.key, required this.userId});

  final String userId;

  @override
  State<DetailAbsen> createState() => _DetailAbsenState();
}

class _DetailAbsenState extends State<DetailAbsen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  final String tanggal = DateFormat.yMMMMd().format(DateTime.now());
  final String jam = DateFormat.Hms().format(DateTime.now());
  late final String date = '$tanggal, $jam';

  Map mySelectedEvents = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    getAbsen();
  }

  String imageUrl = '';

  Future getAbsen() async {
    final doc = await FirebaseFirestore.instance
        .collection('absen')
        .doc(widget.userId)
        .get();
    var selectedEvent = doc.get('mySelectedEvent');
    print(selectedEvent);
    setState(() {
      mySelectedEvents = selectedEvent;
    });
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //responsive
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: sizeWidth,
              height: sizeHeight,
              child: const Image(
                image: AssetImage('images/Background.png'),
                fit: BoxFit.cover,
              ),
            ),
            // SingleChildScrollView(
            //   child:
            Column(
              children: [
                SizedBox(
                  width: sizeWidth,
                  height: sizeHeight * 0.50,
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2040),
                    calendarFormat: _calendarFormat,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDate, selectedDay)) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    //
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                    },
                    //
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    //
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    //
                    eventLoader: _listOfDayEvents,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: sizeHeight * 0.465,
                    width: sizeWidth,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        ..._listOfDayEvents(_selectedDate!).map((myEvents) =>
                            Column(
                              children: [
                                ListTile(
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.check_circle_outlined),
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                      'Keterangan: ${myEvents['Keterangan']}'),
                                  subtitle:
                                      Text('Tanggal: ${myEvents['Tanggal']}'),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: sizeHeight * 0.00),
                                  height: sizeHeight * 0.30,
                                  width: sizeWidth * 0.60,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              myEvents['Poto'].toString()),
                                          fit: BoxFit.cover)),
                                ),
                                // Text('Poto: ${myEvents['Poto']}'),
                              ],
                            ))
                      ]),
                    ),
                  ),
                )
              ],
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
