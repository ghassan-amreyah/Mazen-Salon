import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_background.dart';

class BookingTimes extends StatefulWidget {
  const BookingTimes({super.key});

  @override
  State<BookingTimes> createState() => _BookingTimesState();
}

class _BookingTimesState extends State<BookingTimes> {
  @override
  Widget build(BuildContext context) {
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
    return Stack(
      children: [
        const BookBackground(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "Mazen Salon",
                style: GoogleFonts.elMessiri(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                Container(
                    height: 55,
                    width: double.infinity,
                    color: Colors.black54,
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: Text(
                      "الحجوزات المتوفرة ليوم $dayName :",
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.elMessiri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("times")
                        .where('status', isEqualTo: true)
                        .orderBy('number')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (checkMondayInCustomers.weekday == 1) {
                        return Center(
                            child: Container(
                          margin: const EdgeInsets.only(top: 120),
                          padding: const EdgeInsets.all(40),
                          child: Text(
                            "لا توجد أي حجوزات متوفرة ليوم \n الإثنين (عطلة رسمية للحلاقين) !",
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.elMessiri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
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
                                "جارِ تحميل الحجوزات المتوفرة...",
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
                          "لا توجد أي حجوزات متوفرة!",
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
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 60,
                                    margin: EdgeInsets.only(top: 30),
                                    child: Text(
                                      snapshot.data!.docs
                                          .elementAt(index)
                                          .get('clock'),
                                      style: GoogleFonts.elMessiri(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pushNamed("booking details");
                                      SharedPreferences clockPrefs =
                                          await SharedPreferences.getInstance();

                                      clockPrefs.setString("reserveTime",
                                          "${snapshot.data!.docs.elementAt(index).get('clock')}");
                                      clockPrefs.setInt(
                                          "reserveNumber",
                                          snapshot.data!.docs
                                              .elementAt(index)
                                              .get('number'));
                                    },
                                    color: Colors.black,
                                    child: Text(
                                      "حجز",
                                      style: GoogleFonts.elMessiri(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
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
            )),
      ],
    );
  }
}
