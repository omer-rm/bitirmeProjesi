import '../AllWidgets/progressDialog.dart';
import '../Screens/homescreen.dart';
import '../Screens/SignupScreen.dart';
import '../main.dart';
import '../myColors/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static const String screenid = "LoginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEdtingController = TextEditingController();
  TextEditingController passworedTextEdtingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.petroly_color,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 34),
                Text(
                  "Welcome to Uber ",
                  style: TextStyle(
                    color: MyColors.asfar_color,
                    fontSize: 30,
                    fontFamily: "BreeSerif",
                  ),
                  textAlign: TextAlign.center,
                ),
                Image(
                  image: AssetImage("images/9.png"),
                  width: 390,
                  height: 340,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 1),
                Text(
                  "Login ",
                  style: TextStyle(
                    color: MyColors.asfar_color,
                    fontSize: 24,
                    fontFamily: "BreeSerif",
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 1),
                      TextField(
                        controller: emailTextEdtingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "BreeSerif",
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(height: 1),
                      TextField(
                        controller: passworedTextEdtingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          hintText: "PassWord",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "BreeSerif",
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(height: 1),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: MyColors.asfar_color,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "BreeSerif",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24)),
                        onPressed: () {
                          if (!emailTextEdtingController.text.contains("@")) {
                            Fluttertoast.showToast(
                                msg: "Please Enter a valid Email");
                          } else if (passworedTextEdtingController
                              .text.isEmpty) {
                            Fluttertoast.showToast(msg: "wrong password.");
                          } else {
                            login(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                  },
                  child: Text(
                    "Do not have an Account? Register Here.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void login(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "loging, Please Wait...");
        });

    User user = (await _auth
            .signInWithEmailAndPassword(
                email: emailTextEdtingController.text,
                password: passworedTextEdtingController.text)
            .catchError((err) {
      Navigator.pop(context);
      print(err);
    }))
        .user;
    if (user != null) {
      userRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.screenId, (route) => false);
          Fluttertoast.showToast(
              msg: "loged in successfully", textColor: Colors.green);
        } else {
          Navigator.pop(context);
          _auth.signOut();
          Fluttertoast.showToast(
              msg:
                  "somthing went wrong please try again or sign in if you dont have an account",
              textColor: Colors.red);
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "can not be signed in.", textColor: Colors.red);
    }
  }
}
