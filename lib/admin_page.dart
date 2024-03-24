import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List reservationsData = [];
  CollectionReference reservationsRefs =
      FirebaseFirestore.instance.collection("reservations");
  CollectionReference timesRefs =
      FirebaseFirestore.instance.collection("times");
  DateTime checkMonday = DateTime.now();
  late bool isClose = false;

  //---------Send the notifications-----------------------
  // var serverToken = "";
  // sendNotifications(String title, String body, String id) async {
  //   await http.post(
  //     Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'key=$serverToken',
  //     },
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'body': body.toString(),
  //           'title': title.toString()
  //         },
  //         'priority': 'high',
  //         'data': <String, dynamic>{
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //           'id': id.toString()
  //         },
  //         'to': await FirebaseMessaging.instance.getToken()
  //       },
  //     ),
  //   );
  // }

//-----Update done status method-------------------------
  updateDoneStatus() async {
    try {
      final QuerySnapshot querySnapshot =
          await reservationsRefs.where("done", isEqualTo: false).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot document = querySnapshot.docs.first;

        // Update the 'done' field to true (as a boolean)
        await document.reference.update({'done': true});

        // Update the local data to reflect the change
        setState(() {
          final index =
              reservationsData.indexWhere((data) => data['done'] == false);
          if (index != -1) {
            reservationsData[index]['done'] = true;
          }
        });
      } else {
        print("Document not found");
      }
    } catch (error) {
      print("Error updating status: $error");
    }
  }

  updateStatusAfterFinish(String reserveTime, int index) async {
    try {
      // Find the document in times collection where reserve_time matches
      QuerySnapshot querySnapshot =
          await timesRefs.where("clock", isEqualTo: reserveTime).get();

      // Check if any documents are found
      if (querySnapshot.docs.isNotEmpty) {
        // Update the status in the first document found
        var documentID = querySnapshot.docs.first.id;
        await timesRefs.doc(documentID).update({
          'status': true,
        });

        // Remove the corresponding data from the reservationsData list
        setState(() {
          reservationsData.removeAt(index);
        });
      } else {
        // Handle case where no matching document is found
        print("No document found for reserve_time: $reserveTime");
        // You might want to show a message to the user or handle it in some way
      }
    } catch (error) {
      // Handle any errors that occur during the update
      print("Error updating status after finish: $error");
      // You might want to show a message to the user or handle it in some way
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    DateTime checkMondayInCustomers = DateTime.now();
    late String dayName;

    switch (checkMondayInCustomers.weekday) {
      case 1:
        dayName = "الإثنين";
        break;
      case 2:
        dayName = "الثلاثاء";
        break;
      case 3:
        dayName = "الأربعاء";
        break;
      case 4:
        dayName = "الخميس";
        break;
      case 5:
        dayName = "الجمعة";
        break;
      case 6:
        dayName = "السبت";
        break;
      case 7:
        dayName = "الأحد";
        break;

      default:
        dayName = "Unknown Day";
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Mazen Salon",
            style: GoogleFonts.elMessiri(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image(
                      image: AssetImage("images/logoBlack.png"),
                    ),
                  ),
                  accountName: Text(
                    "Mazen Salon",
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text("mazensalon@gmail.com")),
              Container(
                color: Colors.black12,
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "إغلاق",
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.elMessiri(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Switch(
                      focusColor: Colors.black,
                      activeColor: Colors.green,
                      value: isClose,
                      onChanged: (value) async {
                        setState(() {
                          isClose = value;
                          print(isClose);
                        });
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                  title: Text(
                    "سجل جميع الحجوزات",
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.elMessiri(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  leading: Icon(Icons.history),
                  onTap: () {},
                  tileColor: Colors.black12),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text(
                  "تسجيل الخروج",
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.elMessiri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                leading: Icon(Icons.logout),
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
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed("home page");
                  }
                },
                tileColor: Colors.black12,
              ),
            ],
          ),
        ),
        body: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                  height: 55,
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Text(
                    "الحجوزات المسجلة ليوم $dayName:",
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.elMessiri(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("reservations")
                      .where('done', isEqualTo: false)
                      .orderBy('reserve_number')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (checkMonday.weekday == 1) {
                      return Center(
                          child: Text(
                        "لا توجد أي حجوزات \n اليوم عطلة ^_^",
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.elMessiri(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ));
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.black,
                              backgroundColor: Colors.white,
                              strokeWidth: 5,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "جارِ تحميل الحجوزات...",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.elMessiri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.data == null) {
                      return Center(
                          child: Text(
                        "لا توجد أي حجوزات !",
                        style: GoogleFonts.elMessiri(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ));
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Column(
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                right: 10,
                                                top: 10,
                                              ),
                                              child: Text(
                                                "الإسم:",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                right: 8,
                                                top: 10,
                                              ),
                                              child: Text(
                                                snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get('name'),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                "نوع الحجز:",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get('reserve_type'),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                "وقت الحجز:",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get('reserve_time'),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                "رقم الهاتف:",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get('phone_number'),
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: GoogleFonts.elMessiri(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 15,
                                  right: 20,
                                  left: 20,
                                ),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () async {
                                    final connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult ==
                                        ConnectivityResult.none) {
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
                                      await updateDoneStatus();
                                      await updateStatusAfterFinish(
                                        snapshot.data!.docs
                                            .elementAt(index)
                                            .get('reserve_time'),
                                        index,
                                      );
                                    }
                                  },
                                  color: Colors.black,
                                  child: Text(
                                    "جاهز",
                                    style: GoogleFonts.elMessiri(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
