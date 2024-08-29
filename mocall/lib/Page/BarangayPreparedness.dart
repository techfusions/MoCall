import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_container_flutter/loading_container_flutter.dart';
import 'package:saw/Page/HomePage.dart';
import 'package:saw/Page/views/Pdfviews.dart';

class BarangayPreparednessPlan extends StatefulWidget {
  const BarangayPreparednessPlan({super.key});

  @override
  State<BarangayPreparednessPlan> createState() =>
      _BarangayPreparednessPlanState();
}

class _BarangayPreparednessPlanState extends State<BarangayPreparednessPlan> {
  //double? _progress;
  final barangay = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('barangayPDF');
  List<Map<dynamic, dynamic>> _dataList = [];
  bool loading = true;

  @override
  void initState() {
    _fetchbarangay();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  Future<void> _fetchbarangay() async {
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
        barangay.text = value['barangay'];
      });
      setState(() {
        _fetchPdf(barangay.text);
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> _fetchPdf(String barangay) async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseRef
          .orderByChild("barangay")
          .equalTo("${barangay}")
          .once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        _dataList.add(value);
      });
      setState(() {});
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
                    "Barangay Preparedness Plan",
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
                                      'images/assets/pdflogo.png',
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
                                                      PDFViewScreen(
                                                    title:
                                                        '${_dataList[index]['title']}',
                                                    url:
                                                        '${_dataList[index]['pdfUrl']}',
                                                  ),
                                                ));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '${_dataList[index]['title']}',
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
                                              '${_dataList[index]['date']}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF1877F2),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          /*  Container(
                                              margin: const EdgeInsets.only(
                                                  left: 140.0),
                                              child: _progress != null
                                                  ? LoadingAnimationWidget
                                                      .staggeredDotsWave(
                                                          color:
                                                              Color(0xFF1877F2),
                                                          size: 30.0)
                                                  : IconButton(
                                                      tooltip: 'Download PDF',
                                                      onPressed: () {
                                                        // file downloader function area
                                                        FileDownloader
                                                            .downloadFile(
                                                                url:
                                                                    '${_dataList[index]['pdfUrl']}',
                                                                onProgress: (name,
                                                                    progress) {
                                                                  setState(() {
                                                                    _progress =
                                                                        progress;
                                                                  });
                                                                },
                                                                onDownloadCompleted:
                                                                    (value) {
                                                                  print(
                                                                      'path  $value ');
                                                                  setState(() {
                                                                    AwesomeDialog(
                                                                      context:
                                                                          context,
                                                                      dialogType:
                                                                          DialogType
                                                                              .success,
                                                                      animType:
                                                                          AnimType
                                                                              .bottomSlide,
                                                                      title:
                                                                          'Download Complete',
                                                                      desc:
                                                                          'The PDF has been downloaded successfully.',
                                                                      btnOkOnPress:
                                                                          () {},
                                                                    )..show();
                                                                    _progress =
                                                                        null;
                                                                  });
                                                                });

                                                        // end downloader function area
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .download,
                                                        color: Colors.red,
                                                      ))), */
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
