// import package area
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:saw/Page/LoginPage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

// end import package area
void main() {
  runApp(Forget());
}

class Forget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ForgetPasswordScreen(),
    );
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool resetloading = false;
  bool resetabsorbPointer = false;
  bool isEmailReadonly = false;
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'images/assets/forgetupdate.png', // Replace with your image path
                height: 200.0,
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: TextAnimator(
                'Let\'s reset your password...',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextAnimator(
              'You\'re gonna enter your email to reset your password.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AbsorbPointer(
                    absorbing: isEmailReadonly,
                    child: TextFormField(
                      controller: _emailController,
                      readOnly: isEmailReadonly,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF1877F2),
                        ),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (EmailValidator.validate(value) == false) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 280.0, // Adjust the width as per your requirement
              child: AbsorbPointer(
                absorbing: resetabsorbPointer,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        resetloading = true;
                        resetabsorbPointer = true;
                        isEmailReadonly = true;
                        Future.delayed(const Duration(seconds: 5), ()  {
                          setState(()  {
                            resetloading = false;
                            resetabsorbPointer = false;
                            isEmailReadonly = false;
                            FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                            _emailController.clear();
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>Login()), (route) => false);
                          });
                        });
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1877F2), // Set the background color to black
                    foregroundColor:
                        Colors.white, // Set the text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Set the button shape to rectangular
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0), // Adjust the vertical padding
                  ),
                  child: resetloading == true
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 28.0)
                      : Text(
                          'SEND',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("I don't reset my password?"),
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
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
