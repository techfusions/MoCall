import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl/intl.dart';
import 'package:saw/Page/HomePage.dart';
import 'package:saw/Page/RegisterPage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable
class VerifyOTP extends StatefulWidget {
  VerifyOTP(
      {super.key,
      required this.auths,
      required this.image,
      required this.name,
      required this.selectDate,
      required this.idnumber,
      required this.age,
      required this.gender,
      required this.purok,
      required this.barangay,
      required this.phonenumber,
      required this.email,
      required this.password,
      required this.city,
      this.province});

  EmailOTP auths = EmailOTP();
  File? image;
  final String name;
  final DateTime? selectDate;
  final String idnumber;
  final String age;
  final String gender;
  final String purok;
  final String barangay;
  final String phonenumber;
  final String email;
  final String password;
  final String city;
  final province;

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  int _secondsRemaining = 50;
  late Timer _timer;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RegisterStepper()),
              (route) => false);
        });
        timer.cancel();
        // Timer completed, perform any action here
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

// submit data in database and upload image in storage area
  Future<void> _signUp() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );
      String imageUrl = await _uploadImage(widget.image!);
      _saveToDatabase(
          imageUrl,
          widget.name,
          widget.selectDate,
          widget.idnumber,
          widget.age,
          widget.gender,
          widget.barangay,
          widget.purok,
          widget.phonenumber,
          widget.city,
          widget.province,
          widget.email,
          widget.password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } catch (e) {
      if (e is FirebaseAuthException) {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          title: 'Error',
          alignment: Alignment.center,
          dialogType: DialogType.error,
          body: Center(
              child: Text(
            "${e.message}",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )),
          autoHide: const Duration(seconds: 5),
          btnCancelOnPress: () {},
        ).show();
      }
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void _saveToDatabase(
      String imageUrl,
      String name,
      DateTime? selectDate,
      String idnumber,
      String age,
      String gender,
      String barangay,
      String purok,
      String phonenumber,
      String city,
      String province,
      String email,
      String password) {
    String dateString = DateFormat('dd/MM/yyyy').format(selectDate!);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('users').child(idnumber);
    databaseReference.set({
      'imageUrl': imageUrl,
      'name': name,
      'datetime': dateString,
      'idnumber': idnumber,
      'age': age,
      'gender': gender,
      'barangay': barangay,
      'purok': purok,
      'phonenumber': phonenumber,
      'city': city,
      'province': province,
      'email': email,
      'password': password
    });
  }
// end submit data in database and upload image in storage area

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 150),
              child: Image.asset(
                'images/assets/verify.png', // Replace with your image path
                height: 200.0,
              ),
            ),
            TextAnimator(
              'Enter the verification code sent to your email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 35.0,
            ),
            OtpTextField(
              numberOfFields: 5,

              borderColor: Color.fromARGB(158, 0, 228, 249),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) async {
                if (await widget.auths.verifyOTP(otp: verificationCode) ==
                    true) {
                  _signUp();
                  /*
                  AwesomeDialog(
                    context: context,
                    body: Text(
                      "REGISTER SUCCESSFULLY",
                    ),
                    alignment: Alignment.center,
                    animType: AnimType.bottomSlide,
                    dialogType: DialogType.success,
                    btnOkOnPress: () {},
                    btnOkColor: Colors.green,
                  ).show(); */
                } else {
                  AwesomeDialog(
                    context: context,
                    alignment: Alignment.center,
                    body: Text("INVALID OTP NUMBER"),
                    animType: AnimType.topSlide,
                    dialogType: DialogType.error,
                    btnCancelOnPress: () {},
                    btnOkColor: Colors.red,
                  ).show();
                }

                /*showDialog(
                context: context,
                builder: (context){
                return AlertDialog(
                    title: Text("Verification Code"),
                    content: Text('Code entered is $verificationCode'),
                );
                }
            ); */
              }, // end onSubmit
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '$_secondsRemaining seconds remaining',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
