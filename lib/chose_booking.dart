import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mazen_salon/book_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingType extends StatefulWidget {
  const BookingType({super.key});

  @override
  State<BookingType> createState() => _BookingTypeState();
}

class _BookingTypeState extends State<BookingType> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        BookBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: width,
            height: height,
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 70),
                          child: Center(
                              child: Image.asset(
                            "images/logoWhite.png",
                            height: 120,
                          )),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        "ما هو نوع الحجز الذي تريده:",
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.elMessiri(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Added Expanded widget to allow the GridView to take the remaining space
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 10),
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, "booking page");
                              SharedPreferences typeBookPrefs =
                                  await SharedPreferences.getInstance();
                              typeBookPrefs.setString(
                                  "reserveType", "حلاقة رأس فقط");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://i.pinimg.com/564x/15/42/95/1542954e0ecfb21ebd6243ca44989f21.jpg',
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  Text(
                                    " حلاقة رأس فقط",
                                    style: GoogleFonts.elMessiri(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, "booking page");
                              SharedPreferences typeBookPrefs =
                                  await SharedPreferences.getInstance();
                              typeBookPrefs.setString(
                                  "reserveType", "حلاقة كاملة (رأس + لحية)");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://i.pinimg.com/564x/35/41/63/354163a7cfa5dcffbf86b85bfd3e2d48.jpg',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    " حلاقة كاملة\n (رأس + لحية)",
                                    style: GoogleFonts.elMessiri(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, "booking page");
                              SharedPreferences typeBookPrefs =
                                  await SharedPreferences.getInstance();
                              typeBookPrefs.setString(
                                  "reserveType", "حلاقة لحية + تحديد");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://i.pinimg.com/564x/12/90/c3/1290c3368d2cbb5fa9fe96635e8ad8c8.jpg',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  Text(
                                    "حلاقة لحية + تحديد",
                                    style: GoogleFonts.elMessiri(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, "booking page");
                              SharedPreferences typeBookPrefs =
                                  await SharedPreferences.getInstance();
                              typeBookPrefs.setString(
                                  "reserveType", "تصفيف شعر");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://i.pinimg.com/564x/23/83/c5/2383c5c5b79da90dea86e3a05cdb5e78.jpg',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  Text(
                                    "تصفيف شعر", // Your text here
                                    style: GoogleFonts.elMessiri(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
