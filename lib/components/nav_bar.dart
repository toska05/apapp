// import 'package:apapp/components/my_drawer.dart';
import 'package:apapp/pages/weather/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:apapp/pages/home_page.dart';
import 'package:apapp/pages/profile/profile_page.dart';
import 'package:apapp/pages/maps/maps_page.dart';
import 'package:apapp/pages/compass_page.dart';
// import 'package:apapp/pages/image_recognition/camera.dart';
import 'package:apapp/pages/image_recognition/image_recognition_page.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = <Widget>[
    WeatherPage(),
    MapsPage(),
    const ImageRecognitionPage(),
    CompassPage(),
  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Campapp'),
      backgroundColor: Colors.green[400],
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          icon: const Icon(Icons.account_circle),
        ),
      ],
    ),
    body: Center(
      child: _screens.elementAt(_currentIndex),
    ),
    bottomNavigationBar: Material(
      elevation: 10.0, // Shadow effect
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 5.0),
        child: GNav(
          activeColor: Colors.green[400],
          tabs: const [
            GButton(
              icon: Icons.cloud,
              text: 'Weather',
              textSize: 5,
              iconSize: 20,
              gap: 4,
            ),
            GButton(
              icon: Icons.location_on,
              text: 'Maps',
              textSize: 5,
              iconSize: 20,
              gap: 4,
            ),
            GButton(
              icon: Icons.pets,
              text: 'Wildlife',
              textSize: 5,
              iconSize: 20,
              gap: 4,
            ),
            GButton(icon: Icons.explore, text: 'Compass'),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    ),
  );
}

}
