import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:saw/Page/AppBarPage/Graph.dart';
import 'package:saw/Page/AppBarPage/PreparednessPlan.dart';
import 'package:saw/Page/AppBarPage/ProfilePage.dart';
import 'package:saw/Page/AppBarPage/SettingPage.dart';
import 'package:saw/Page/BarangayPreparedness.dart';
import 'package:saw/Page/DiscussionForum.dart';
import 'package:saw/Page/HomeMap.dart';
import 'package:saw/Page/InformationRescueRecords.dart';
import 'package:saw/Page/Report_Incident.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saw/main.dart';

//import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 1;
  bool isMapSetting = true;
  final imageUrl = TextEditingController();
  final fullname = TextEditingController();
  final email = TextEditingController();

  final screen = [DiscussionForum(), HomeMap(), ReportIncident()];

  void _showLogoutConfirmationDialog(BuildContext context) {
    AwesomeDialog(
            context: context,
            animType: AnimType.topSlide,
            title: 'Logout',
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'images/assets/logout.png', // Replace with your image path
                    height: 200.0,
                  ),
                ),
                Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            btnOkOnPress: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WelcomeScreen()),
                  (route) => false);
            },
            btnCancelOnPress: () {})
        .show();
  }

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');
  @override
  void initState() {
    _fetchMarkers();
    super.initState();
  }

  Future<void> _fetchMarkers() async {
    try {
      DatabaseEvent event = await _databaseReference
          .orderByChild("email")
          .equalTo(FirebaseAuth.instance.currentUser!.email)
          .once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> markersMap =
            snapshot.value as Map<dynamic, dynamic>;
        markersMap.forEach((key, value) {
          setState(() {
            imageUrl.text = value['imageUrl'];
            fullname.text = value['name'];
            email.text = value['email'];
          });
        });
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1877F2),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      // Add your profile picture here
                      backgroundImage: NetworkImage('${imageUrl.text}'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${fullname.text}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${email.text}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.white),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.file, color: Colors.white),
                title: Text(
                  'Preparedness Plan',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PreparednessPlan()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.file, color: Colors.white),
                title: Text(
                  'Barangay Preparedness Plan',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BarangayPreparednessPlan()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.chartPie, color: Colors.white),
                title: Text(
                  'Graph',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Graph()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text(
                  'Portal',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformationRescueRecords()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeactivateUserScreen()),
                      (route) => false);
                },
              ),
              Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: screen[index],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Color(0xFF1877F2),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        color: Color(0xFF1877F2),
        items: [
          const Icon(FontAwesomeIcons.list, color: Colors.white),
          const Icon(
            FontAwesomeIcons.mapLocation,
            color: Colors.white,
          ),
          const Icon(
            FontAwesomeIcons.locationPin,
            color: Colors.white,
          )
        ],
        index: index,
        onTap: (index) {
          setState(() {
            this.index = index;
            if (this.index == 0) {
              isMapSetting = false;
            } else if (this.index == 1) {
              isMapSetting = true;
            } else if (this.index == 2) {
              isMapSetting = false;
            }
          });
        },
      ),
    );
  }
}
