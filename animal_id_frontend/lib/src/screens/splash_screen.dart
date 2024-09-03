import 'package:animal_id_frontend/src/screens/farm_detail_view.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';

class SplashScreen extends StatelessWidget {
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
      body: Stack(
        children: [
          Center(
            child: Text(
              'Animal ID',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Buttons unten links und unten rechts
          Positioned(
            left: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, FarmDetailView.routeName);
              },
              child: Text(
                'Hofübersicht',
                style: TextStyle(
                  fontSize: 20, // Größere Schriftgröße
                  color: Colors.black, // Schwarze Schriftfarbe
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Hellere Hintergrundfarbe
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                // Funktionalität für "Hof anlegen" Button
              },
              child: Text(
                'Hof anlegen',
                style: TextStyle(
                  fontSize: 20, // Größere Schriftgröße
                  color: Colors.white, // Weiße Schriftfarbe
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Hintergrundfarbe Grün
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
