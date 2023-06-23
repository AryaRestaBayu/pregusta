import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  bool isSwitched = false;
  String? _stringTimeOfDay;
  String? _jam;
  String? _menit;

  getSwitchValues() async {
    isSwitched = await getSwitchState();
    _stringTimeOfDay = await getTimeState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitched = prefs.getBool("switchState");
    print(isSwitched);

    return isSwitched!;
  }

  Future saveTimeState(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("time", value);
    print('time saved $value');
    return prefs.setString("time", value);
  }

  Future getTimeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _stringTimeOfDay = prefs.getString("time");
    print(_stringTimeOfDay);

    return _stringTimeOfDay!;
  }

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    tz.initializeTimeZones();
    getSwitchValues();
  }

  String jam = DateFormat('dd.MM.yy').format(DateTime.now());
  late final currentTime = DateFormat('dd.MM.yy').parse(jam);
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: sizeHeight * 0.25,
                      width: sizeWidth * 0.55,
                      // color: Colors.white,
                      child: Image(
                        image: AssetImage('images/time.png'),
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(bottom: sizeHeight * 0.04),
                    ),
                    Text(
                        _stringTimeOfDay.toString().isEmpty
                            ? _timeOfDay.hour.toString().padLeft(2, '0') +
                                ':' +
                                _timeOfDay.minute.toString().padLeft(2, '0')
                            : _stringTimeOfDay.toString(),
                        style: TextStyle(
                            fontSize: sizeHeight * 0.04, color: Colors.white)),
                    SizedBox(
                      height: sizeHeight * 0.02,
                    ),
                    MaterialButton(
                        height: 50,
                        minWidth: 150,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Pilih Waktu',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: sizeHeight * 0.023),
                        ),
                        onPressed: () {
                          selectTime();
                        }),
                    SizedBox(
                      height: sizeHeight * 0.02,
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          isSwitched = value;
                          saveSwitchState(value);
                        });

                        if (isSwitched == true) {
                          NotificationService.showScheduleDailyNotification(
                              _timeOfDay);
                        } else {
                          NotificationService.cancelDaily();
                        }
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> selectTime() async {
    TimeOfDay? _picked =
        await showTimePicker(context: context, initialTime: _timeOfDay);
    if (_picked != null) {
      setState(() {
        _timeOfDay = _picked;
        _jam = _picked.hour.toString().padLeft(2, '0');
        _menit = _picked.minute.toString().padLeft(2, '0');
        _stringTimeOfDay = _jam! + ':' + _menit!;
        saveTimeState(_stringTimeOfDay!);
        isSwitched = false;
        saveSwitchState(isSwitched);
        NotificationService.cancelDaily();
      });
    }
  }
}
