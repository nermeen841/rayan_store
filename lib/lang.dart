// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/country/country.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangPage extends StatefulWidget {
  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: Size(w, h),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: w,
                  height: h,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/Mask Group 32.png"),
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: h * 0.05, right: w * 0.02, left: w * 0.02),
                  child: InkWell(
                    // onTap: () => Navigator.pop(context),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset("assets/icons/Path-18.png"),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.65),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        LocalKeys.CHOOSE_LANG.tr(),
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black54,
                            fontSize: w * 0.05,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.09, vertical: h * 0.02),
                              child: Center(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.05,
                                      fontFamily: 'Nnito',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString("language", 'en');
                            preferences.setBool('select_lang', true);
                            setState(() {
                              context.locale = const Locale('en', '');
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Country(1)),
                                (route) => false);
                          },
                        ),
                        SizedBox(
                          width: w * 0.08,
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.09, vertical: h * 0.02),
                              child: Text(
                                'العربية',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString("language", 'ar');
                            preferences.setBool('select_lang', true);
                            setState(() {
                              context.locale = const Locale('ar', '');
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Country(1)),
                                (route) => false);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
