import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saw/Page/HomePage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()),
                    (route) => false);
              },
              icon: Icon(FontAwesomeIcons.arrowLeft)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ProfileCard(),
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  File? _image;
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // Upload to Firebase Storage
        imgUrl = await _uploadImage(_image!);
        updateUser("Camera", imgUrl!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  _imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // Upload to Firebase Storage
        imgUrl = await _uploadImage(_image!);
        updateUser("Gallery", imgUrl!);
      } else {
        print('No image selected.');
      }
    });
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _barangayController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _purokController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();

  String? imageUrl;
  String? idnumber;
  String? name;
  String? age;
  String? purok;
  String? phonenumber;
  String? barangay;
  String? city;
  String? province;
  String? email;
  String? imgUrl;
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('users');
  bool loading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    _fetchProfile();
    super.initState();
  }

  Future<void> _fetchProfile() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseRef
          .orderByChild("email")
          .equalTo(FirebaseAuth.instance.currentUser!.email)
          .once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        setState(() {
          imageUrl = value['imageUrl'];
          idnumber = value['idnumber'];
          name = value['name'];
          age = value['age'];
          purok = value['purok'];
          phonenumber = value['phonenumber'];
          barangay = value['barangay'];
          city = value['city'];
          province = value['province'];
          email = value['email'];
        });
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> updateUser(String title, String updateData) async {
    var data = title;
    switch (data) {
      case 'Name':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"name": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Age':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"age": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Purok':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"purok": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Phone':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"phonenumber": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Barangay':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"barangay": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'City':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"city": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Province':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"province": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Gallery':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"imageUrl": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      case 'Camera':
        setState(() {
          final DatabaseReference _databaseUpdate = FirebaseDatabase.instance
              .ref()
              .child('users')
              .child('${idnumber}');
          _databaseUpdate.update({"imageUrl": updateData}).then((value) {
            _refreshIndicatorKey.currentState!.show();
          });
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: Colors.blueAccent,
      onRefresh: () async {
        Future.delayed(Duration(seconds: 5));
        await _fetchProfile();
        AwesomeDialog(
          context: context,
          body: Text(
            "UPDATE SUCCESSFULLY",
          ),
          alignment: Alignment.center,
          animType: AnimType.bottomSlide,
          dialogType: DialogType.success,
          btnOkOnPress: () {},
          btnOkColor: Colors.green,
        ).show();
      },
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset(
              'images/assets/personalupdate.png', // Replace with your image path
              height: 200.0,
            ),
          ),
          SizedBox(height: 16.0),
          TextAnimator(
            'You\'re gonna edit or view your information details and password',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image == null
                    ? GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage("${imageUrl}"),
                          ),
                        ),
                      )
                    : Center(
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(_image!),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showPicker(context);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 20),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'ID NUMBER',
                  value: '${idnumber}',
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'Name',
                  value: '${name}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your fullname?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _nameController..text = '${name}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.user),
                                  labelText: 'Fullname',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          updateUser(
                                              'Name', _nameController.text);
                                        });
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'Age',
                  value: '${age}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your age?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _ageController..text = '${age}',
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.user),
                                  labelText: 'Age',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateUser("Age", _ageController.text);
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'Purok',
                  value: '${purok}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your purok?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _purokController..text = '${purok}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.city),
                                  labelText: 'Purok',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateUser(
                                            "Purok", _purokController.text);
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'PhoneNumber',
                  value: '${phonenumber}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your phonenumber?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _phoneController
                                ..text = '${phonenumber}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.phone),
                                  labelText: 'Phonenumber',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateUser(
                                            "Phone", _phoneController.text);
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'Barangay',
                  value: '${barangay}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your city?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _barangayController
                                ..text = '${barangay}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.city),
                                  labelText: 'Barangay',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateUser("Barangay",
                                            _barangayController.text);
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'City',
                  value: '${city}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your city?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _cityController..text = '${city}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.city),
                                  labelText: 'City',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateUser(
                                            "City", _cityController.text);
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'Province',
                  value: '${province}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your Province?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _provinceController
                                ..text = '${province}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.city),
                                  labelText: 'Province',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        updateUser("Province",
                                            _provinceController.text);
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                ProfileDetail(
                  title: 'Email',
                  value: '${email}',
                  onEdit: () {
                    AwesomeDialog(
                        context: context,
                        title: 'UPDATE CREDENTIALS',
                        body: Column(
                          children: [
                            Image.asset(
                              'images/assets/forgetupdate.png', // Your image path
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                'Would you like to change your password?',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _emailController..text = '${email}',
                              decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.envelope),
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(()  {
                                         FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: _emailController.text)
                                              .then((value) {
                                            Navigator.pop(context);
                                            AwesomeDialog(
                                              context: context,
                                              body: Text(
                                                "PLEASE CHECK YOUR EMAIL!",
                                              ),
                                              alignment: Alignment.center,
                                              animType: AnimType.bottomSlide,
                                              dialogType: DialogType.info,
                                              btnOkOnPress: () {},
                                              btnOkColor: Colors.blueAccent,
                                            ).show();
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.send))),
                            ),
                            SizedBox(height: 25.0),
                          ],
                        )).show();
                  },
                ),
                SizedBox(height: 20),
                // Add more ProfileDetailCard widgets for additional details
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetail extends StatefulWidget {
  final String title;
  final String value;
  final VoidCallback? onEdit;

  const ProfileDetail({
    required this.title,
    required this.value,
    this.onEdit,
  });
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(103, 158, 158, 158),
            spreadRadius: 0,
            blurRadius: 3,
            //offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            if (widget.onEdit != null)
              IconButton(
                onPressed: widget.onEdit,
                icon: Icon(Icons.edit),
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}
