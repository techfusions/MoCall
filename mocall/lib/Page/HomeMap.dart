import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//import 'package:saw/Page/Details/Articles.dart';
//import 'package:saw/Page/Details/Guidlines.dart';
//import 'package:saw/Page/Details/Recommendation.dart';
import 'package:saw/sql/MapTypeDb.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType maptype = MapType.hybrid;
  //DateTime _selectedDateTime = DateTime.now();
  // final DateFormat formatter = DateFormat('HH');
//  TimeOfDay _selectedTime = TimeOfDay.now();
//  bool? isDetails;
  bool absorbPointer = true;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('reportincident');
  List<Polyline> polyline = [];
  List<Marker> marker = [];

//  bool? haveDetails;
  String mapTypeString = "";
  final phonenumber = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _involveIncidentController = TextEditingController();
  TextEditingController _purokController = TextEditingController();
  TextEditingController _barangayController = TextEditingController();
  double? lat;
  double? long;
  // sqflite database connection class area
  bool _isLoading = true;
  MapTypeDB _maptypeDB = new MapTypeDB();

  // end sqflite databaes connection class area

  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(8.486709969085696, 123.80621143850668),
    zoom: 14,
  );

  /*
  void updateCamera(double lat, double lng)async{
    CameraPosition cameraPosition = CameraPosition(
          target: LatLng(lat, lng), zoom: 14);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    
  }
  */
/*
  void ShowMyReportPositionLine() async {
    polyline.add(
      Polyline(
          polylineId: PolylineId('MY POLYLINES REPORT LOCATIONS'),
          color: Colors.red,
          width: 2,
          points: [
            LatLng(lat!, long!),
            LatLng(8.49632049926309, 123.78943668238726)
          ]),
    );

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat!, long!), zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }
  */

  void locateCityDisasterCoordinatingCouncil() async {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(lat!, long!), zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Icon(Icons.settings),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("MAP SETTINGS"))
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/assets/mapupdate.png', // Your image path
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                ListBody(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/hybrid.jpeg"),
                      title: Text('Hybrid'),
                      onTap: () async {
                        //setState(() {
                        mapTypeString = "Hybrid";
                        await _maptypeDB.update(1001, mapTypeString);
                        _getMapTypeFromString(mapTypeString);
                        //  maptype = MapType.hybrid;
                        Navigator.pop(context); // Close the dialog
                        //  });
                        setState(() {});
                        // Handle option 1 selection
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/normal.jpg"),
                      title: Text('Normal'),
                      onTap: () async {
                        //   setState(() {
                        mapTypeString = "Normal";
                        await _maptypeDB.update(1001, mapTypeString);
                        _getMapTypeFromString(mapTypeString);
                        // maptype = MapType.normal;
                        setState(() {});
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/none.jpg"),
                      title: Text('None'),
                      onTap: () async {
                        // setState(() {
                        mapTypeString = "None";
                        await _maptypeDB.update(1001, mapTypeString);
                        _getMapTypeFromString(mapTypeString);
                        //  maptype = MapType.none;
                        setState(() {});
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/satellite.jpg"),
                      title: Text('Satellite'),
                      onTap: () async {
                        //setState(() {
                        mapTypeString = "Satellite";
                        await _maptypeDB.update(1001, mapTypeString);
                        _getMapTypeFromString(mapTypeString);
                        // maptype = MapType.satellite;
                        setState(() {});
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/terrain.jpg"),
                      title: Text('Terrain'),
                      onTap: () async {
                        //  setState(() {
                        mapTypeString = "Terrain";
                        await _maptypeDB.update(1001, mapTypeString);
                        _getMapTypeFromString(mapTypeString);
                        setState(() {});
                        // maptype = MapType.terrain;
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

// switch maptype area
  MapType _getMapTypeFromString(String mapTypeString) {
    if (mapTypeString == "Hybrid") {
      return MapType.hybrid;
    } else if (mapTypeString == "Normal") {
      return MapType.normal;
    } else if (mapTypeString == "None") {
      return MapType.none;
    } else if (mapTypeString == "Satellite") {
      return MapType.satellite;
    } else if (mapTypeString == "Terrain") {
      return MapType.terrain;
    } else {
      return MapType.hybrid;
    }
  }

// end switch maptype area
/*
  void _makePhoneCall() async {
    var phoneNumber = 'tel:${phonenumber.text}'; // Replace with your phone number
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

void launchSMS() async {
  // Construct the SMS URL
  String url = 'sms:${phonenumber.text}?body=${Uri.encodeComponent('Write your message')}';

  // Check if the device can handle launching the URL
  if (await canLaunch(url)) {
    // Launch the URL
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
 */
  @override
  void initState() {
    // print('Datetime: ${_selectedDateTime}');
    //print("hours: ${formatter.format(_selectedDateTime)}");
    // print("${_selectedTime.hour}");
    //  phonenumber.text = "9482772125";
    // isDetails = true;
    CallMapType();
    locateCityDisasterCoordinatingCouncil();
    _fetchMarkers();

    super.initState();
  }

  Future<void> _fetchMarkers() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> markersMap =
            snapshot.value as Map<dynamic, dynamic>;
        markersMap.forEach((key, value) {
          lat = value['latitude'];
          long = value['longtitude'];
          final markers = Marker(
              markerId: MarkerId(value['reportid']),
              position: LatLng(value['latitude'], value['longtitude']),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                  title: '${value['involveIncident']}',
                  snippet:
                      'Time: ${value['timereported']}  Date: ${value['datereported']}'),
              onTap: () {
                _recommendation(
                    value['barangay'],
                    value['purok'],
                    value['vehicle'],
                    value['landmark'],
                    value['involveIncident']);
              });

          setState(() {
            marker.add(markers);
          });
        });
      } else if (snapshot.value == null) {
        AwesomeDialog(
          // Prevents dismissal by pressing the back button
          context: context,
          body: Text(
            "NO INCIDENT YET!",
          ),
          alignment: Alignment.center,
          animType: AnimType.bottomSlide,
          dialogType: DialogType.info,
          btnOkOnPress: () {},
          btnOkColor: Colors.blueAccent,
        ).show();
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _recommendation(String barangay, String purok, String vehicle,
      String landmark, String involveIncident) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      alignment: Alignment.center,
      body: Column(
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
            child: TextFormField(
              controller: _barangayController..text = barangay,
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.city),
                labelText: 'Barangay',
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
              controller: _purokController..text = purok,
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.city),
                labelText: 'Purok',
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
              controller: _landmarkController..text = landmark,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Landmark',
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
              controller: _involveIncidentController..text = involveIncident,
              maxLines: 5,
              decoration: InputDecoration(
                label: Text("Incident Report"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    ).show();
  }

  // map call function area

  void CallMapType() async {
    final Database database = await _maptypeDB.conn();

    var result =
        await database.rawQuery("SELECT mapType FROM Users WHERE id=1001");
    mapTypeString = result.first['mapType'].toString();
  }

  // end map call function area

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Color.fromARGB(255, 0, 255, 229), size: 40.0))
              : GoogleMap(
                  mapType: _getMapTypeFromString(mapTypeString),
                  webGestureHandling: WebGestureHandling.auto,
                  initialCameraPosition: _initialPosition,
                  /*  polygons:{
              Polygon(polygonId: PolygonId('Oroquieta City'),
              points: [
                  LatLng(8.496322036477785, 123.78115892987698),
                  LatLng(8.49632049926309, 123.78943668238726)
              ]  
            )
            }, */
                  polylines: Set<Polyline>.of(polyline),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(marker)),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 10,
            ),
            /*   FloatingActionButton(
              onPressed: () {
                setState(() {
                  ShowMyReportPositionLine();
                  // updateCamera(lats, lngs);
                });
              },
              child: Icon(
                FontAwesomeIcons.location,
                color: Color(0xFF1877F2),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              elevation: 4.0,
              tooltip: 'Show My Report Position Line',
            ),*/
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  locateCityDisasterCoordinatingCouncil();
                });
              },
              child: Icon(
                FontAwesomeIcons.location,
                color: Color(0xFF1877F2),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'Locate Incident',
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showSettingsDialog(context);
                });
              },
              child: Icon(
                Icons.settings,
                color: Color(0xFF1877F2),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'Change Map Type',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
