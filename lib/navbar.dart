import 'package:flutter/material.dart';
import 'package:koprasi/pages/calendar.dart';
import 'package:koprasi/pages/dashboard.dart';
import 'package:koprasi/pages/prof.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
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

  //color
  Color biru = const Color(0xF5208BD8);

  //pageIndex
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
//current user

    //list navbar
    final List<Widget> pages = [
      const Dashboard(),
      const Calendar(),
      const Prof(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: pageIndex,
          onTap: changePage,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month_rounded,
                ),
                label: 'Absensi'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }

  void changePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
