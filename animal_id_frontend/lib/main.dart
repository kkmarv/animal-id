 import 'package:animal_id_frontend/src/cows_service.dart';
import 'package:animal_id_frontend/src/screens/farm_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();


  runApp(CowsService(
       child: MyApp(settingsController: settingsController)));
}
