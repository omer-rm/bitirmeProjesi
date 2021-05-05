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
                image: AssetImage('images/logos/quicklyIcon.png'),
                height: 150.0,
                width: 150.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0),
              Text(
                'انشئ حساب سائق',
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
                        hintText: 'الاسم الكامل',
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
                        hintText: 'البريد الالكتروني',
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
                        hintText: 'رقم الهاتف',
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
                        hintText: 'كلمة المرور',
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
                        hintText: 'تأكيد كلمة المرور',
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
                    RaisedButton(
                      onPressed: () {
                        if (nameTextEdtingController.text.isEmpty ||
                            emailTextEdtingController.text.isEmpty ||
                            passworedTextEdtingController.text.isEmpty ||
                            phoneNumTextEdtingController.text.isEmpty ||
                            repassworedTextEdtingController.text.isEmpty) {
                          displayToastMsg('لقد تركت فراغ حاول مجددا ', context);
                        } else {
                          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (nameTextEdtingController.text.length < 4) {
                            displayToastMsg('الاسم يجب ان يكون كاملا', context);
                          } else if (!emailTextEdtingController.text
                              .contains("@")) {
                            displayToastMsg(
                                'الرجاء ادخال بريدك الالكتروني بشكل صحيح',
                                context);
                          } else if (passworedTextEdtingController.text !=
                              repassworedTextEdtingController.text) {
                            displayToastMsg(
                                'كلمة المرور خطأ حاول مجددا', context);
                          } else if (!regExp
                              .hasMatch(phoneNumTextEdtingController.text)) {
                            displayToastMsg(
                                'ادخل رقم الهاتف بشكل صحيح', context);
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
                            "سجل الدخول كسائق",
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
                  "لدي حساب",
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
            massage: "الرجاء الانتظار",
          );
        });
    User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEdtingController.text,
                password: passworedTextEdtingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMsg('خطأ:' + errMsg, context);
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
          msg: "لقد تم انشاء حسابك", textColor: Colors.green);

      Navigator.pushNamed(context, CarInfoScreen.idScreen);
    } else {
      Navigator.pop(context);
      displayToastMsg('يوجد خطأ ما لم يتم انشاء الحساب', context);
    }
  }

  void displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.red);
  }
}
