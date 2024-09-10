import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'screens/farm_detail_view.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CowsService extends InheritedWidget {
  BehaviorSubject<bool> cowsSubject = BehaviorSubject.seeded(true);
  List<Cow> cows = [];

  CowsService({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    fetch();
  }

  static CowsService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CowsService>();
  }

  @override
  bool updateShouldNotify(CowsService oldWidget) {
    return oldWidget.cows != cows;
  }

  Future<void> fetch() async {
    print("fetch");

    Future<String> _sendGetRequest() async {
      final url = Uri.parse(
          'https://www1.hi-tier.de/HitTest3/api/spezial/Bestandsregister?betriebe=010000000001');

      // Basic Auth credentials
      const username = '01 000 000 0001';
      const password = 'Aaaa\$900001';
      final credentials = base64Encode(utf8.encode('$username:$password'));

      // Send GET request with headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic $credentials',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Error();
      }
    }

    var cowsResponse = await _sendGetRequest();
    var cowsJson = jsonDecode(cowsResponse);
    print(cowsJson);

    final cowsJsonList = cowsJson["daten"]["#BESTREG"] as List;
    var cowsList = cowsJsonList.map((cowJson) {
      var germanDateFormat = DateFormat("dd.MM.yyyy");
      return Cow(
          id: cowJson['LOM_X'],
          gender: cowJson['GESCHL_R'] == 2
              ? "Weiblich"
              : cowJson['GESCHL_R'] == 1
                  ? "Männlich"
                  : "",
          fatherId: "",
          motherId: cowJson['LOM_MUTX'] ?? "",
          race: cowJson['RASSE_X'],
          birthDate: germanDateFormat.parse(
              cowJson['GEB_DATR'] ?? germanDateFormat.format(DateTime.now())),
          multipleBirth: "Einling");
    }).toList();

    cows = cowsList..sort((a, b) => a.birthDate.compareTo(b.birthDate));
    cowsSubject.add(true);
    print("fetched");
  }
}
