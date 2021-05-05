import '../AllWidgets/progressDialog.dart';
import '../Screens/homescreen.dart';
import '../main.dart';
import '../myColors/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEdtingController = TextEditingController();
  TextEditingController surnameTextEdtingController = TextEditingController();
  TextEditingController emailTextEdtingController = TextEditingController();
  TextEditingController phoneNumTextEdtingController = TextEditingController();
  TextEditingController passworedTextEdtingController = TextEditingController();
  TextEditingController repassworedTextEdtingController =
      TextEditingController();
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
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 1),
                Text(
                  "Sing UP",
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
                        controller: nameTextEdtingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          hintText: "NAME",
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
                        controller: surnameTextEdtingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          hintText: "surname",
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
                        controller: phoneNumTextEdtingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          hintText: "phone",
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
                      TextField(
                        controller: repassworedTextEdtingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          hintText: "confirme pasword",
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
                      SizedBox(height: 10),
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
                          if (nameTextEdtingController.text.isEmpty ||
                              surnameTextEdtingController.text.isEmpty ||
                              emailTextEdtingController.text.isEmpty ||
                              phoneNumTextEdtingController.text.isEmpty ||
                              passworedTextEdtingController.text.isEmpty ||
                              repassworedTextEdtingController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please fill in all the blanks");
                          } else {
                            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = new RegExp(pattern);
                            if (nameTextEdtingController.text.length < 3) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter a valid name");
                            } else if (surnameTextEdtingController.text.length <
                                3) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid surname");
                            } else if (!emailTextEdtingController.text
                                .contains("@")) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter a valid Email");
                            } else if (!regExp
                                .hasMatch(phoneNumTextEdtingController.text)) {
                              Fluttertoast.showToast(
                                  msg: "recheck your phone number");
                            } else if (passworedTextEdtingController
                                    .text.length <
                                8) {
                              Fluttertoast.showToast(
                                  msg:
                                      "the password need to be more than 8 charcters");
                            } else if (passworedTextEdtingController.text !=
                                repassworedTextEdtingController.text) {
                              Fluttertoast.showToast(
                                  msg:
                                      "the confirme password do not match the password");
                            } else {
                              signUp(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "I have an Account.",
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

  void signUp(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Registering , Please Wait...");
        });

    User user = (await _auth
            .createUserWithEmailAndPassword(
                email: emailTextEdtingController.text,
                password: passworedTextEdtingController.text)
            .catchError((err) {
      Navigator.pop(context);

      print(err);
    }))
        .user;

    if (user != null) {
      //user created save uesr info to databace
      Map userDataMap = {
        "name": nameTextEdtingController.text.trim(),
        "surrname": surnameTextEdtingController.text.trim(),
        "email": emailTextEdtingController.text.trim(),
        "phone": phoneNumTextEdtingController.text.trim(),
      };

      userRef.child(user.uid).set(userDataMap);
      Fluttertoast.showToast(
          msg: "your account has been created successfully",
          textColor: Colors.green);
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.screenId, (route) => false);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "somthing went wrong please try again", textColor: Colors.red);
      print("somthing went wrong please check your code");
    }
  }
}
