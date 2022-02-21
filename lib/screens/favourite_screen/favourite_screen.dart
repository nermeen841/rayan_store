// ignore_for_file: use_key_in_widget_constructors
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/favourite_cubit.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  String lang = '';
  String currency = '';
  bool isLogin = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
      isLogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    FavouriteCubit.get(context).getWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            LocalKeys.FAV.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.04,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
          centerTitle: true,
          backgroundColor: mainColor,
          automaticallyImplyLeading: false,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Cart()));
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
        body: (isLogin)
            ? BlocConsumer<FavouriteCubit, FavouriteState>(
                builder: (context, state) {
                  return ConditionalBuilder(
                      condition: state is! GetFavouriteLoadingState,
                      builder: (context) => ListView(
                            primary: true,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.03, horizontal: w * 0.03),
                            children: [
                              SizedBox(
                                height: h * 0.01,
                              ),
                              (FavouriteCubit.get(context)
                                      .wishlistModel!
                                      .data!
                                      .isNotEmpty)
                                  ? GridView.count(
                                      shrinkWrap: true,
                                      primary: false,
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.64,
                                      mainAxisSpacing: w * 0.01,
                                      children: List.generate(
                                          FavouriteCubit.get(context)
                                              .wishlistModel!
                                              .data!
                                              .length,
                                          (index) => InkWell(
                                                onTap: () {
                                                  HomeCubit.get(context)
                                                      .getProductdata(
                                                          productId:
                                                              FavouriteCubit.get(
                                                                      context)
                                                                  .wishlistModel!
                                                                  .data![index]
                                                                  .id
                                                                  .toString());
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: w * 0.45,
                                                        height: h * 0.28,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(EndPoints
                                                                        .IMAGEURL2 +
                                                                    FavouriteCubit.get(
                                                                            context)
                                                                        .wishlistModel!
                                                                        .data![
                                                                            index]
                                                                        .img!),
                                                                fit: BoxFit
                                                                    .fitHeight)),
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.45,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: h * 0.01,
                                                            ),
                                                            Container(
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxHeight:
                                                                      h * 0.07,
                                                                ),
                                                                child: (lang ==
                                                                        'en')
                                                                    ? Text(
                                                                        FavouriteCubit.get(context)
                                                                            .wishlistModel!
                                                                            .data![
                                                                                index]
                                                                            .titleEn!,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              w * 0.035,
                                                                          fontFamily:
                                                                              'Nunito',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .fade)
                                                                    : Text(
                                                                        FavouriteCubit.get(context)
                                                                            .wishlistModel!
                                                                            .data![
                                                                                index]
                                                                            .titleAr!,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              w * 0.035,
                                                                          fontFamily:
                                                                              'Almarai',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.fade)),
                                                            Container(
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxHeight:
                                                                      h * 0.07,
                                                                ),
                                                                child: (lang ==
                                                                        'en')
                                                                    ? Text(
                                                                        FavouriteCubit.get(context)
                                                                            .wishlistModel!
                                                                            .data![
                                                                                index]
                                                                            .descriptionEn!,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontSize:
                                                                              w * 0.035,
                                                                          fontFamily:
                                                                              'Nunito',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .fade)
                                                                    : Text(
                                                                        FavouriteCubit.get(context)
                                                                            .wishlistModel!
                                                                            .data![
                                                                                index]
                                                                            .descriptionAr!,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontSize:
                                                                              w * 0.035,
                                                                          fontFamily:
                                                                              'Almarai',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.fade)),
                                                            SizedBox(
                                                              height: h * 0.005,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text: FavouriteCubit.get(context).wishlistModel!.data![index].price.toString() +
                                                                              " " +
                                                                              currency,
                                                                          style: TextStyle(
                                                                              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                                                                              fontWeight: FontWeight.bold,
                                                                              color: mainColor)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                (FavouriteCubit.get(context)
                                                                            .wishlistModel!
                                                                            .data![index]
                                                                            .hasOffer ==
                                                                        1)
                                                                    ? Text(
                                                                        FavouriteCubit.get(context).wishlistModel!.data![index].beforePrice.toString() +
                                                                            " " +
                                                                            currency,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              w * 0.035,
                                                                          fontFamily: (lang == 'en')
                                                                              ? 'Nunito'
                                                                              : 'Almarai',
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
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
                                  : Center(
                                      child: Text(
                                        LocalKeys.NO_PRODUCT.tr(),
                                        style: TextStyle(
                                            color: mainColor,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.05,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ],
                          ),
                      fallback: (context) => Center(
                            child: CircularProgressIndicator(
                              color: mainColor,
                            ),
                          ));
                },
                listener: (context, state) {})
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/3099609.jpg",
                      height: h * 0.35,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Center(
                    child: Text(
                      LocalKeys.MUST_LOGIN.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: mainColor,
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ));
  }
}
