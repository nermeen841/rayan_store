// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

String mAPIKey =
    "GnU465_twWngnRHW5vL_oW6Y9-D8n2OqC-WxpOIvhQNYUkEQDT59thwVA6kb4627K1vFKJoPz-4DRu72vjWEuHZx_fb1PqoKlvCf5kyKS6E4z14_OZBp1ntT-U9_vXXI1DVR_xfvcL5G_wo7pMzLCGWs0hK9qFw0Sp7LpHOabU8rjokKKGfMQBNPzSXwUKIJFw9FoxzLA0zReS_chMUK2_F5yAfPIVnBsETA-6Jv8HJSEIrSE1f-ob7WI_-evjyWbNaYqT0mHWMOUFcsGGVwi49WnUXvJAsopIleFGdGdC1ExwsCLX6TMjuJDIaRrOtQpJ6XFxg7CpL_9fzWyycHQ1m18l9cqDEKphhx6EJIkLtV-WaTTQB5h-AmqwbWYDPguCEKygQO4ONHgBgIErxjkVUixl1iKCWfvMs5Jd43gxcNtgUZUiDbbfZVrQRi81X45DC1kqTO6lI4XGC7QSEUete72gIB_Ex5OXEvkjg273kSiGAHn04ChAu2nca6J2eF89AxHllbOx-wQDCWM-cdLfVOf0nRCzZ8VFZosgNX0E1rm7iKXDXQOnJs3m1En29C2QNiptTe2boZ-DdnKsW8IFGxuOmLjxHDG-WYtxWgHaCi-cdGt1pxREb7y0k69Cp0ip5gDGKxCPIo9o0Sc-YNefmz4M_b5CKRsADzhM0Uofkfg-hE";

class PaymentScreen extends StatefulWidget {
  final String totalPrice;

  const PaymentScreen({Key? key, required this.totalPrice}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          LocalKeys.CHECKOUT.tr(),
          style: TextStyle(
              fontSize: w * 0.05,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: mainColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MyFatoorah(
        afterPaymentBehaviour: AfterPaymentBehaviour.AfterCalbacksExecution,
        buildAppBar: (context) {
          return AppBar(
            backgroundColor: Colors.white,
            title: Text(
              LocalKeys.CHECKOUT.tr(),
              style: TextStyle(
                  fontSize: w * 0.05,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            leading: BackButton(
              color: mainColor,
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            elevation: 0,
          );
        },
        onResult: (res) async {
          if (res.isSuccess) {
            print("success url : ---------" + res.url.toString());
            DataBaseCubit.get(context).deleteTableContent();
            DataBaseCubit.get(context).cart = [];
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(index: 0)),
                (route) => false);

            return null;
          }
          if (res.isError) {
            print("error url : ---------" + res.url.toString());
            Navigator.pop(context);

            // customError(context, "there is an error");
          } else if (res.isNothing) {
            print("no thing url : ---------" + res.url.toString());
            Navigator.pop(context);
          }
        },
        request: MyfatoorahRequest.live(
          token: mAPIKey,
          language: ApiLanguage.Arabic,
          invoiceAmount: double.parse(widget.totalPrice),
          successUrl:
              "https://images-eu.ssl-images-amazon.com/images/G/31/img16/GiftCards/payurl1/440x300-2.jpg",
          errorUrl:
              "https://st3.depositphotos.com/3000465/33237/v/380/depositphotos_332373348-stock-illustration-declined-payment-credit-card-vector.jpg?forcejpeg=true",
          currencyIso: Country.Kuwait,
        ),
      ),
    );
  }
}
