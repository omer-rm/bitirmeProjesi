import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../allScreen/mainScreen.dart';
import '../allScreen/signupScreen.dart';
import '../allwidgets/CustomColors.dart';
import '../allwidgets/progressDilog.dart';
import '../configMaps.dart';
import '../main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'loginScreen';

  TextEditingController emailTextEdtingController = TextEditingController();
  TextEditingController passworedTextEdtingController = TextEditingController();
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
                image: AssetImage('images/logos/quicklyIcon.png'),
                height: 150.0,
                width: 150.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0),
              Text(
                'حساب السائق',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 35.0),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      textAlign: TextAlign.center,
                      controller: emailTextEdtingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'البريد الالكتروني',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white60),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 1.0),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: passworedTextEdtingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'كلمة المرور',
                        hintStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white60,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 90.0),
                    RaisedButton(
                      onPressed: () {
                        if (emailTextEdtingController.text.isEmpty ||
                            passworedTextEdtingController.text.isEmpty) {
                          displayToastMsg('لقد تركت فراغ حاول مجددا ', context);
                        } else {
                          if (!emailTextEdtingController.text.contains("@")) {
                            displayToastMsg(
                                'الرجاء ادخال بريدك الالكتروني بشكل صحيح',
                                context);
                          } else {
                            loginUser(context);
                          }
                        }
                      },
                      color: CostumColors.asfar_color,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "تسجيل الدخول",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: CostumColors.petroly_color,
                            ),
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
                  "لا يوجد لديك حساب ؟ سجل الان",
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignUpScreen.idScreen, (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return ProgressDialog(
            massage: "الرجاء الانتظار",
          );
        });
    final User user = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEdtingController.text,
                password: passworedTextEdtingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMsg('خطأ:' + errMsg, context);
    }))
        .user;
    if (user != null) {
      dirversRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          currentfirebaseuser = user;
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMsg('لم يتم العثور على حسابك', context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMsg('لا يمكنك الدخول الان', context);
    }
  }

  void displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.red);
  }
}
