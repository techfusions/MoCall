import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saw/Page/LoginPage.dart';
import 'package:saw/Page/verifyOTP.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:email_otp/email_otp.dart';
import 'package:phone_input/phone_input_package.dart';

void main() {
  runApp(RegisterStepper());
}

class RegisterStepper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

const List<String> barangay = [
  'Barangay',
  'Canubay',
  'Lower Loboc',
  'Mobod'
];
const List<String> gender = ['Gender', 'Male', 'Female', 'Other specify'];

class _RegisterFormState extends State<RegisterForm> {
  int _currentStep = 0;
  String _selectedGender = gender.first;
  String _selectedBarangay = barangay.first;

  DateTime? _selectedDate;
  File? _image;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _idnumberController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _purokController = TextEditingController();
  TextEditingController _phoneControll = TextEditingController();
  PhoneController? _phoneController;
  String? phone;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();

  @override
  void initState() {
    Random random = Random();
    int rand = random.nextInt(9000) + 1000;
    _idnumberController.text = rand.toString();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _sendOTP(email) async {
    EmailOTP auth = EmailOTP();

    auth.setConfig(
      appEmail: "me@rohitchouhan.com",
      userEmail: email,
      otpLength: 5,
      appName: "EMAIL OTP",
      otpType: OTPType.digitsOnly,
    );
    if (await auth.sendOTP() == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => VerifyOTP(
                    auths: auth,
                    image: _image,
                    name: _nameController.text,
                    selectDate: _selectedDate,
                    idnumber: _idnumberController.text,
                    age: _ageController.text,
                    gender: _selectedGender.toString(),
                    purok: _purokController.text,
                    barangay: _selectedBarangay.toString(),
                    phonenumber: phone.toString(),
                    city: _cityController.text,
                    province: _provinceController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  )),
          (route) => false);
    }
  }

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

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Image.asset(
            'images/assets/signupupdate.png', // Replace with your image path
            height: 200.0,
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: TextAnimator(
            'Let\'s create an account...',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextAnimator(
          'You\'re gonna enter your information details and password for registration.',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.0),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null
                  ? GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : Stack(
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
                                _image = null;
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
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                  Color(0xFF1877F2),
                )),
                onPressed: () {
                  _showPicker(context);
                },
                icon: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                label: Text(
                  'Choose Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Stepper(
          connectorColor: MaterialStatePropertyAll(
            Color(0xFF1877F2),
          ),
          type: StepperType.vertical,
          currentStep: _currentStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: const Text('SUBMIT'),
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
                          vertical: 1.0,
                          horizontal: 20.0), // Adjust the vertical padding
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('CANCEL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(
                          136, 9, 9, 1), // Set the background color to black
                      foregroundColor:
                          Colors.white, // Set the text color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15), // Set the button shape to rectangular
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0,
                          horizontal: 20.0), // Adjust the vertical padding
                    ),
                  ),
                ],
              ),
            );
          },
          onStepContinue: () {
            setState(() {
              if (_nameController.text.isEmpty) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  title: 'Error',
                  alignment: Alignment.center,
                  dialogType: DialogType.error,
                  body: Center(
                      child: Text(
                    "PLEASE ENTER YOUR FULLNAME",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                  autoHide: const Duration(seconds: 5),
                  btnCancelOnPress: () {},
                ).show();
              } else if (_selectedDate == null) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  title: 'Error',
                  alignment: Alignment.center,
                  dialogType: DialogType.error,
                  body: Center(
                      child: Text(
                    "PLEASE SELECT YOUR BIRTHDAY",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                  autoHide: const Duration(seconds: 5),
                  btnCancelOnPress: () {},
                ).show();
              } else if (_ageController.text.isEmpty) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  title: 'Error',
                  alignment: Alignment.center,
                  dialogType: DialogType.error,
                  body: Center(
                      child: Text(
                    "PLEASE ENTER YOUR AGE",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                  autoHide: const Duration(seconds: 5),
                  btnCancelOnPress: () {},
                ).show();
              } else if (_selectedGender == "Gender") {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  title: 'Error',
                  alignment: Alignment.center,
                  dialogType: DialogType.error,
                  body: Center(
                      child: Text(
                    "PLEASE SELECT YOUR GENDER",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                  autoHide: const Duration(seconds: 5),
                  btnCancelOnPress: () {},
                ).show();
              } else if (_phoneControll.text.isEmpty) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.scale,
                  title: 'Error',
                  alignment: Alignment.center,
                  dialogType: DialogType.error,
                  body: Center(
                      child: Text(
                    "PLEASE ENTER YOUR PHONENUMBER",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                  autoHide: const Duration(seconds: 5),
                  btnCancelOnPress: () {},
                ).show();
              } else {
                _currentStep += 1;
              }
              if (_currentStep >= 2) {
                if (_selectedBarangay == "Barangay") {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    title: 'Error',
                    alignment: Alignment.center,
                    dialogType: DialogType.error,
                    body: Center(
                        child: Text(
                      "PLEASE SELECT YOUR BARANGAY",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
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
                      "PLEASE ENTER YOUR PUROK",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                    autoHide: const Duration(seconds: 5),
                    btnCancelOnPress: () {},
                  ).show();
                }
              } else {}
              if (_currentStep >= 3) {
                if (_emailController.text.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    title: 'Error',
                    alignment: Alignment.center,
                    dialogType: DialogType.error,
                    body: Center(
                        child: Text(
                      "PLEASE ENTER YOUR EMAIL",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                    autoHide: const Duration(seconds: 5),
                    btnCancelOnPress: () {},
                  ).show();
                } else if (_passwordController.text.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    title: 'Error',
                    alignment: Alignment.center,
                    dialogType: DialogType.error,
                    body: Center(
                        child: Text(
                      "PLEASE ENTER YOUR PASSWORD",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                    autoHide: const Duration(seconds: 5),
                    btnCancelOnPress: () {},
                  ).show();
                } else if (_confirmPasswordController.text.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    title: 'Error',
                    alignment: Alignment.center,
                    dialogType: DialogType.error,
                    body: Center(
                        child: Text(
                      "PLEASE CONFIRM YOUR PASSWORD",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                    autoHide: const Duration(seconds: 5),
                    btnCancelOnPress: () {},
                  ).show();
                } else if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    title: 'Error',
                    alignment: Alignment.center,
                    dialogType: DialogType.error,
                    body: Center(
                        child: Text(
                      "YOUR PASSWORD IS NOT MATCH",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                    autoHide: const Duration(seconds: 5),
                    btnCancelOnPress: () {},
                  ).show();
                } else if (_image == null) {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.scale,
                    title: 'Error',
                    alignment: Alignment.center,
                    dialogType: DialogType.error,
                    body: Center(
                        child: Text(
                      "NO IMAGE SELECTED",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                    autoHide: const Duration(seconds: 5),
                    btnCancelOnPress: () {},
                  ).show();
                } else {
                  _sendOTP(_emailController.text);
                  print(_phoneControll.text);
                }
                _currentStep -= 1;
              }

              /* else if (_currentStep < 2) {
                _currentStep++;
              }*/
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--;
              }
            });
          },
          steps: [
            Step(
              title: Text('INFORMATION'),
              state: StepState.editing,
              content: Column(
                children: [
                  SizedBox(height: 5.0),
                  AbsorbPointer(
                    absorbing: true,
                    child: TextField(
                      controller: _idnumberController..value,
                      decoration: InputDecoration(
                        labelText: 'ID NUMBER',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Fullname',
                      hintText: 'Enter your Fullname',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Birthday',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}'
                              : '',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      hintText: 'Enter your Age',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    value: _selectedGender,
                    hint: Text('Gender'),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    items: gender
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 10.0),
                  PhoneInput(
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    defaultCountry: IsoCode.PH,
                    initialValue: PhoneNumber(
                        isoCode: IsoCode.PH, nsn: '${_phoneControll.text}'),
                    countrySelectorNavigator:
                        CountrySelectorNavigator.searchDelegate(),
                    validator: PhoneValidator.validMobile(),
                    decoration: InputDecoration(
                      labelText: 'Phonenumber',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onSubmitted: (value) {
                      phone = value;
                    },
                    onChanged: (PhoneNumber? p) {
                      setState(() {
                        if (p!.isValidLength() == false) {
                          print("empty");
                        }
                        _phoneControll.text = p.toString();
                      });
                    },
                  ),
                  /*TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration: InputDecoration(
                      labelText: 'Phonenumber',
                      hintText: 'Enter your Phonenumber',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ), */
                ],
              ),
              isActive: _currentStep == 0,
            ),
            Step(
              title: Text('ADDRESS'),
              state: StepState.editing,
              content: Column(
                children: [
                  SizedBox(height: 10),
                  DropdownButtonFormField(
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
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _purokController,
                    decoration: InputDecoration(
                      labelText: 'Purok',
                      hintText: 'Enter your Purok',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  AbsorbPointer(
                    absorbing: true,
                    child: TextField(
                      controller: _cityController..text = 'Oroquieta city',
                      decoration: InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  AbsorbPointer(
                    absorbing: true,
                    child: TextField(
                      controller: _provinceController
                        ..text = 'Misamis Occidental',
                      decoration: InputDecoration(
                        labelText: 'Province',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep == 1,
            ),
            Step(
              title: Text('ACCOUNT'),
              state: StepState.editing,
              content: Column(
                children: [
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              isActive: _currentStep == 2,
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("I have an account"),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                    (route) => false);
              },
              child: Text(
                'login',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
