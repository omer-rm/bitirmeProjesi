import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allScreen/LginScreen.dart';
import '../allScreen/carInfoScreen.dart';
import '../allwidgets/CustomColors.dart';
import '../allwidgets/progressDilog.dart';
import '../configMaps.dart';
import '../main.dart';

class SignUpScreen extends StatelessWidget {
  static const String idScreen = 'registerScreen';

  TextEditingController nameTextEdtingController = TextEditingController();
  TextEditingController emailTextEdtingController = TextEditingController();
  TextEditingController phoneNumTextEdtingController = TextEditingController();
  TextEditingController passworedTextEdtingController = TextEditingController();
  TextEditingController repassworedTextEdtingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CostumColors.petroly_color,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 120.0,
              ),
              Image(
                image: AssetImage('images/logo1.png'),
                height: 150.0,
                width: 150.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0),
              Text(
                'Create a driver account',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.0),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      controller: nameTextEdtingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'full name',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: emailTextEdtingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'E-mail',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: phoneNumTextEdtingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Phone number',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: passworedTextEdtingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'password',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: repassworedTextEdtingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'confirm password',
                        hintStyle: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: () {
                        if (nameTextEdtingController.text.isEmpty ||
                            emailTextEdtingController.text.isEmpty ||
                            passworedTextEdtingController.text.isEmpty ||
                            phoneNumTextEdtingController.text.isEmpty ||
                            repassworedTextEdtingController.text.isEmpty) {
                          displayToastMsg(
                              'You left a blank, try again', context);
                        } else {
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (nameTextEdtingController.text.length < 4) {
                            displayToastMsg('Please enter full name', context);
                          } else if (!emailTextEdtingController.text
                              .contains("@")) {
                            displayToastMsg(
                                'Please enter your email correctly', context);
                          } else if (passworedTextEdtingController.text !=
                              repassworedTextEdtingController.text) {
                            displayToastMsg(
                                'Password wrong, try again', context);
                          } else if (!regExp
                              .hasMatch(phoneNumTextEdtingController.text)) {
                            displayToastMsg(
                                'Enter the correct phone number', context);
                          } else {
                            signUpNewUser(context);
                          }
                        }
                      },
                      color: CostumColors.asfar_color,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Sign in as a driver",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: CostumColors.petroly_color),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0)),
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Text(
                  "I have an account",
                  style: TextStyle(color: Colors.white60),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signUpNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return ProgressDialog(
            massage: "please wait...",
          );
        });
    User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEdtingController.text,
                password: passworedTextEdtingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMsg('Something went wrong:' + errMsg, context);
    }))
        .user;
    if (user != null) {
      // save the user
      Map userDataMap = {
        "name": nameTextEdtingController.text.trim(),
        "email": emailTextEdtingController.text.trim(),
        "phone": phoneNumTextEdtingController.text.trim(),
      };
      dirversRef.child(user.uid).set(userDataMap);
      currentfirebaseuser = user;
      Fluttertoast.showToast(
          msg: "Your account has been created", textColor: Colors.green);

      Navigator.pushNamed(context, CarInfoScreen.idScreen);
    } else {
      Navigator.pop(context);
      displayToastMsg(
          'There was an error. The account was not created', context);
    }
  }

  void displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.red);
  }
}
