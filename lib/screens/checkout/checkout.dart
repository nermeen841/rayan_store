// ignore_for_file: use_key_in_widget_constructors
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/checkout/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmCart extends StatefulWidget {
  final String totalPrice;
  final String orderId;
  final String subTotal;

  const ConfirmCart(
      {Key? key,
      required this.totalPrice,
      required this.subTotal,
      required this.orderId})
      : super(key: key);
  @override
  _ConfirmCartState createState() => _ConfirmCartState();
}

class _ConfirmCartState extends State<ConfirmCart> {
  // int isCash = 0;
  int? selected;
  int _counter = 2;
  String lang = '';
  String currency = '';
  bool islogin = false;
  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      islogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    CartCubit.get(context).deliveryModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            LocalKeys.CHECKOUT.tr(),
            style: TextStyle(
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: w * 0.05),
          ),
          actions: [
            InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset("assets/icons/Group 4.png"))
          ],
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Image.asset("assets/icons/Group 10.png")),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: h * 0.03,
            ),
            // InkWell(
            //   onTap: () {
            //     setState(() {
            //       _counter = 1;
            //       isCash = 1;
            //     });
            //   },
            //   child: Container(
            //     height: h * 0.08,
            //     width: w * 0.9,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //       color: Colors.grey[200],
            //     ),
            //     child: Padding(
            //       padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             LocalKeys.CASH.tr(),
            //             style: TextStyle(
            //               fontSize: w * 0.035,
            //               fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            //             ),
            //           ),
            //           Container(
            //             width: w * 0.06,
            //             height: w * 0.06,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(50),
            //               border:
            //                   Border.all(color: mainColor, width: w * 0.005),
            //               color: _counter == 1 ? mainColor : Colors.white,
            //             ),
            //             child: Center(
            //               child: IconButton(
            //                 icon: const Icon(Icons.done),
            //                 onPressed: () {},
            //                 iconSize: w * 0.04,
            //                 color: Colors.white,
            //                 padding: const EdgeInsets.all(0),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: h * 0.02,
            // ),
            InkWell(
              onTap: () {
                setState(() {
                  _counter = 2;
                });
              },
              child: Container(
                height: h * 0.08,
                width: w * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalKeys.VISA.tr(),
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                        ),
                      ),
                      Container(
                        width: w * 0.06,
                        height: w * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: mainColor, width: w * 0.005),
                          color: _counter == 2 ? mainColor : Colors.white,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.done),
                            onPressed: () {},
                            iconSize: w * 0.04,
                            color: Colors.white,
                            padding: const EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _counter = 3;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                              orderId: widget.orderId,
                              totalPrice: widget.totalPrice,
                            )));
              },
              child: Container(
                height: h * 0.08,
                width: w * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalKeys.CARD.tr(),
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                        ),
                      ),
                      Container(
                        width: w * 0.06,
                        height: w * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: mainColor, width: w * 0.005),
                          color: _counter == 3 ? mainColor : Colors.white,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.done),
                            onPressed: () {},
                            iconSize: w * 0.04,
                            color: Colors.white,
                            padding: const EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.04,
            ),
            BlocConsumer<CartCubit, CartState>(
                builder: (context, state) {
                  return ConditionalBuilder(
                      condition: state is! DeliveryLoadingState,
                      builder: (context) => Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.043),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       LocalKeys.PRICE.tr(),
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontFamily: (lang == 'en')
                                //               ? 'Nunito'
                                //               : 'Almarai',
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: w * 0.04),
                                //     ),
                                //     Text(
                                //       widget.subTotal + " " + currency,
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontFamily: (lang == 'en')
                                //               ? 'Nunito'
                                //               : 'Almarai',
                                //           fontWeight: FontWeight.bold,
                                //           fontSize: w * 0.04),
                                //     ),
                                //   ],
                                // ),

                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocalKeys.SHIPPING.tr(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.04),
                                    ),
                                    Text(
                                      CartCubit.get(context)
                                              .deliveryModel!
                                              .value
                                              .toString() +
                                          " " +
                                          currency,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.04),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocalKeys.TIME_DELIVERY.tr(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.04),
                                    ),
                                    Text(
                                      CartCubit.get(context)
                                              .deliveryModel!
                                              .delivery
                                              .toString() +
                                          " " +
                                          LocalKeys.DAYS.tr(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontWeight: FontWeight.w400,
                                          fontSize: w * 0.04),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      fallback: (context) => Container());
                },
                listener: (context, state) {}),
            SizedBox(
              height: h * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.31),
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Container(
                  width: w,
                  height: h * 0.2,
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04, vertical: h * 0.03),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(w * 0.07),
                        topRight: Radius.circular(w * 0.07),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                LocalKeys.TOTAL_PRICE.tr(),
                                style: TextStyle(
                                    color: mainColor,
                                    fontFamily:
                                        (lang == 'en') ? 'Nunito' : 'Almarai',
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.05),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: h * 0.02),
                                child: Text(
                                  widget.totalPrice + " " + currency,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontWeight: FontWeight.bold,
                                      fontSize: w * 0.05),
                                ),
                              ),
                            ],
                          ),
                          BlocConsumer<DataBaseCubit, DatabaseStates>(
                              builder: (context, state) => InkWell(
                                    onTap: () {
                                      if (islogin) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentScreen(
                                                      orderId: widget.orderId,
                                                      totalPrice:
                                                          widget.totalPrice,
                                                    )));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentScreen(
                                                      orderId: widget.orderId,
                                                      totalPrice:
                                                          widget.totalPrice,
                                                    )));
                                      }
                                    },
                                    child: Container(
                                      width: w * 0.35,
                                      height: h * 0.07,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(w * 0.02),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: Center(
                                        child: Text(
                                          LocalKeys.CHECKOUT.tr(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.bold,
                                              fontSize: w * 0.05),
                                        ),
                                      ),
                                    ),
                                  ),
                              listener: (context, state) {
                                if (state is DeleteTablecontentDatabase) {
                                  DataBaseCubit.get(context).cart = [];
                                }
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
