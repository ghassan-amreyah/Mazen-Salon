import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazen_salon/admin_page.dart';
import 'package:mazen_salon/api/firebase_api.dart';
import 'package:mazen_salon/splash_screen.dart';

import 'booking_details.dart';
import 'booking_times.dart';
import 'chose_booking.dart';
import 'home_page.dart';
import 'login.dart';

bool? isLogin;

void main() async {
  //Firebase Initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Notifications
  await FirebaseApi().initNotifications();

  //Subscribe when the app run to send the notifications
  //await FirebaseMessaging.instance.subscribeToTopic("mazen salon");

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
  var userLogin = FirebaseAuth.instance.currentUser;
  if (userLogin == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin == false ? const SplashScreen() : const AdminPage(),
      routes: {
        "home page": (context) => const HomePage(),
        "chose book page": (context) => const BookingType(),
        "booking page": (context) => const BookingTimes(),
        "booking details": (context) => const BookingDetails(),
        "login page": (context) => const Login(),
        "admin page": (context) => const AdminPage(),
      },
    );
  }
}
