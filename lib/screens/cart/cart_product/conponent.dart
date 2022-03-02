// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/address/add_address.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/cart/cart_product/body.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildCartIem(
    {required String title,
    required String description,
    required String image,
    required int price,
    required int qty,
    required VoidCallback increaseqty,
    required VoidCallback decreaseqty,
    required BuildContext context}) {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;

  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              EndPoints.IMAGEURL2 + image,
              width: w * 0.3,
              height: h * 0.29,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: w * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: h * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: w * 0.3,
                        child: Text(
                          title,
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: w * 0.04,
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Almarai',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: w * 0.1,
                      ),
                      Text("$price" " " + RayanCartBody.currency),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  SizedBox(
                    width: w * 0.63,
                    child: Text(
                      description,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: w * 0.03,
                        fontFamily:
                            (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: increaseqty,
                          child: Icon(
                            Icons.add_circle_outline,
                            size: w * 0.1,
                          )),
                      SizedBox(
                        width: w * 0.025,
                      ),
                      Text(
                        '$qty',
                        style: TextStyle(
                            fontFamily: (RayanCartBody.lang == 'en')
                                ? 'Nunito'
                                : 'Alamari',
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: w * 0.025,
                      ),
                      InkWell(
                          onTap: decreaseqty,
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: w * 0.1,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget cobonButton({required BuildContext context}) {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  TextEditingController controller = TextEditingController();
  RoundedLoadingButtonController btncontroller =
      RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();
  return InkWell(
    onTap: () {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.05)),
                title: BlocConsumer<CartCubit, CartState>(
                    builder: (context, state) => Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(LocalKeys.ADD_COBON.tr()),
                              SizedBox(
                                height: h * 0.02,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: controller,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: LocalKeys.ADD_COBON.tr(),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: mainColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: mainColor)),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: mainColor)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                              ),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              RoundedLoadingButton(
                                  controller: btncontroller,
                                  color: mainColor,
                                  successColor: Colors.green,
                                  errorColor: Colors.red,
                                  disabledColor: Colors.white,
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('cobon', controller.text);
                                    CartCubit.get(context).getCheckcobon(
                                        cobon: controller.text,
                                        context: context,
                                        controller: btncontroller);
                                  },
                                  child: Text(
                                    LocalKeys.SEND.tr(),
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                    listener: (context, state) async {}),
              ));
    },
    child: Container(
      padding: (RayanCartBody.lang == 'en')
          ? EdgeInsets.only(
              left: w * 0.04,
            )
          : EdgeInsets.only(
              right: w * 0.04,
            ),
      height: h * 0.08,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.04),
          color: mainColor,
          border: Border.all(color: Colors.grey)),
      child: Row(
        children: [
          Text(
            LocalKeys.ADD_COBON.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
              fontFamily: (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
          const Spacer(),
          Container(
            height: h * 0.08,
            width: w * 0.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.04),
                border: Border.all(color: Colors.pinkAccent)),
            child: Center(
              child: Text(
                '19836',
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily:
                      (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget myDiv({
  required double height,
}) =>
    Container(
      width: double.infinity,
      height: height,
      color: Colors.black54,
    );

Widget payButton({required BuildContext context}) {
  var w = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddressInfo()));
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(w * 0.7)),
        child: Center(
            child: Text(
          LocalKeys.CHECKOUT.tr(),
          style: TextStyle(
              fontSize: w * 0.05,
              fontFamily: (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        )),
      ),
    ),
  );
}
