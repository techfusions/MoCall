import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saw/Page/HomePage.dart';
import 'package:saw/Page/views/Portalviews.dart';
import 'package:loading_container_flutter/loading_container_flutter.dart';

class InformationRescueRecords extends StatefulWidget {
  const InformationRescueRecords({super.key});

  @override
  State<InformationRescueRecords> createState() =>
      _InformationRescueRecordsState();
}

class _InformationRescueRecordsState extends State<InformationRescueRecords> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('ResponseRecord');
  List<Map<dynamic, dynamic>> _dataList = [];
  // ignore: unused_field
  List<Map<dynamic, dynamic>> _filteredSource = [];
  final userid = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    _fetcUserid();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  Future<void> _fetcUserid() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseReference
          .orderByChild("email")
          .equalTo(FirebaseAuth.instance.currentUser!.email)
          .once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        //  _dataList.add(value);
        userid.text = value['idnumber'];
      });
      setState(() {
        fetchReportRespond(userid.text);
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> fetchReportRespond(String userid) async {
    setState(() {});
    try {
      DatabaseEvent event =
          await _databaseRef.orderByChild("userid").equalTo(userid).once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        _dataList.add(value);
      });
      setState(() {
        _filteredSource = List.from(_dataList);
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1877F2),
          title: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              },
              icon: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    "Portal",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              )),
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                itemCount: _dataList.length,
                itemBuilder: (context, index) {
                  if (_dataList.isNotEmpty) {
                    return loading == true
                        ? Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                LoadingContainerWidget(
                                  height: 150,
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  colorOne: Colors.grey[300],
                                  colorTwo: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  duration: const Duration(milliseconds: 800),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 150,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    child: Image.asset(
                                      'images/assets/announcementupdate.png',
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 6),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PortalViews(
                                                          datereported: _dataList[
                                                                  index]
                                                              ['datereported'],
                                                          landmark:
                                                              _dataList[index]
                                                                  ['landmark'],
                                                          barangay:
                                                              _dataList[index]
                                                                  ['barangay'],
                                                          timereported: _dataList[
                                                                  index]
                                                              ['timereported'],
                                                          keys: _dataList[index]
                                                              ['key'],
                                                          image:
                                                              _dataList[index]
                                                                  ['image'],
                                                        )));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'VIEW',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF1877F2),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3.0,
                                              ),
                                              Icon(
                                                FontAwesomeIcons.arrowRight,
                                                color: Colors.blue,
                                                size: 16.0,
                                              )
                                            ],
                                          )),
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 13.0),
                                            child: Text(
                                              '${_dataList[index]['daterespond']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF1877F2),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 95.0),
                                            child: Text(
                                              '${_dataList[index]['timereported']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF1877F2),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                  } else if (_dataList.isEmpty) {
                    return Center(
                      child: Text(
                        "NO DATA FOUND",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              )),
        ),
      ),
    );
  }
}
