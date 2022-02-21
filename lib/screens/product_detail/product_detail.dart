// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
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

import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/favourite_screen/cubit/favourite_cubit.dart';
import 'package:rayan_store/screens/product_detail/full_slider.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    AppCubit.get(context).sizeselected = null;
    AppCubit.get(context).sizeSelection(selected: null);
    AppCubit.get(context).colorselected = null;
    AppCubit.get(context).colorSelection(selected: null);
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
                  builder: (context) => ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: w,
                                height: h * 0.6,
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
                                            fit: BoxFit.fitWidth,
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
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.01, horizontal: w * 0.01),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (lang == 'en')
                                    ? Text(
                                        HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .titleEn!,
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    : Text(
                                        HomeCubit.get(context)
                                            .singleProductModel!
                                            .data!
                                            .titleAr!,
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                BlocConsumer<FavouriteCubit, FavouriteState>(
                                    builder: (context, state) {
                                      return InkWell(
                                        onTap: () {
                                          if (login) {
                                            FavouriteCubit.get(context)
                                                .addtowishlist(
                                                    productId:
                                                        HomeCubit.get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .id
                                                            .toString());
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: LocalKeys.MUST_LOGIN.tr(),
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                gravity: ToastGravity.TOP,
                                                toastLength: Toast.LENGTH_LONG);
                                          }
                                        },
                                        child: (FavouriteCubit.get(context)
                                                        .isFavourite[
                                                    int.parse(
                                                        HomeCubit.get(context)
                                                            .singleProductModel!
                                                            .data!
                                                            .id!
                                                            .toString())] ==
                                                true)
                                            ? Icon(
                                                Icons.favorite,
                                                color: mainColor,
                                              )
                                            : Icon(
                                                Icons.favorite_outline,
                                                color: mainColor,
                                              ),
                                      );
                                    },
                                    listener: (context, state) {}),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.01),
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.03, horizontal: w * 0.01),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocalKeys.SIZE.tr(),
                                  style: TextStyle(
                                      fontFamily:
                                          (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                InkWell(
                                  onTap: () {
                                    homeBottomSheet(
                                        context: context,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: h * 0.03,
                                            ),
                                            Center(
                                              child: Text(
                                                LocalKeys.SIZE.tr(),
                                                style: TextStyle(
                                                    fontFamily: (lang == 'en')
                                                        ? 'Nunito'
                                                        : 'Almarai',
                                                    fontSize: w * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              height: h * 0.02,
                                            ),
                                            BlocConsumer<AppCubit,
                                                    AppCubitStates>(
                                                builder: (context, state) {
                                                  return ListView.builder(
                                                      primary: true,
                                                      shrinkWrap: true,
                                                      itemCount: HomeCubit.get(
                                                              context)
                                                          .singleProductModel!
                                                          .data!
                                                          .sizes!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      h * 0.02),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Radio(
                                                                  activeColor:
                                                                      mainColor,
                                                                  value: index,
                                                                  groupValue: AppCubit
                                                                          .get(
                                                                              context)
                                                                      .sizeselected,
                                                                  onChanged:
                                                                      (value) async {
                                                                    SharedPreferences
                                                                        prefs =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    prefs
                                                                        .setString(
                                                                      'size_id',
                                                                      HomeCubit.get(
                                                                              context)
                                                                          .singleProductModel!
                                                                          .data!
                                                                          .sizes![
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                    );
                                                                    prefs.setString(
                                                                        'sizeOption',
                                                                        HomeCubit.get(context)
                                                                            .singleProductModel!
                                                                            .data!
                                                                            .sizes![index]
                                                                            .pivot!
                                                                            .id
                                                                            .toString());
                                                                    AppCubit.get(
                                                                            context)
                                                                        .sizeselected = index;
                                                                    AppCubit.get(
                                                                            context)
                                                                        .sizeSelection(
                                                                            selected:
                                                                                index);
                                                                    HomeCubit.get(
                                                                            context)
                                                                        .getProductColor(
                                                                      context:
                                                                          context,
                                                                      productId: HomeCubit.get(
                                                                              context)
                                                                          .singleProductModel!
                                                                          .data!
                                                                          .id
                                                                          .toString(),
                                                                      sizeId: HomeCubit.get(
                                                                              context)
                                                                          .singleProductModel!
                                                                          .data!
                                                                          .sizes![
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                    );
                                                                  }),
                                                              Text(
                                                                HomeCubit.get(
                                                                        context)
                                                                    .singleProductModel!
                                                                    .data!
                                                                    .sizes![
                                                                        index]
                                                                    .name!,
                                                                style: TextStyle(
                                                                    fontFamily: (lang ==
                                                                            'en')
                                                                        ? 'Nunito'
                                                                        : 'Almarai',
                                                                    fontSize: w *
                                                                        0.04,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                listener: (context, state) {})
                                          ],
                                        ));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "",
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                        size: w * 0.08,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.03, horizontal: w * 0.01),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocalKeys.COLOR.tr(),
                                  style: TextStyle(
                                      fontFamily:
                                          (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                InkWell(
                                  onTap: () {
                                    homeBottomSheet(
                                        context: context,
                                        child: BlocConsumer<HomeCubit,
                                                AppCubitStates>(
                                            builder: (context, state) {
                                              return ConditionalBuilder(
                                                condition: state
                                                    is! SingleProductColorLoaedingState,
                                                builder: (context) => Column(
                                                  children: [
                                                    SizedBox(
                                                      height: h * 0.03,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        LocalKeys.COLOR.tr(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: w * 0.05,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: h * 0.02,
                                                    ),
                                                    BlocConsumer<AppCubit,
                                                            AppCubitStates>(
                                                        builder:
                                                            (context, state) {
                                                          return ListView
                                                              .builder(
                                                                  primary: true,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: HomeCubit
                                                                          .get(
                                                                              context)
                                                                      .singleProductColorModel!
                                                                      .data!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              h * 0.02),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Radio(
                                                                              activeColor: mainColor,
                                                                              value: index,
                                                                              groupValue: AppCubit.get(context).colorselected,
                                                                              onChanged: (value) async {
                                                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                prefs.setString('color_id', HomeCubit.get(context).singleProductColorModel!.data![index].heightId.toString());
                                                                                prefs.setString('colorOption', HomeCubit.get(context).singleProductColorModel!.data![index].id.toString());
                                                                                AppCubit.get(context).colorselected = index;
                                                                                AppCubit.get(context).colorSelection(selected: index);
                                                                              }),
                                                                          Text(
                                                                            HomeCubit.get(context).singleProductColorModel!.data![index].name!,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Nunito',
                                                                                fontSize: w * 0.04,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.grey),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                                        },
                                                        listener:
                                                            (context, state) {})
                                                  ],
                                                ),
                                                fallback: (context) => Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: mainColor,
                                                  ),
                                                ),
                                              );
                                            },
                                            listener: (context, state) {}));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "",
                                        style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                        size: w * 0.08,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: h * 0.09),
                            child: Column(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  child: Center(
                                    child: Text(
                                      LocalKeys.DETAIL_TITLE.tr(),
                                      style: TextStyle(
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontSize: w * 0.04,
                                          color: mainColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.02,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: Container(
                                    width: w,
                                    height: h * 0.2,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.04,
                                        vertical: h * 0.03),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(w * 0.07),
                                          topRight: Radius.circular(w * 0.07),
                                        )),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocalKeys.PRICE.tr(),
                                          style: TextStyle(
                                              color: mainColor,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontWeight: FontWeight.bold,
                                              fontSize: w * 0.05),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${HomeCubit.get(context).singleProductModel!.data!.price!}"
                                                      " " +
                                                  currency,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: w * 0.05),
                                            ),
                                            BlocConsumer<DataBaseCubit,
                                                    DatabaseStates>(
                                                builder: (context, state) =>
                                                    InkWell(
                                                      onTap: () async {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        if (AppCubit.get(
                                                                        context)
                                                                    .colorselected ==
                                                                null ||
                                                            AppCubit.get(
                                                                        context)
                                                                    .sizeselected ==
                                                                null) {
                                                          Fluttertoast.showToast(
                                                              backgroundColor:
                                                                  Colors.black,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              msg:
                                                                  "Choose attribute first");
                                                        } else {
                                                          DataBaseCubit.get(context).inserttoDatabase(
                                                              sizeOption: int.parse(prefs
                                                                  .getString(
                                                                      'sizeOption')
                                                                  .toString()),
                                                              colorOption: int.parse(prefs
                                                                  .getString(
                                                                      'colorOption')
                                                                  .toString()),
                                                              productId: HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .id!,
                                                              productNameEn: HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .titleEn!,
                                                              productNameAr:
                                                                  HomeCubit.get(context)
                                                                      .singleProductModel!
                                                                      .data!
                                                                      .titleAr!,
                                                              productDescEn: HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .descriptionEn!,
                                                              productDescAr: HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .descriptionAr!,
                                                              productQty: 1,
                                                              productPrice: HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .price,
                                                              productImg: HomeCubit.get(context)
                                                                  .singleProductModel!
                                                                  .data!
                                                                  .img!,
                                                              sizeId: int.parse(prefs.getString('size_id').toString()),
                                                              colorId: int.parse(prefs.getString('color_id').toString()));
                                                          Fluttertoast.showToast(
                                                              backgroundColor:
                                                                  Colors.black,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              msg: LocalKeys
                                                                  .ADD_CAR
                                                                  .tr());
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const Cart()));
                                                        }
                                                      },
                                                      child: Container(
                                                        width: w * 0.35,
                                                        height: h * 0.07,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(w *
                                                                        0.02),
                                                            border: Border.all(
                                                                color:
                                                                    mainColor)),
                                                        child: Center(
                                                          child: Text(
                                                            LocalKeys.ADD_CART
                                                                .tr(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily: (lang ==
                                                                        'en')
                                                                    ? 'Nunito'
                                                                    : 'Almarai',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    w * 0.05),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                listener: (context, state) {})
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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
