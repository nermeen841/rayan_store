// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print
import 'package:easy_localization/easy_localization.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/app_cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/product_detail/componnent/full_slider.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'componnent/add_to_cart.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String lang = '';
  int count = 1;
  String currency = '';
  bool login = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      login = preferences.getBool('login') ?? false;
    });
  }

  size() {
    count = 1;
    AppCubit.get(context).sizeselected = null;
    AppCubit.get(context).sizeSelection(selected: null, title: null);
    AppCubit.get(context).colorselected = null;
    AppCubit.get(context).colorSelection(selected: null, title: null);
  }

  @override
  void initState() {
    getLang();
    size();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 0.0,
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<HomeCubit, AppCubitStates>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! SingleProductLoaedingState,
                  builder: (context) => Stack(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: w,
                                height: h * 0.4,
                                child: Swiper(
                                  pagination: const SwiperPagination(
                                      builder: DotSwiperPaginationBuilder(
                                          color: Colors.white38,
                                          activeColor: Colors.white),
                                      alignment: Alignment.bottomCenter),
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                EndPoints.IMAGEURL +
                                                    HomeCubit.get(context)
                                                        .singleProductModel!
                                                        .data!
                                                        .images![i]
                                                        .img!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FullSliderScreen(
                                                        productId: HomeCubit
                                                                .get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .id
                                                            .toString(),
                                                        image: HomeCubit.get(
                                                                context)
                                                            .singleProductModel!
                                                            .data!
                                                            .images!)));
                                      },
                                    );
                                  },
                                  itemCount: HomeCubit.get(context)
                                      .singleProductModel!
                                      .data!
                                      .images!
                                      .length,
                                  autoplay: true,
                                  autoplayDelay: 5000,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.02),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: mainColor,
                                    size: w * 0.09,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: h * 0.39),
                            child: Container(
                              height: h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(w * 0.045),
                                  topRight: Radius.circular(w * 0.04),
                                ),
                              ),
                              child: ListView(
                                primary: true,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    vertical: h * 0.03, horizontal: w * 0.01),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 0.01,
                                            horizontal: w * 0.01),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            (lang == 'en')
                                                ? Text(
                                                    HomeCubit.get(context)
                                                        .singleProductModel!
                                                        .data!
                                                        .titleEn!,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    HomeCubit.get(context)
                                                        .singleProductModel!
                                                        .data!
                                                        .titleAr!,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                            favouriteButton(
                                                context: context,
                                                login: login,
                                                productId:
                                                    HomeCubit.get(context)
                                                        .singleProductModel!
                                                        .data!
                                                        .id
                                                        .toString()),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.01),
                                        child: (lang == 'en')
                                            ? Text(
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionEn!,
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.04,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              )
                                            : Text(
                                                HomeCubit.get(context)
                                                    .singleProductModel!
                                                    .data!
                                                    .descriptionAr!,
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.04,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  sizeColorSelection(
                                      context: context,
                                      w: w,
                                      h: h,
                                      lang: lang,
                                      size: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .sizes!,
                                      productId: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .id
                                          .toString()),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: h * 0.015),
                                        child: Text(
                                          LocalKeys.QTY.tr(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontSize: w * 0.04),
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.03,
                                      ),
                                      BlocConsumer<DataBaseCubit,
                                              DatabaseStates>(
                                          builder: (context, state) {
                                            return Container(
                                              width: w * 0.4,
                                              height: h * 0.055,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 0.015),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.05),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BlocConsumer<CartCubit,
                                                          CartState>(
                                                      builder:
                                                          (context, state) {
                                                    return SizedBox(
                                                      width: 40,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          if (AppCubit.get(
                                                                          context)
                                                                      .sizeselected !=
                                                                  null ||
                                                              AppCubit.get(
                                                                          context)
                                                                      .colorselected !=
                                                                  null) {
                                                            CartCubit.get(context).checkProductQty(
                                                                context:
                                                                    context,
                                                                productId: HomeCubit
                                                                        .get(
                                                                            context)
                                                                    .singleProductModel!
                                                                    .data!
                                                                    .id
                                                                    .toString(),
                                                                productQty: count
                                                                    .toString(),
                                                                sizeId: prefs
                                                                    .getString(
                                                                        'size_id')
                                                                    .toString(),
                                                                colorId: prefs
                                                                    .getString(
                                                                        'color_id')
                                                                    .toString());
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP,
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                msg: LocalKeys
                                                                    .ATTRIBUTES
                                                                    .tr());
                                                          }
                                                        },
                                                        child: Image.asset(
                                                            "assets/minus (2).png"),
                                                      ),
                                                    );
                                                  }, listener:
                                                          (context, state) {
                                                    if (state
                                                            is CheckProductAddcartSuccessState &&
                                                        count <
                                                            CartCubit.get(
                                                                    context)
                                                                .totalQuantity) {
                                                      setState(() {
                                                        count++;
                                                        print(count);
                                                      });
                                                    } else if (state
                                                        is CheckProductAddcartErroState) {
                                                      setState(() {
                                                        count = count;
                                                      });
                                                    }
                                                  }),
                                                  Text(
                                                    count.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if (count == 1) {
                                                          setState(() {
                                                            count = 1;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            count--;
                                                          });
                                                        }
                                                      },
                                                      child: Image.asset(
                                                          "assets/minus (1).png"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          listener: (context, state) {}),
                                    ],
                                  ),
                                  // ignore: prefer_const_constructors
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    child: Center(
                                      child: Text(
                                        LocalKeys.DETAIL_TITLE.tr(),
                                        style: TextStyle(
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontSize: w * 0.04,
                                          color: mainColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          addtoCartHeader(
                              context: context,
                              w: w,
                              h: h,
                              count: count,
                              currency: currency,
                              lang: lang),
                        ],
                      ),
                  fallback: (context) => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ));
            },
            listener: (context, state) {}));
  }
}
