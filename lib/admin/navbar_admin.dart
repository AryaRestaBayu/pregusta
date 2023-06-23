import 'package:flutter/material.dart';
import 'package:koprasi/admin/admin_home.dart';
import 'package:koprasi/admin/view_absen.dart';

class NavbarAdmin extends StatefulWidget {
  const NavbarAdmin({super.key});

  @override
  State<NavbarAdmin> createState() => _NavbarAdminState();
}

class _NavbarAdminState extends State<NavbarAdmin> {
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
      AdminHome(),
      ViewAbsen(),
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
          unselectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'User'),
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
