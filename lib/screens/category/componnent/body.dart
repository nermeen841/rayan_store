// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/category/model/product_cat_model.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProducts extends StatefulWidget {
  final String subCatId;

  const CategoryProducts({Key? key, required this.subCatId}) : super(key: key);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
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
      var response = await http.get(Uri.parse(EndPoints.BASE_URL +
          "get-products-in-child/${widget.subCatId}?page=$page"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        CategoryProductModel categoryProductModel =
            CategoryProductModel.fromJson(data);
        setState(() {
          products = categoryProductModel.data!.products!;
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
        var response = await http.get(Uri.parse(EndPoints.BASE_URL +
            "get-products-in-child/${widget.subCatId}?page=$page"));
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          CategoryProductModel categoryProductModel =
              CategoryProductModel.fromJson(data);
          setState(() {
            fetchedPosts = categoryProductModel.data!.products!;
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
    return Column(
      children: [
        SizedBox(
          height: h * 0.03,
        ),
        isFirstLoadRunning
            ? Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              )
            : (products.isNotEmpty)
                ? Expanded(
                    child: GridView.builder(
                        controller: scrollController,
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.65,
                          mainAxisSpacing: w * 0.08,
                          crossAxisSpacing: h * 0.04,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                HomeCubit.get(context).getProductdata(
                                    productId: products[index].id.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail()));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: h * 0.01, horizontal: w * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      products[index].img),
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
                                                ? Text(products[index].titleEn,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.035),
                                                    overflow: TextOverflow.fade)
                                                : Text(products[index].titleAr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.035),
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
                                                ? Text(
                                                    products[index]
                                                        .descriptionEn,
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: Colors.grey,
                                                        fontSize: w * 0.035),
                                                    overflow: TextOverflow.fade)
                                                : Text(
                                                    products[index]
                                                        .descriptionAr,
                                                    style: TextStyle(
                                                        fontFamily: 'Almarai',
                                                        color: Colors.grey,
                                                        fontSize: w * 0.035),
                                                    overflow:
                                                        TextOverflow.fade),
                                          ),
                                          SizedBox(
                                            height: h * 0.005,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                            fontFamily:
                                                                (lang == 'en')
                                                                    ? 'Nunito'
                                                                    : 'Almarai',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: mainColor)),
                                                  ],
                                                ),
                                              ),
                                              (products[index].hasOffer == 1)
                                                  ? Text(
                                                      '${products[index].beforePrice}'
                                                              " " +
                                                          currency,
                                                      style: TextStyle(
                                                        fontSize: w * 0.035,
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            mainColor,
                                                        color: Colors.grey,
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
                            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
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
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Alamrai'),
              ),
            ),
          ),
      ],
    );
  }
}
