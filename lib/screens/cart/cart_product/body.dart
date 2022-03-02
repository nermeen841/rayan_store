// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart_product/conponent.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class RayanCartBody extends StatefulWidget {
  static String lang = '';
  static String currency = '';
  static num finalPrice = 0;
  @override
  State<RayanCartBody> createState() => _RayanCartBodyState();
}

class _RayanCartBodyState extends State<RayanCartBody> {
  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    RayanCartBody.finalPrice = 0;
    setState(() {
      RayanCartBody.lang = preferences.getString('language').toString();
      RayanCartBody.currency = preferences.getString('currency').toString();
      DataBaseCubit.get(context).cart.forEach((element) {
        RayanCartBody.finalPrice += element['productPrice'];
      });
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
    return BlocConsumer<DataBaseCubit, DatabaseStates>(
      builder: (context, state) {
        return ListView(
          primary: true,
          shrinkWrap: true,
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.02),
          children: [
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: DataBaseCubit.get(context).cart.length,
              itemBuilder: (context, index) {
                return BlocConsumer<CartCubit, CartState>(
                    builder: (context, state) {
                  return buildCartIem(
                    title: (RayanCartBody.lang == 'en')
                        ? DataBaseCubit.get(context).cart[index]
                            ['productNameEn']
                        : DataBaseCubit.get(context).cart[index]
                            ['productNameAr'],
                    price: DataBaseCubit.get(context).cart[index]
                            ['productPrice'] *
                        DataBaseCubit.get(context).counter[
                            DataBaseCubit.get(context).cart[index]
                                ['productId']],
                    description: (RayanCartBody.lang == 'en')
                        ? DataBaseCubit.get(context).cart[index]
                            ['productDescEn']
                        : DataBaseCubit.get(context).cart[index]
                            ['productDescAr'],
                    image: DataBaseCubit.get(context).cart[index]['productImg'],
                    qty: (DataBaseCubit.get(context).counter[
                                DataBaseCubit.get(context).cart[index]
                                    ['productId']] ==
                            null)
                        ? DataBaseCubit.get(context).cart[index]['productQty']
                        : DataBaseCubit.get(context).counter[
                            DataBaseCubit.get(context).cart[index]
                                ['productId']],
                    context: context,
                    decreaseqty: () {
                      if (DataBaseCubit.get(context).cart.isEmpty) {
                        setState(() {
                          RayanCartBody.finalPrice = 0;
                        });
                      }
                      if (DataBaseCubit.get(context).counter[
                              DataBaseCubit.get(context).cart[index]
                                  ['productId']] ==
                          0) {
                        DataBaseCubit.get(context).deletaFromDB(
                          id: DataBaseCubit.get(context).cart[index]
                              ['productId'],
                        );
                      } else {
                        setState(() {
                          DataBaseCubit.get(context).counter[
                                  DataBaseCubit.get(context).cart[index]
                                      ['productId']] =
                              int.parse(DataBaseCubit.get(context)
                                      .cart[index]['productQty']
                                      .toString()) -
                                  1;
                          RayanCartBody.finalPrice -= DataBaseCubit.get(context)
                              .cart[index]['productPrice'];
                          if (RayanCartBody.finalPrice < 0 ||
                              DataBaseCubit.get(context).cart.isEmpty) {
                            RayanCartBody.finalPrice = 0;
                          }
                        });
                      }
                      DataBaseCubit.get(context).updateDatabase(
                        productId: DataBaseCubit.get(context).cart[index]
                            ['productId'],
                        productQty: DataBaseCubit.get(context).counter[
                            DataBaseCubit.get(context).cart[index]
                                ['productId']]!,
                      );
                    },
                    increaseqty: () async {
                      setState(() {
                        RayanCartBody.finalPrice += DataBaseCubit.get(context)
                            .cart[index]['productPrice'];
                      });
                      CartCubit.get(context).checkProductQty(
                          context: context,
                          productId: DataBaseCubit.get(context)
                              .cart[index]['productId']
                              .toString(),
                          productQty: DataBaseCubit.get(context)
                              .cart[index]['productQty']
                              .toString(),
                          sizeId: DataBaseCubit.get(context)
                              .cart[index]['sizeId']
                              .toString(),
                          colorId: DataBaseCubit.get(context)
                              .cart[index]['colorId']
                              .toString());
                    },
                  );
                }, listener: (context, state) {
                  if (state is CheckProductAddcartErroState) {
                    Fluttertoast.showToast(
                        msg: LocalKeys.ERROR_MESSAGE.tr(),
                        textColor: Colors.white,
                        backgroundColor: Colors.red,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP);
                  }
                });
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: h * 0.03,
              ),
            ),
            SizedBox(
              height: h * 0.05,
            ),
            cobonButton(
              context: context,
            ),
            SizedBox(
              height: h * 0.05,
            ),
            Row(
              children: [
                Text(
                  LocalKeys.PRICE.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                  ),
                ),
                const Spacer(),
                Text(
                  RayanCartBody.finalPrice.toString() +
                      " " +
                      RayanCartBody.currency,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                  ),
                )
              ],
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Row(
              children: [
                Text(
                  LocalKeys.SHIPPING.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                  ),
                ),
                const Spacer(),
                Text(
                  LocalKeys.DEPEND_CITY.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                  ),
                )
              ],
            ),
            SizedBox(
              height: h * 0.03,
            ),
            myDiv(height: 1),
            SizedBox(
              height: h * 0.03,
            ),
            Row(
              children: [
                Text(
                  LocalKeys.TOTAL_PRICE.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                  ),
                ),
                const Spacer(),
                Text(
                  RayanCartBody.finalPrice.toString() +
                      " " +
                      RayanCartBody.currency,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily:
                        (RayanCartBody.lang == 'en') ? 'Nunito' : 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            payButton(context: context),
          ],
        );
      },
      listener: (context, state) {},
    );
  }
}
