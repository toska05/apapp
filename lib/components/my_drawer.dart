import 'package:apapp/unused_pages/maps_page.dart';
import 'package:apapp/pages/profile/profile_page.dart';
import 'package:apapp/pages/weather/weather_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.airplanemode_active_sharp,
                  size: 30,
                ),
              ),

              const SizedBox(height: 25),
              
              //weather tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.cloud,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text('W E A T H E R'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherPage())
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              //maps tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text('M A P S'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapsPage())
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              //settings tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text('S E T T I N G S'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage())
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}