import 'package:flutter/material.dart';

import '../settings/settings_view.dart';

 class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  static const routeName = '/';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      body: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Image(image: AssetImage('assets/images/farm.png')),
                ),
                Tab(
                  icon: Image(image: AssetImage('assets/images/calves.png')),
                ),
                Tab(
                  icon: Image(image: AssetImage('assets/images/pigs.png')),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[
              Center(
                child: Text("Farm Dashboard"),
              ),
              Center(
                child: Text("Calves Dashboard"),
              ),
              Center(
                child: Text("Pigs Dashboard"),
              ),
            ],
          ),
        ),
      )
    );
  }
}
