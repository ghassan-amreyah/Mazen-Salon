import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String emailLogin, password;
  GlobalKey<FormState> formStateLogin = GlobalKey<FormState>();

  //-----Login method--------------------------------------------
  login() async {
    var formData = formStateLogin.currentState;
    if (formData!.validate()) {
      formData.save();
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailLogin, password: password);
        Navigator.of(context).pop();
        return userCredential;
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == "invalid-email") {
          AwesomeDialog(
            dialogType: DialogType.error,
            context: context,
            title: "الإيميل غير صحيح",
            btnOkOnPress: () {},
            dismissOnTouchOutside:
                false, // Set to false to prevent closing on touch outside
            dismissOnBackKeyPress: false,
          ).show();
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          print(e.code);
          AwesomeDialog(
            dialogType: DialogType.error,
            context: context,
            title: "كلمة السر أو الإيميل غير صحيح",
            btnOkOnPress: () {},
            dismissOnTouchOutside:
                false, // Set to false to prevent closing on touch outside
            dismissOnBackKeyPress: false,
          ).show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.only(top: 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 20),
              child: Image.asset(
                "images/logoBlack.png",
                height: 150,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(20),
            child: Form(
              key: formStateLogin,
              child: Column(
                children: [
                  TextFormField(
                    textDirection: TextDirection.rtl,
                    onSaved: (newValue) {
                      emailLogin = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "الإيميل مطلوب";
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      filled: true,
                      suffixIcon: Icon(Icons.person),
                      suffixIconColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                      ),
                      hintText: "الإيميل",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textDirection: TextDirection.rtl,
                    onSaved: (newValue) {
                      password = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "كلمة السر مطلوبة";
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      suffixIcon: Icon(Icons.lock),
                      suffixIconColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                      ),
                      hintText: "كلمة السر",
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.black,
                      padding: EdgeInsets.all(13),
                      onPressed: () async {
                        final connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                          AwesomeDialog(
                            dialogType: DialogType.warning,

                            context: context,
                            title: "! لا يتوفر اتصال بالانترنت",
                            btnOkOnPress: () {},
                            btnOkColor: Colors.black,
                            dismissOnTouchOutside:
                                false, // Set to false to prevent closing on touch outside
                            dismissOnBackKeyPress: false,
                          ).show();
                        } else {
                          var user = await login();
                          if (user != null) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.of(context)
                                .pushReplacementNamed("admin page");
                          }
                        }
                      },
                      child: Text("تسجيل الدخول",
                          style: GoogleFonts.elMessiri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
