import 'package:apapp/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:apapp/pages/home_page.dart';
import 'package:apapp/pages/profile_page.dart';
import 'package:apapp/pages/bookings_page.dart';
import 'package:apapp/pages/compass_page.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = <Widget>[
    HomePage(),
    BookingsPage(),
    ProfilePage(),
    CompassPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(),

      body: Center(
        child: _screens.elementAt(_currentIndex),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: GNav(
            tabs: const [
              GButton(
                icon: Icons.cloud,
                text: 'Weather',
              ),
              GButton(
                icon: Icons.location_on,
                text: 'Location',
              ),
              GButton(
                icon: Icons.pets,
                text: 'Wildlife',
              ),
              GButton(
                icon: Icons.explore, 
                text: 'Compass'
              ),
            ],

            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            }
          ),
        ),
      ),
    );
  }
}

