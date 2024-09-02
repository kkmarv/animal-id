import 'dart:io';

import 'package:flutter/material.dart';

import '../settings/settings_view.dart';

class FarmDetailView extends StatelessWidget {
  static const routeName = '/farm-detail-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: () {
          _showDialog(context);
        },
      ),
      appBar: AppBar(
        title: Text('Betriebsübersicht'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BetriebCard(
              betriebsName: "Musterhof",
              betriebsId: "123456",
              zertifizierungen: ["qs", "bio"],
              adresse: "Musterstraße 1, 12345 Musterstadt",
              betriebsspiegel: {
                'Kühe': 120,
                'Schafe': 80,
                'Hühner': 200,
              },
            ),
          ),
          ExpansionPanelListExample(),

/*
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {

            },
            children: [
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Text("Body");
                  },
                  body: CowTable(
                    cows: cows,
                    onCowSelected: (cowId) {},
                  )),
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Text("Body");
                  },
                  body: SlurryTable(
                    slurrys: slurrys,
                    onCowSelected: (e) {},
                  )),
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Text("Body");
                  },
                  body: FieldsTable(
                    fields: [ ],
                    onCowSelected: (cowId) {},
                  ))
            ],
          ),*/
        ],
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: switch (index) {
        0 => CowTable(
            cows: cows,
            onCowSelected: (cowId) {},
          ),
        1 => SlurryTable(
            slurrys: slurrys,
            onSlurrySelected: (e) {},
          ),
        2 => FieldsTable(
            fields: [],
            onFiedSelected: (fieldId) {},
          ),
        _ => CowTable(
            cows: cows,
            onCowSelected: (cowId) {},
          )
      },
    );
  });
}

class ExpansionPanelListExample extends StatefulWidget {
  const ExpansionPanelListExample({super.key});

  @override
  State<ExpansionPanelListExample> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExample> {
  final List<Item> _data = generateItems(3);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: item.expandedValue,
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class SlurryTable extends StatelessWidget {
  final Iterable<Slurry> slurrys;
  final Function(int) onSlurrySelected;

  const SlurryTable({
    required this.slurrys,
    required this.onSlurrySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;

    return DataTable(
      showCheckboxColumn: false,
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Meldedatum')),
        DataColumn(label: Text('Abgeber')),
        DataColumn(label: Text('Aufnehmer')),
        DataColumn(label: Text('Menge')),
        DataColumn(label: Text('Art')),
      ],
      rows: [
        for (final (index, slurry) in slurrys.indexed)
          DataRow(
            onSelectChanged: (selected) {
              onSlurrySelected(index);
            },
            cells: [
              DataCell(Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 50,
                  child: Image(image: AssetImage('assets/images/cow.png')),
                ),
              )),
              DataCell(Text(slurry.meldedatum)),
              DataCell(Text(slurry.abgeber)),
              DataCell(Text(slurry.aufnehmer)),
              DataCell(Text(slurry.menge)),
              DataCell(Text(slurry.art)),
            ],
          )
      ],
    );
  }
}

class FieldsTable extends StatelessWidget {
  final Iterable<Field> fields;
  final Function(int) onFiedSelected;

  const FieldsTable({
    required this.fields,
    required this.onFiedSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;

    return DataTable(
      showCheckboxColumn: false,
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Feldblock')),
        DataColumn(label: Text('Schlag Nr.')),
        DataColumn(label: Text('Schlag Bezeichnung')),
        DataColumn(label: Text('Teilschlag')),
        DataColumn(label: Text('Größe')),
        DataColumn(label: Text('Kultur')),
      ],
      rows: [
        for (final (index, field) in fields.indexed)
          DataRow(
            onSelectChanged: (selected) {
              onFiedSelected(index);
            },
            cells: [
              DataCell(Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 50,
                  child: Image(image: AssetImage('assets/images/cow.png')),
                ),
              )),
              DataCell(Text(field.feldblock)),
              DataCell(Text(field.schlagNr)),
              DataCell(Text(field.schlagBezeichnung)),
              DataCell(Text(field.teilschlag)),
              DataCell(Text(field.groesse)),
              DataCell(Text(field.kultur)),
            ],
          )
      ],
    );
  }
}

class CowTable extends StatelessWidget {
  final Iterable<Cow> cows;
  final Function(int) onCowSelected;

  const CowTable({
    required this.cows,
    required this.onCowSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;

    return DataTable(
      showCheckboxColumn: false,
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Geschlecht')),
        DataColumn(label: Text('Vater ID')),
        DataColumn(label: Text('Mutter ID')),
        DataColumn(label: Text('SBT/RBT')),
        DataColumn(label: Text('Geburtsdatum')),
        DataColumn(label: Text('Abgangsdatum')),
      ],
      rows: [
        for (final (index, cow) in cows.indexed)
          DataRow(
            onSelectChanged: (selected) {
              onCowSelected(index);
            },
            cells: [
              DataCell(Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 50,
                  child: Image(
                      image: AssetImage(
                          'assets/images/${_getCowType(cow.birthDate)}.png')),
                ),
              )),
              DataCell(Text(cow.id)),
              DataCell(Text(cow.gender)),
              DataCell(Text(cow.fatherId)),
              DataCell(Text(cow.motherId)),
              DataCell(Text(cow.sbtOrRbt)),
              DataCell(Text(cow.birthDate.toLocal().toShortDateString())),
              DataCell(Text(cow.departureDate != null
                  ? cow.departureDate!.toLocal().toShortDateString()
                  : 'Noch vorhanden')),
            ],
          )
      ],
    );
  }
}

// Methode zur Bestimmung des Typs
String _getCowType(DateTime birthDate) {
  final now = DateTime.now();
  final age = now.difference(birthDate).inDays / 365; // Alter in Jahren
  return age < 1 ? 'calve' : 'cow';
}

class BetriebCard extends StatelessWidget {
  final String betriebsName;
  final String betriebsId;
  final List<String> zertifizierungen;
  final String adresse;
  final Map<String, int> betriebsspiegel;

  BetriebCard({
    required this.betriebsName,
    required this.betriebsId,
    required this.zertifizierungen,
    required this.adresse,
    required this.betriebsspiegel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farm Icon hinzufügen
            Center(
              child: Image.asset(
                'assets/images/farm.png',
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 16),
            Text(
              betriebsName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Betriebs-ID: $betriebsId',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: zertifizierungen
                  .map((zert) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          zert == "bio"
                              ? 'assets/images/bio.jpg'
                              : zert == "qs"
                                  ? 'assets/images/qs.png'
                                  : "",
                          height: 50, // Größe der Logos anpassen
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Adresse:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              adresse,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Betriebsspiegel:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: betriebsspiegel.entries
                  .map((entry) => Text(
                        '${entry.key}: ${entry.value} Tiere',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Slurry {
  final String meldedatum;
  final String abgeber;
  final String aufnehmer;
  final String menge;
  final String art;

  Slurry(
      {required this.meldedatum,
      required this.abgeber,
      required this.aufnehmer,
      required this.menge,
      required this.art});
}

class Field {
  final String feldblock;
  final String schlagNr;
  final String schlagBezeichnung;
  final String teilschlag;
  final String groesse;
  final String kultur;

  Field(
      {required this.feldblock,
      required this.schlagNr,
      required this.schlagBezeichnung,
      required this.teilschlag,
      required this.groesse,
      required this.kultur});
}

class Cow {
  final String id;
  final String gender; // 'Männlich' or 'Weiblich'
  final String fatherId;
  final String motherId;
  final String sbtOrRbt; // 'SBT' or 'RBT'
  final DateTime birthDate;
  final DateTime?
      departureDate; // Optional, as not all cows may have a departure date

  Cow({
    required this.id,
    required this.gender,
    required this.fatherId,
    required this.motherId,
    required this.sbtOrRbt,
    required this.birthDate,
    this.departureDate,
  });
}

final List<Slurry> slurrys = [
  Slurry(meldedatum: "03.08.2024", abgeber: "Güllehandel Nord", aufnehmer: "Musterhof", menge: "155", art: "Gärrest aus Biogasanlage"),
  Slurry(meldedatum: "15.04.2024", abgeber: "Landwirt Karl-Heinz", aufnehmer: "Musterhof", menge: "50", art: "Hühnertrockenkot"),
  Slurry(meldedatum: "20.05.2024", abgeber: "Bauer Rudolf", aufnehmer: "Musterhof", menge: "50", art: "Milchviehgülle"),
  Slurry(meldedatum: "20.05.2024", abgeber: "Schweine GbR Schleswig", aufnehmer: "Musterhof", menge: "90", art: "Schweinegülle"),
  Slurry(meldedatum: "20.05.2024", abgeber: "Landwirt Alfred", aufnehmer: "Landwirt Müller", menge: "500", art: "Gärrest aus Biogasanlage"),
  Slurry(meldedatum: "21.05.2024", abgeber: "Kälberzucht Nordrhein", aufnehmer: "Musterhof", menge: "100", art: "Kälbergülle"),
  Slurry(meldedatum: "30.08.2024", abgeber: "Kuhparadies Berlin", aufnehmer: "Landwirt Müller", menge: "50", art: "Milchviehgülle"),
  Slurry(meldedatum: "30.08.2024", abgeber: "Bio-Puten Musterhof", aufnehmer: "Musterhof", menge: "234,50", art: "Putenmist"),
  Slurry(meldedatum: "03.09.2024", abgeber: "Sabine Müller", aufnehmer: "Landwirt Müller", menge: "25", art: "Gärrest aus Biogasanlage"),
  Slurry(meldedatum: "03.09.2024", abgeber: "Landwirtschaft GmbH", aufnehmer: "Musterhof", menge: "30", art: "Rindermist"),
];

final List<Field> fields = [
  Field(
      feldblock: "DENWLI0547050544",
      schlagNr: "2",
      schlagBezeichnung: "Feld am Hof",
      teilschlag: "a",
      groesse: "1,7450",
      kultur: "411 - Silomais"),
  Field(
      feldblock: "DENWLI0547060029",
      schlagNr: "205",
      schlagBezeichnung: "Hinterm Berg",
      teilschlag: "a",
      groesse: "0,4025",
      kultur: "115 - Winterweichweizen"),
  Field(
      feldblock: "DENWLI0547061194",
      schlagNr: "80",
      schlagBezeichnung: "Bei Bauer Müller",
      teilschlag: "a",
      groesse: "0,6328",
      kultur: "459 - Grünland"),
  Field(
      feldblock: "DENWLI0547060029",
      schlagNr: "2024",
      schlagBezeichnung: "Kirchenland",
      teilschlag: "a",
      groesse: "6,9051",
      kultur: "131 - Wintergerste"),
  Field(
      feldblock: "DENWLI0547050544",
      schlagNr: "1",
      schlagBezeichnung: "In Berlin",
      teilschlag: "a",
      groesse: "1,4486",
      kultur: "603 - Zuckerrübe"),
  Field(
      feldblock: "",
      schlagNr: "56",
      schlagBezeichnung: "Hundeplatz",
      teilschlag: "a",
      groesse: "0,6789",
      kultur: "603 - Zuckerrüben"),
  Field(
      feldblock: "DENWLI0547060029",
      schlagNr: "60",
      schlagBezeichnung: "Neben Heinz",
      teilschlag: "a",
      groesse: "0,4724",
      kultur: "411 - Silomais"),
  Field(
      feldblock: "DENWLI0547060029",
      schlagNr: "90",
      schlagBezeichnung: "Heide groß",
      teilschlag: "a",
      groesse: "12,6541",
      kultur: "459 - Grünland"),
  Field(
      feldblock: "DENWLI0547050544",
      schlagNr: "100",
      schlagBezeichnung: "Großes Feld",
      teilschlag: "c",
      groesse: "1,6341",
      kultur: "459 - Grünland"),
  Field(
      feldblock: "DENWLI0547060029",
      schlagNr: "101",
      schlagBezeichnung: "In der Stadt",
      teilschlag: "a",
      groesse: "12,6541",
      kultur: "115 - Winterweichweizen"),
];

final List<Cow> cows = [
  Cow(
    id: 'DE 05 385 85496',
    gender: 'Männlich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 394 61009',
    sbtOrRbt: 'SBT',
    birthDate: DateTime(2021, 3, 10),
    departureDate: DateTime(2023, 8, 10),
  ),
  Cow(
    id: 'DE 05 394 61009',
    gender: 'Weiblich',
    fatherId: 'DE 05 379 98801',
    motherId: 'DE 05 392 52235',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2023, 1, 20),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 379 98801',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 367 95167',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 1, 20),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 400 97241',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 392 52215',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2022, 1, 24),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 394 61009',
    gender: 'Weiblich',
    fatherId: 'DE 05 379 98801',
    motherId: 'DE 05 367 95167',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 12, 20),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 392 52215',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 367 95167',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 1, 20),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 394 61009',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52215',
    motherId: 'DE 05 367 95167',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 1, 30),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE DE 05 379 98801',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 367 95167',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 12, 20),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 394 61009',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 379 98801',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 8, 30),
    departureDate: null, // No departure date
  ),
  Cow(
    id: 'DE 05 392 52215',
    gender: 'Weiblich',
    fatherId: 'DE 05 392 52235',
    motherId: 'DE 05 392 52215',
    sbtOrRbt: 'RBT',
    birthDate: DateTime(2024, 1, 20),
    departureDate: null, // No departure date
  ),
  // Weitere Rinder hinzufügen...
];

extension DateUtils on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // TabBar
              TabBar(
                tabs: [
                  Tab(text: 'Kälber'),
                  Tab(text: 'Schweine'),
                ],
              ),
              // TabBarView
              Container(
                height: 400.0, // Fixed height for TabBarView
                child: TabBarView(
                  children: [
                    Center(child: AddCalveDiaog()),
                    Center(child: Text('Inhalt für Schweine')),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showCowTableDialog(BuildContext context,
    {required Function(int) onCowSelected}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: CowTable(
          cows: cows,
          onCowSelected: onCowSelected,
        ),
      );
    },
  );
}

class AddCalveDiaog extends StatefulWidget {
  @override
  _AddCalveDiaogState createState() => _AddCalveDiaogState();
}

class _AddCalveDiaogState extends State<AddCalveDiaog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kalb erfassen'),
        ),
        body: AnimalForm());
  }
}

class AnimalForm extends StatefulWidget {
  @override
  _AnimalFormState createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _barcodeController = TextEditingController();
  String? gender;
  DateTime? birthDate;
  final TextEditingController _motherEarTagController = TextEditingController();

  String? race;
  String? multipleBirth;

  // Funktion zum Auswählen des Geburtsdatums
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != birthDate) {
      setState(() {
        birthDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _barcodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Geben Sie eine Zahl ein',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Transform.rotate(
                        angle: 90 *
                            3.1415927 /
                            180, // 90 Grad in Bogenmaß umrechnen
                        child: Icon(
                          Icons.view_headline_sharp,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final result = await Process.run(
                            'python',
                            ['../webcam_barcode_scanner/webcam.py'],
                          );

                          if (result.exitCode == 0) {
                            setState(() {
                              String? barcode = result.stdout.trim();
                              _barcodeController.text = barcode!;
                            });
                          } else {
                            print('Fehler: ${result.stderr}');
                          }
                        } catch (e) {
                          print('Fehler beim Ausführen des Skripts: $e');
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Geschlecht Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Geschlecht'),
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue;
                  });
                },
                items: <String>['männlich', 'weiblich']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte das Geschlecht auswählen';
                  }
                  return null;
                },
              ),

              // Geburtsdatum
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Geburtsdatum',
                  hintText: birthDate != null
                      ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
                      : 'Wählen Sie das Geburtsdatum',
                ),
                readOnly: true,
                onTap: () => _selectBirthDate(context),
                validator: (value) {
                  if (birthDate == null) {
                    return 'Bitte das Geburtsdatum auswählen';
                  }
                  return null;
                },
              ),

              // Ohrmarke der Mutter
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _motherEarTagController,
                      decoration:
                          InputDecoration(labelText: 'Ohrmarke der Mutter'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte die Ohrmarke der Mutter eingeben';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: IconButton(
                      icon: SizedBox(
                          width: 50,
                          child: Image(
                              image: AssetImage('assets/images/cow.png'))),
                      onPressed: () async {
                        _showCowTableDialog(context,
                            onCowSelected: (int selectedIndex) {
                          setState(() {
                            _motherEarTagController.text =
                                cows[selectedIndex].id.toString();
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Rasse Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Rasse'),
                value: race,
                onChanged: (String? newValue) {
                  setState(() {
                    race = newValue;
                  });
                },
                items: <String>['SBT', 'RBT']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte die Rasse auswählen';
                  }
                  return null;
                },
              ),

              // Mehrling Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Mehrling'),
                value: multipleBirth,
                onChanged: (String? newValue) {
                  setState(() {
                    multipleBirth = newValue;
                  });
                },
                items: <String>['Einling', 'Zwilling', 'Drilling', 'Vierling']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte die Mehrlingsart auswählen';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Formular ist gültig');
                    print('Geschlecht: $gender');
                    print(
                        'Geburtsdatum: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}');
                    print(
                        'Ohrmarke der Mutter: ${_motherEarTagController.text}');
                    print('Rasse: $race');
                    print('Mehrling: $multipleBirth');
                  }
                },
                child: Text('Erfassen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
