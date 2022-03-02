// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/allproducts/model/offers_model.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class AllOffersScreen extends StatefulWidget {
  @override
  _AllOffersScreenState createState() => _AllOffersScreenState();
}

class _AllOffersScreenState extends State<AllOffersScreen> {
  late ScrollController scrollController;
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List products = [];

  String lang = '';
  String currency = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
    });
  }

  void firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });
    try {
      var response =
          await http.get(Uri.parse(EndPoints.BASE_URL + "offers?page=$page"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        OffersModel offersModel = OffersModel.fromJson(data);
        setState(() {
          products = offersModel.data!.offers!.dataOffers!;
        });
      }
    } catch (error) {
      print("product error ----------------------" + error.toString());
    }
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 15) {
      setState(() {
        isLoadMoreRunning = true;
        page++;
      });
      List fetchedPosts = [];
      try {
        var response =
            await http.get(Uri.parse(EndPoints.BASE_URL + "offers?page=$page"));
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          OffersModel offersModel = OffersModel.fromJson(data);
          setState(() {
            fetchedPosts = offersModel.data!.offers!.dataOffers!;
          });
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            products.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (error) {
        print("product error ----------------------" + error.toString());
      }
      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    firstLoad();
    getLang();
    scrollController = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "",
          style: TextStyle(
              color: Colors.white, fontSize: w * 0.04, fontFamily: 'Nunito'),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.01),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Badge(
                badgeColor: mainColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                  focusColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Cart()));
                  },
                ),
                animationDuration: const Duration(
                  seconds: 2,
                ),
                badgeContent: (DataBaseCubit.get(context).cart.isNotEmpty)
                    ? Text(
                        DataBaseCubit.get(context).cart.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.03,
                        ),
                      )
                    : Text(
                        "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.03,
                        ),
                      ),
                position: BadgePosition.topStart(start: w * 0.007),
              ),
            ),
          ),
          SizedBox(
            width: w * 0.05,
          ),
        ],
      ),
      body: isFirstLoadRunning
          ? Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: h * 0.03, horizontal: w * 0.03),
              child: Column(
                children: [
                  SizedBox(
                    height: h * 0.01,
                  ),
                  (products.isNotEmpty)
                      ? Expanded(
                          child: GridView.builder(
                              controller: scrollController,
                              itemCount: products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.6,
                                mainAxisSpacing: w * 0.08,
                                crossAxisSpacing: h * 0.04,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      HomeCubit.get(context).getProductdata(
                                          productId:
                                              products[index].id.toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetail()));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: h * 0.01,
                                          horizontal: w * 0.01),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: w * 0.45,
                                            height: h * 0.28,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                      EndPoints.IMAGEURL2 +
                                                          products[index].img,
                                                    ),
                                                    fit: BoxFit.fitHeight)),
                                          ),
                                          SizedBox(
                                            width: w * 0.45,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: h * 0.01,
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxHeight: h * 0.07,
                                                  ),
                                                  child: (lang == 'en')
                                                      ? Text(
                                                          products[index]
                                                              .titleEn,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  (lang == 'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                              fontSize:
                                                                  w * 0.035),
                                                          overflow:
                                                              TextOverflow.fade)
                                                      : Text(
                                                          products[index]
                                                              .titleAr,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  (lang == 'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                              fontSize:
                                                                  w * 0.035),
                                                          overflow:
                                                              TextOverflow.fade),
                                                ),
                                                SizedBox(
                                                  height: h * 0.005,
                                                ),
                                                Container(
                                                    constraints: BoxConstraints(
                                                      maxHeight: h * 0.07,
                                                    ),
                                                    child: (lang == 'en')
                                                        ? Text(products[index].descriptionEn,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily: (lang == 'en')
                                                                    ? 'Nunito'
                                                                    : 'Almarai',
                                                                fontSize:
                                                                    w * 0.035),
                                                            overflow: TextOverflow
                                                                .fade)
                                                        : Text(products[index].descriptionAr,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontFamily: (lang ==
                                                                        'en')
                                                                    ? 'Nunito'
                                                                    : 'Almarai',
                                                                fontSize:
                                                                    w * 0.035),
                                                            overflow: TextOverflow
                                                                .fade)),
                                                SizedBox(
                                                  height: h * 0.005,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  '${products[index].price}'
                                                                          " " +
                                                                      currency,
                                                              style: TextStyle(
                                                                  fontFamily: (lang ==
                                                                          'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      mainColor)),
                                                        ],
                                                      ),
                                                    ),
                                                    (products[index].hasOffer ==
                                                            1)
                                                        ? Text(
                                                            '${products[index].beforePrice}'
                                                                    " " +
                                                                currency,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  (lang == 'en')
                                                                      ? 'Nunito'
                                                                      : 'Almarai',
                                                              fontSize:
                                                                  w * 0.035,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationColor:
                                                                  mainColor,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: h * 0.3),
                          child: Center(
                            child: Text(
                              LocalKeys.NO_PRODUCT.tr(),
                              style: TextStyle(
                                  color: mainColor,
                                  fontFamily:
                                      (lang == 'en') ? 'Nunito' : 'Almarai',
                                  fontSize: w * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                  if (isLoadMoreRunning == true)
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                    ),

                  // When nothing else to load
                  if (hasNextPage == false)
                    Container(
                      padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          LocalKeys.NO_MORE_PRODUCT.tr(),
                          style: TextStyle(
                              fontFamily:
                                  (lang == 'en') ? 'Nunito' : 'Alamrai'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
