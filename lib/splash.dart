// ignore_for_file: use_key_in_widget_constructors, avoid_print
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rayan_store/lang.dart';
import 'package:rayan_store/screens/auth/login.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:rayan_store/screens/country/country.dart';
import 'package:rayan_store/screens/favourite_screen/cubit/favourite_cubit.dart';
import 'package:rayan_store/screens/orders/cubit/order_cubit.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/country/cubit/country_cubit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget screen = LangPage();
  final Geolocator geolocator = Geolocator();
  late Position currentPosition;
  late String currentAddress;
  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {}

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) async {
      setState(() {
        currentPosition = position;
      });
      SharedPreferences pres = await SharedPreferences.getInstance();
      pres.setString('late', position.altitude.toString());
      pres.setString('lang', position.longitude.toString());
      print("lattitude ................. : " + position.altitude.toString());
      print("longtitude ................. : " + position.longitude.toString());
    }).catchError((e) {
      print("location errrrrrrrrrrrrrrrrrrrrrrrr : " + e.toString());
    });
  }

  getScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLogin = prefs.getBool('login') ?? false;
    final bool selectLang = prefs.getBool('select_lang') ?? false;
    final bool countrySelected = prefs.getBool('select_country') ?? false;
    if (selectLang == true) {
      if (isLogin == true) {
        UserprofileCubit.get(context).getUserProfile();
        FavouriteCubit.get(context).getWishlist();
        OrderCubit.get(context).getAllorders();
        setState(() {
          screen = HomeScreen(index: 0);
        });
      } else if (countrySelected == true) {
        CountryCubit().getCity();
        setState(() {
          screen = const Login();
        });
      } else {
        setState(() {
          screen = Country(1);
        });
      }
    } else {
      setState(() {
        screen = LangPage();
      });
    }
  }

  @override
  void initState() {
    getScreen();
    getCurrentLocation();
    HomeCubit.get(context).getHomeitems();
    CountryCubit.get(context).getCountry();
    UserprofileCubit.get(context).getAllinfo();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => screen)));
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token = await FirebaseMessaging.instance.getToken();
      if (_token != null) {
        prefs.setString('davice_token', _token);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      height: h,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/icons/splash.jpeg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: Center(
          child: Image.asset(
            "assets/icons/Group 30.png",
          ),
        ),
      ),
    );
  }
}
