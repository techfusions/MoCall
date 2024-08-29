import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_container_flutter/loading_container_flutter.dart';
import 'package:saw/Page/views/ViewDiscussionForum.dart';

class DiscussionForum extends StatelessWidget {
  const DiscussionForum({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiscussionForumPage(),
    );
  }
}

class DiscussionForumPage extends StatefulWidget {
  const DiscussionForumPage({super.key});

  @override
  State<DiscussionForumPage> createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('discussion');
  List<Map<dynamic, dynamic>> _dataList = [];
  bool loading = true;

  @override
  void initState() {
    _fetchData();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseRef.once();
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
    return Scaffold(
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
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      elevation: 5,
                                    ),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                               DiscussionFormView(id: _dataList[index]['id'], image: _dataList[index]['imageUrl'], comment: _dataList[index]['comment'], title: _dataList[index]['title'], description: _dataList[index]['description'],)
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1877F2),
                                            Color(0xFF4D8AF0)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 98,
                                          minHeight: 35,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Date: ${_dataList[index]['date']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1877F2),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 4),
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
          ),
        ),
      ),
    );
  }
}
