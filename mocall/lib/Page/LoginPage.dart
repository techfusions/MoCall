// import package area
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:saw/Page/ForgetPasswordPage.dart';
import 'package:saw/Page/HomePage.dart';
import 'package:saw/Page/RegisterPage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

// end import package area
void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginUpScreen(),
    );
  }
}

class LoginUpScreen extends StatefulWidget {
  @override
  _LoginUpScreenState createState() => _LoginUpScreenState();
}

class _LoginUpScreenState extends State<LoginUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loginloading = false;
  bool loginabsorbPointer = false;
  bool registerloading = false;
  bool registerabsorbPointer = false;
  bool isEmailReadonly = false;
  bool isPasswordReadonly = false;
  bool obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loginloading = true;
        loginabsorbPointer = true;
        registerabsorbPointer = true;
        isEmailReadonly = true;
        isPasswordReadonly = true;
      });

      try {
        // ignore: unused_local_variable
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Login successful
        // print("User signed in: ${userCredential.user!.email}");
        // Navigate to the next screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      }  catch (e) {
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
      } finally {
        setState(() {
          loginloading = false;
          loginabsorbPointer = false;
          registerabsorbPointer = false;
          isEmailReadonly = false;
          isPasswordReadonly = false;
          _emailController.clear();
          _passwordController.clear();
        });
      }
    }
  }

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
                'images/assets/loginupdate.png', // Replace with your image path
                height: 200.0,
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: TextAnimator(
                'Let\'s sign you in...',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextAnimator(
              'You\'re gonna need an account to do this things related.',
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
                  AbsorbPointer(
                    absorbing: isPasswordReadonly,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF1877F2),
                          )),
                      obscureText: obscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Forget()),
                    (route) => false);
              },
              child: Center(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 280.0, // Adjust the width as per your requirement
              child: AbsorbPointer(
                absorbing: loginabsorbPointer,
                child: ElevatedButton(
                  onPressed: () {
                    _login();
                    /*
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loginloading = true;
                        loginabsorbPointer = true;
                        registerabsorbPointer = true;
                        isEmailReadonly = true;
                        isPasswordReadonly = true;
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            loginloading = false;
                            loginabsorbPointer = false;
                            registerabsorbPointer = false;
                            isEmailReadonly = false;
                            isPasswordReadonly = false;
                            _emailController.clear();
                            _passwordController.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                                (route) => false);
                          });
                        });
                      });
                    }
                    */
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF1877F2), // Set the background color to black
                    foregroundColor:
                        Colors.white, // Set the text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Set the button shape to rectangular
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0), // Adjust the vertical padding
                  ),
                  child: loginloading == true
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 28.0)
                      : Text(
                          'Login',
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
                Text("Don't have an account?"),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterStepper()),
                        (route) => false);
                  },
                  child: Text(
                    'SignUp',
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
