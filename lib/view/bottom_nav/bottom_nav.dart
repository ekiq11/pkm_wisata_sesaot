import 'package:flutter/material.dart';
import '../../constant.dart';
import '../gmap/map.dart';
import '../wisata/favorit.dart';
import '../wisata/home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
  final widgetOptions = [
    const HomePage(),
    const Favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Make bottom navigation float above the content
      floatingActionButton: FloatingActionButton(
        backgroundColor: kgreen,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapsNew(),
            ),
          );
        },
        child: const Icon(Icons.location_on_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white, // Background color of BottomNavigationBar
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_sharp), label: 'Favorite'),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: kgreen,
          onTap: onItemTapped,
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

