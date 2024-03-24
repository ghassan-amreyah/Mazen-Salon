import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late String resultReserveType = "لم يتم تحديد نوع الحجز!";
  late String resultReserveTime = "لم يتم تحديد وقت الحجز!";
  late int resultReserveNumber = 0;
  late String name;
  late String phone;
  late bool doneStatus = false;
  late DateTime actualReserveTime = DateTime.now();
  List clocksData = [];
  CollectionReference timesRefs =
      FirebaseFirestore.instance.collection("times");
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();

  //-----Get available reserve time from database method-------------------------
  getClocks() async {
    await timesRefs.orderBy("number", descending: false).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          clocksData.add(element.data());
        });
      });
    });
  }

  //-----Update status to false of time after reserve method-------------------------
  updateStatus(String clock) async {
    try {
      final QuerySnapshot querySnapshot =
          await timesRefs.where("clock", isEqualTo: clock).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot document = querySnapshot.docs.first;

        // Update the 'status' field to false (as a boolean)
        await document.reference.update({'status': false});

        // Update the local data to reflect the change
        setState(() {
          final index = clocksData.indexWhere((data) => data['clock'] == clock);
          if (index != -1) {
            clocksData[index]['status'] = false;
          }
        });
      } else {
        print("Document not found for clock: $clock");
      }
    } catch (error) {
      print("Error updating status: $error");
    }
  }

  //-----------Get Reserve Type, Time and number Method-------------------------------------
  getReserveType() async {
    SharedPreferences typeBookPrefs = await SharedPreferences.getInstance();
    setState(() {
      resultReserveType = typeBookPrefs.getString("reserveType")!;
      resultReserveTime = typeBookPrefs.getString("reserveTime")!;
      resultReserveNumber = typeBookPrefs.getInt("reserveNumber")!;
    });
  }

  //-----------Add Reserve Method-------------------------------------
  addReserve(String name, String phone, String resultReserveType,
      String resultReserveTime, int resultReserveNumber, bool done) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        });
    CollectionReference reservations =
        FirebaseFirestore.instance.collection("reservations");
    await reservations.add({
      'name': name,
      'phone_number': phone,
      'reserve_type': resultReserveType,
      'reserve_time': resultReserveTime,
      'reserve_number': resultReserveNumber,
      'done': doneStatus,
      'actual_reserve_time': actualReserveTime
    }).then((value) {
      AwesomeDialog(
        dialogType: DialogType.success,
        context: context,
        desc:
            "تم تسجيل الحجز\n شكرًا لإختيارك صالون مازن \n :وقت حجزك هو \n ${resultReserveTime}",
        descTextStyle: GoogleFonts.elMessiri(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        btnOkOnPress: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed("home page");
        },
        btnOkColor: Colors.black,
        dismissOnTouchOutside: false,
        // Set to false to prevent closing on touch outside
        dismissOnBackKeyPress: false,
      ).show();
    });
  }

  @override
  void initState() {
    super.initState();
    getReserveType();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Mazen Salon",
            style: GoogleFonts.elMessiri(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80),
            child: Form(
              key: addFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "نوع الحجز:",
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.elMessiri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            resultReserveType,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.elMessiri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "وقت الحجز:",
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.elMessiri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            resultReserveTime,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.elMessiri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Text(
                      "حطلنا اسمك ورقم تلفونك عشان نتواصل معك:",
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.elMessiri(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          style: GoogleFonts.elMessiri(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            name = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "اسمك ضروري تحطه";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          maxLength: 20,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.person),
                            suffixIconColor: Colors.black,
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                            ),
                            hintText: "اسمك",
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: GoogleFonts.elMessiri(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLength: 10,
                          style: GoogleFonts.elMessiri(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            phone = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "رقم تلفونك ضروري تحطه";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.phone_android),
                            suffixIconColor: Colors.black,
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.black),
                            ),
                            hintText: "رقم تلفونك",
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: GoogleFonts.elMessiri(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
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
                              }
                              if (addFormKey.currentState!.validate()) {
                                await updateStatus(resultReserveTime);
                                addReserve(
                                  name,
                                  phone,
                                  resultReserveType,
                                  resultReserveTime,
                                  resultReserveNumber,
                                  doneStatus,
                                );
                              }
                            },
                            child: Text(
                              "حجز",
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.elMessiri(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
    ;
  }
}
