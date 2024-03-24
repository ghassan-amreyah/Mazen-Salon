import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        const Background(),
        Container(
          width: width,
          height: height,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Center(
                      child: Image.asset(
                    "images/logoWhite.png",
                    height: 150,
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 400),
                  child: Center(
                    child: Text(
                      "أهلًا بك في صالون مازن للرجال",
                      style: GoogleFonts.elMessiri(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 40, right: 25, bottom: 20, left: 25),
                  child: Center(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
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
                            dismissOnTouchOutside: false,
                            // Set to false to prevent closing on touch outside
                            dismissOnBackKeyPress: false,
                          ).show();
                        } else {
                          Navigator.pushNamed(context, "chose book page");
                        }
                      },
                      child: Text(
                        "احجز الآن",
                        style: GoogleFonts.elMessiri(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        AwesomeDialog(
                          dialogType: DialogType.warning,
                          context: context,
                          title: "! لا يتوفر اتصال بالانترنت",
                          btnOkOnPress: () {},
                          btnOkColor: Colors.black,
                          dismissOnTouchOutside: false,
                          // Set to false to prevent closing on touch outside
                          dismissOnBackKeyPress: false,
                        ).show();
                      } else {
                        Navigator.of(context).pushNamed("login page");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                            color: Colors.white60,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
