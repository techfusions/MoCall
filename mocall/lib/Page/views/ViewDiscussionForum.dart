import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_container_flutter/loading_container_flutter.dart';
import 'package:intl/intl.dart';

class DiscussionFormView extends StatelessWidget {
  const DiscussionFormView({
    super.key,
    required this.id,
    required this.image,
    required this.comment,
    required this.title,
    required this.description,
  });
  final String id;
  final String image;
  final String title;
  final String description;
  final bool comment;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'About View with Comments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DiscussionFormViewPage(
        id: id,
        image: image,
        comment: comment,
        title: title,
        description: description,
      ),
    );
  }
}

class DiscussionFormViewPage extends StatefulWidget {
  const DiscussionFormViewPage({
    super.key,
    required this.id,
    required this.image,
    required this.comment,
    required this.title,
    required this.description,
  });
  final String id;
  final String image;
  final bool comment;
  final String title;
  final String description;
  @override
  _DiscussionFormViewPageState createState() => _DiscussionFormViewPageState();
}

class _DiscussionFormViewPageState extends State<DiscussionFormViewPage> {
  bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: loading == true
                    ? Center(
                        child: Column(
                          children: [
                            LoadingContainerWidget(
                              width: 1800,
                              height: 400,
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
                    : Image.network(
                        '${widget.image}',
                        width: 1800,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '${widget.title}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '${widget.description}',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 20.0),
            Divider(height: 1.0, color: Colors.grey),
            SizedBox(height: 20.0),
            Text(
              'Comments',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            CommentSection(
                id: widget.id, comment: widget.comment, image: widget.image),
          ],
        ),
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection({
    super.key,
    required this.id,
    required this.image,
    required this.comment,
  });
  final String id;
  final String image;
  final bool comment;
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool? commenter;
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('comments');
  final DatabaseReference _databaseName =
      FirebaseDatabase.instance.ref().child('users');
  final _commentReference = FirebaseDatabase.instance.ref().child('comments');
  List<Map<dynamic, dynamic>> comments = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController commentController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String? image;
  String? userid;
  String datestring = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String timeString = DateFormat('hh:mm:ss a').format(DateTime.now());

  void addComment(String comment) {
    setState(() {
      Random random = Random();
      int rand = random.nextInt(9000) + 1000;
      final DatabaseReference _databaseReference = FirebaseDatabase.instance
          .ref()
          .child('comments')
          .child('${rand.toString()}');
      _databaseReference.set({
        'commentid': rand.toString(),
        'date': datestring,
        'time': timeString,
        'id': '${widget.id}',
        'userid': userid,
        'name': _nameController.text,
        'comment': comment,
        'imageUrl': image,
      }).then((value) {
        _refreshIndicatorKey.currentState!.show();
        commentController.clear();
      }); // Clear the text field after adding comment
    });
  }

  void initState() {
    _fetchComment();
    _getUserInfo();
    setState(() {
      commenter = widget.comment;
    });
    super.initState();
  }

  Future<void> _fetchComment() async {
    setState(() {});
    try {
      DatabaseEvent event =
          await _databaseRef.orderByChild("id").equalTo('${widget.id}').once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        comments.add(value);
      });
      setState(() {});
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> _getUserInfo() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseName
          .orderByChild("email")
          .equalTo('${FirebaseAuth.instance.currentUser!.email}')
          .once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        _nameController.text = value['name'];
        image = value['imageUrl'];
        userid = value['idnumber'];
        print(_nameController.text);
      });
      setState(() {});
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: Colors.blueAccent,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        try {
          DatabaseEvent event = await _commentReference
              .orderByChild("id")
              .equalTo('${widget.id}')
              .once();
          DataSnapshot snapshot = event.snapshot;
          if (snapshot.value != null) {
            Map<dynamic, dynamic> data =
                snapshot.value as Map<dynamic, dynamic>;
            List<Map<dynamic, dynamic>> tempList = [];
            data.forEach((key, value) {
              tempList.add({'key': key, ...value});
            });
            setState(() {
              comments = tempList;
            });
          }
        } catch (e) {
          print(e);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: commentController,
                  enabled: commenter != false ? true : false,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: commenter != false
                    ? () {
                        if (commentController.text.isNotEmpty) {
                          addComment(commentController.text);
                        }
                      }
                    : null,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Divider(height: 1.0, color: Colors.grey),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              return commenter != false
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text("${comments[index]['name']}"),
                        subtitle: Text("${comments[index]['comment']}"),
                        trailing: Text(
                            "${comments[index]['time']} ${comments[index]['date']}"),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage("${comments[index]['imageUrl']}"),
                        ),
                      ),
                    )
                  : null;
            },
          ),
          commenter != false
              ? Text("")
              : Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "THE COMMENTS ARE DISABLED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
