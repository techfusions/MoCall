import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportIncident extends StatelessWidget {
  const ReportIncident({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Report(),
    );
  }
}

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

const List<String> barangay = [
  'Barangay',
  /* 'Apil',
  'Binuangan',
  'Bolibol',
  'Buenavista',
  'Bunga',
  'Buntawan',
  'Burgos',
  'Canubay',
  'Clarin Settlement',
  'Dolipos Bajo',
  'Dolipos Alto',
  'Dulapo',
  'Dullan Norte',
  'Dullan Sur',
  'Lower Lamac',
  'Layawan',
  'Lower Langcangan',
  'Lower Loboc',
  'Lower Rizal',
  'Malindang',
  'Mialen', */
  'Mobod',
  'Canubay',
  'Lower Loboc',
  /* 'Paypayan',
  'Pines',
  'Poblacion',
  'Poblacion',
  'Proper Langcangan',
  'Dagatan',
  'Baybay Dagatan',
  'Sebucal',
  'Senote',
  'Taboc Norte',
  'Taboc Sur',
  'Talairon',
  'Talic',
  'Toliyok',
  'Tipan',
  'Tuyabang Alto',
  'Tuyabang Bajo',
  'Tuyabang Proper',
  'Upper Langcangan',
  'Upper Lamac',
  'Upper Loboc',
  'Upper Rizal (Tipalac)',
  'Victoria',
  'Villaflor'*/
];

// List of vehicles
List<String> vehicles = [
  'Vehicles Needed',
  'Ambulance',
  'Firetruck',
  'Police',
  'Rescue vehicle',
  'Patrol vehicle',
  'Utility vehicle',
  'Water tanker',
  'Relief vehicle'
];

class _ReportState extends State<Report> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  // TextEditingController _dateController = TextEditingController();
  // ignore: unused_field
//  TextEditingController _timeController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _involveIncidentController = TextEditingController();
  TextEditingController _purokController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.ref();
  bool Reportloading = false;
  bool submitabsorbPointer = false;
  bool absorbPointer = false;
  double? lat;
  double? long;
  int? _randomNumber;
  String? personalid;
  String? reportname;
  String _selectedBarangay = barangay.first;
  String _selectVehicles = vehicles.first;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');

  Future<Position> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {}

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      absorbPointer = true;
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
    }
    return await Geolocator.getCurrentPosition();
  }

/*
  packData() {
    getUserLocation().then((value) async {
      print('My Location');
      print('${value.latitude}, ${value.longitude}');
      submitReport(value.latitude, value.longitude);
      // List<Placemark> placemark =
      //  await placemarkFromCoordinates(value.latitude, value.longitude);
      // List<Location> location = await locationFromAddress("Bato, Plaridel, Misamis Occidental");
      //  print('${placemark.last.street}');
      //  print('${placemark.last.locality}');
      // print('${placemark.last.subThoroughfare}');
      //  print('${placemark.last.thoroughfare}');
      ////  print('${placemark.first.administrativeArea}');
      //print('${placemark.first.country}');
      // print('${placemark.first.subAdministrativeArea}');
      // _latitudeController.text = '${value.latitude}';
      //  _longtitudeController.text = '${value.longitude}';
      // _streetController.text = placemark.last.street!;
      //_administrativeAreaController.text = placemark.first.administrativeArea!;
      //  _countryController.text = placemark.first.country!;
      //print('${placemark.first.subAdministrativeArea}');

      // DateTime nowdate = DateTime.now();
      //  String formattedDate = '${nowdate.day}/${nowdate.month}/${nowdate.year}';
      // _dateController.text = formattedDate;
      //  String datetime = new DateFormat("kk:mm:a").format(DateTime.now());
      //  String formattedTime = '${datetime}';
      // _timeController.text = formattedTime;
/*
      _fetchData(
          value.latitude,
          value.longitude,
          placemark.last.street,
          placemark.first.administrativeArea,
          placemark.first.country,
          formattedDate,
          formattedTime,
          placemark.first.subAdministrativeArea);*/

      setState(() {});
    });
  }
*/
  @override
  void initState() {
    // _checkPermissions();
    //  packData();
    // getUserLocation();
    _requestPermissions();
    _generateRandomNumber();
    _fetchData();
    super.initState();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      _showPermanentlyDeniedDialog();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
    } catch (e) {
      _showLocationErrorDialog(e.toString());
    }
  }

  void _showLocationErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to get location: $error'),
          actions: [
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermissions();
                // _getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }

/*
  Future<void> _fetchData(
    double latitude,
    double longitude,
    String? street,
    String? administrativeArea,
    String? country,
    String formattedDate,
    String formattedTime,
    String? subAdministrativeArea,
  ) async {
    setState(() {
      process = true;
    });

    try {
      // Simulate fetching data from an API with a delay
      await Future.delayed(Duration(seconds: 5));
      // Replace this with your actual data fetching logic

      setState(() {
        _latitudeController.text = latitude.toString();
        _longtitudeController.text = longitude.toString();
        _streetController.text = street!;
        _administrativeAreaController.text = administrativeArea!;
        _countryController.text = country!;
        _dateController.text = formattedDate;
        _timeController.text = formattedTime;
        _subAdministrativeAreaController.text = subAdministrativeArea!;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error
    } finally {
      setState(() {
        process = false;
      });
    }
  }
*/
  void _generateRandomNumber() {
    Random random = Random();
    setState(() {
      _randomNumber = 1000 + random.nextInt(9000);
    });
  }

  void _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference
          .orderByChild('email')
          .equalTo('${FirebaseAuth.instance.currentUser?.email}')
          .once();

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          //  print('Key: $key, Value: $value');
          personalid = value['idnumber'];
          reportname = value['name'];
        });
      } else {
        print('No data available');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> submitReport() async {
    final String formattedDateTime =
        DateFormat('hh:mm:ss a').format(DateTime.now());
    DatabaseReference newRef = databaseReference.child('reportincident').push();
    // Get the unique key
    String? uniqueKey = newRef.key;
    String dateString = DateFormat('dd/MM/yyyy').format(DateTime.now());
    setState(() {
      Reportloading = true;
      submitabsorbPointer = false;
      absorbPointer = true;
    });

    try {
      // firebase realtime database area]
      await newRef.set({
        'key': uniqueKey,
        'reportid': _randomNumber.toString(),
        'userid': personalid.toString(),
        'timereported': formattedDateTime,
        'reportername': reportname.toString(),
        'latitude': lat,
        'longtitude': long,
        'barangay': _selectedBarangay.toString(),
        'purok': _purokController.text,
        'landmark': _landmarkController.text,
        'involveIncident': _involveIncidentController.text,
        'vehicle': _selectVehicles.toString(),
        'datereported': dateString,
      }).then((value) {
        print(databaseReference.key);
      });
      // end firebase realtimee database area
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _showBottomSheet(
            context,
            personalid.toString(),
            formattedDateTime,
            reportname.toString(),
            lat!,
            long!,
            _selectedBarangay,
            _purokController.text,
            _landmarkController.text,
            _involveIncidentController.text,
            _selectVehicles,
            dateString);
        Reportloading = false;
        submitabsorbPointer = false;
        absorbPointer = false;
        _landmarkController.clear();
        _involveIncidentController.clear();
        _purokController.clear();
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          title: 'SUCCESSFULLY',
          alignment: Alignment.center,
          dialogType: DialogType.success,
          body: Center(
              child: Text(
            "SUBMIT SUCCESSFULLY",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          )),
          autoHide: const Duration(seconds: 3),
          btnOkColor: Colors.green,
          btnOkOnPress: () {},
        ).show();
      });
    }
  }

  void _showBottomSheet(
      BuildContext context,
      String personalid,
      String formattedDateTime,
      String reportname,
      double lat,
      double long,
      String barangay,
      String purok,
      String landmark,
      String involveIncident,
      String selectVehicles,
      String dateString) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.sms),
                    iconSize: 30,
                    color: Colors.green,
                    onPressed: () {
                      String url =
                          "sms:09368447280?body=\nPersonalid: $personalid, \ntimereported: $formattedDateTime, \nreportername: $reportname, \nlatitude:$lat \nlongtitude: $long, \nbarangay: $barangay, \npurok: $purok, \nlandmark: $landmark, \ninvolveIncident: $involveIncident, \nvehicle: $selectVehicles, \ndatereported: $dateString";
                      // ignore: deprecated_member_use
                      launch(url);
                    },
                  ),
                  Text('SMS'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.email),
                    iconSize: 30,
                    color: Color.fromARGB(255, 255, 0, 0),
                    onPressed: () {
                      String url =
                          "mailto:techfusioninnovators@gmail.com?subject=Report Incident&body=\nPersonalid: $personalid, \ntimereported: $formattedDateTime, \nreportername: $reportname, \nlatitude:$lat \nlongtitude: $long, \nbarangay: $barangay, \npurok: $purok, \nlandmark: $landmark, \ninvolveIncident: $involveIncident, \nvehicle: $selectVehicles, \ndatereported: $dateString";
                      // ignore: deprecated_member_use
                      launch(url);
                    },
                  ),
                  Text('Email'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /* void getaddressfromlocation(String selectedBarangay) async {
    List<Location> location = await locationFromAddress(
        "${selectedBarangay}, Oroquieta city, Misamis Occidental");
    print("${location.first.latitude} ${location.last.longitude}");
    submitReport(location.first.latitude, location.last.longitude);
  }v*/

  void _showPermissionDeniedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Location permission is required to use this app.'),
          actions: [
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermissions();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Permanently Denied'),
          content: Text(
              'Location permission has been permanently denied. Please enable it in the app settings.'),
          actions: [
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'images/assets/reportincidentupdate.png', // Replace with your logo asset path
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 16),
                      AbsorbPointer(
                        absorbing: absorbPointer,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          value: _selectedBarangay,
                          hint: Text('Barangay'),
                          onChanged: (value) {
                            setState(() {
                              _selectedBarangay = value!;
                            });
                          },
                          items: barangay
                              .map((barangays) => DropdownMenuItem(
                                    value: barangays,
                                    child: Text(barangays),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 16),
                      AbsorbPointer(
                        absorbing: absorbPointer,
                        child: TextFormField(
                          controller: _purokController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.city),
                            labelText: 'Purok',
                            hintText: 'Enter the Purok',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      AbsorbPointer(
                        absorbing: absorbPointer,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          value: _selectVehicles,
                          hint: Text('Vehicle Needed'),
                          onChanged: (value) {
                            setState(() {
                              _selectVehicles = value!;
                            });
                          },
                          items: vehicles
                              .map((vehicle) => DropdownMenuItem(
                                    value: vehicle,
                                    child: Text(vehicle),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 16),
                      AbsorbPointer(
                        absorbing: absorbPointer,
                        child: TextFormField(
                          maxLines: 5,
                          controller: _landmarkController,
                          decoration: InputDecoration(
                            hintText: 'Enter the Landmark...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      AbsorbPointer(
                        absorbing: absorbPointer,
                        child: TextFormField(
                          controller: _involveIncidentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Enter the involved of Incident...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width:
                            280.0, // Adjust the width as per your requirement
                        child: AbsorbPointer(
                          absorbing: submitabsorbPointer,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedBarangay == "Barangay") {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    alignment: Alignment.center,
                                    dialogType: DialogType.error,
                                    body: Center(
                                        child: Text(
                                      "PLEASE SELECT THE BARANGAY",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    autoHide: const Duration(seconds: 5),
                                    btnCancelOnPress: () {},
                                  ).show();
                                } else if (_purokController.text.isEmpty) {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    alignment: Alignment.center,
                                    dialogType: DialogType.error,
                                    body: Center(
                                        child: Text(
                                      "PLEASE ENTER THE PUROK",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    autoHide: const Duration(seconds: 5),
                                    btnCancelOnPress: () {},
                                  ).show();
                                } else if (_landmarkController.text.isEmpty) {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    alignment: Alignment.center,
                                    dialogType: DialogType.error,
                                    body: Center(
                                        child: Text(
                                      "PLEASE ENTER THE LANDMARK",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    autoHide: const Duration(seconds: 5),
                                    btnCancelOnPress: () {},
                                  ).show();
                                } else if (_selectVehicles ==
                                    "Vehicles Needed") {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    alignment: Alignment.center,
                                    dialogType: DialogType.error,
                                    body: Center(
                                        child: Text(
                                      "PLEASE SELECT VEHICLES NEEDED",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    autoHide: const Duration(seconds: 5),
                                    btnCancelOnPress: () {},
                                  ).show();
                                } else if (_involveIncidentController
                                    .text.isEmpty) {
                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    title: 'Error',
                                    alignment: Alignment.center,
                                    dialogType: DialogType.error,
                                    body: Center(
                                        child: Text(
                                      "PLEASE ENTER INVOLVE INCIDENT",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    autoHide: const Duration(seconds: 5),
                                    btnCancelOnPress: () {},
                                  ).show();
                                } else {
                                  setState(() {
                                    submitReport();
                                  });
                                  // packData();
                                  //  getaddressfromlocation(_selectedBarangay);
                                  /* setState(() {
                                    Reportloading = true;
                                    submitabsorbPointer = false;
                                    absorbPointer = true;
                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      setState(() {
                                        Reportloading = false;
                                        submitabsorbPointer = false;
                                        absorbPointer = false;
                                        getaddressfromlocation(_selectedBarangay);
                                      });
                                    });
                                  });*/
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                  0xFF1877F2), // Set the background color to black
                              foregroundColor:
                                  Colors.white, // Set the text color to white
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Set the button shape to rectangular
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      16.0), // Adjust the vertical padding
                            ),
                            child: Reportloading == true
                                ? LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.white, size: 28.0)
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
