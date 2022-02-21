import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'cart_product/body.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: mainColor),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          LocalKeys.CART.tr(),
          style: TextStyle(
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              fontSize: w * 0.05,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: BlocConsumer<DataBaseCubit, DatabaseStates>(
        builder: (context, state) {
          return (DataBaseCubit.get(context).cart.isNotEmpty)
              ? RayanCartBody()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h * 0.05,
                    ),
                    Center(
                      child: Image.asset("assets/icons/Group 1.png"),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Text(
                      LocalKeys.SHOP_NOW.tr(),
                      style: TextStyle(
                          fontSize: w * 0.05,
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Center(
                      child: Text(LocalKeys.CART_EMPTY_TITLE.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: w * 0.05,
                              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: h * 0.05,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      index: 0,
                                    )),
                            (route) => false);
                      },
                      child: Container(
                        width: w * 0.9,
                        height: h * 0.09,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(w * 0.09),
                        ),
                        child: Center(
                          child: Text(
                            LocalKeys.SHOP_NOW.tr(),
                            style: TextStyle(
                                fontSize: w * 0.04,
                                fontFamily:
                                    (lang == 'en') ? 'Nunito' : 'Almarai',
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                );
        },
        listener: (context, state) {},
      ),
    );
  }
}
