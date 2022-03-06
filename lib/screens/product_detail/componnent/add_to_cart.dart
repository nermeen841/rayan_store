import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/app_cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/favourite_screen/cubit/favourite_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

addtoCartHeader(
    {required double w,
    required double h,
    required context,
    required String lang,
    required String currency,
    required int count}) {
  return BlocConsumer<HomeCubit, AppCubitStates>(
    listener: (context, state) {},
    builder: (context, state) => Padding(
      padding: EdgeInsets.only(top: h * 0.84),
      child: Container(
        width: w,
        height: h * 0.12,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: w * 0.01, vertical: h * 0.01),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Center(
                child: Text(
                  LocalKeys.DETAIL_TITLE.tr(),
                  style: TextStyle(
                    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                    fontSize: w * 0.04,
                    color: mainColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.014),
                    child: Text(
                      "${HomeCubit.get(context).singleProductModel!.data!.price!}"
                              " " +
                          currency,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.05),
                    ),
                  ),
                  BlocConsumer<DataBaseCubit, DatabaseStates>(
                      builder: (context, state) => InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (DataBaseCubit.get(context).isexist[
                                      HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .id] ==
                                  true) {
                                DataBaseCubit.get(context).deletaFromDB(
                                    id: HomeCubit.get(context)
                                        .singleProductModel!
                                        .data!
                                        .id!);
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.red,
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG,
                                    msg: LocalKeys.REMOVE_ITEM.tr());
                              } else {
                                if (AppCubit.get(context).colorselected ==
                                        null ||
                                    AppCubit.get(context).sizeselected ==
                                        null) {
                                  Fluttertoast.showToast(
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_LONG,
                                      msg: LocalKeys.ATTRIBUTES.tr());
                                } else {
                                  DataBaseCubit.get(context).inserttoDatabase(
                                      sizeOption: int.parse(prefs
                                          .getString('sizeOption')
                                          .toString()),
                                      colorOption: int.parse(prefs
                                          .getString('colorOption')
                                          .toString()),
                                      productId: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .id!,
                                      productNameEn: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .titleEn!,
                                      productNameAr: HomeCubit.get(context)
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
                                      productQty: count,
                                      productPrice: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .price,
                                      productImg: HomeCubit.get(context)
                                          .singleProductModel!
                                          .data!
                                          .img!,
                                      sizeId: int.parse(prefs
                                          .getString('size_id')
                                          .toString()),
                                      colorId: int.parse(prefs
                                          .getString('color_id')
                                          .toString()));
                                  Fluttertoast.showToast(
                                      backgroundColor: Colors.black,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_LONG,
                                      msg: LocalKeys.ADD_CAR.tr());
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Cart()));
                                }
                              }
                            },
                            child: Container(
                              width: w * 0.6,
                              height: h * 0.055,
                              color: Colors.black,
                              child: Center(
                                child: (DataBaseCubit.get(context).isexist[
                                            HomeCubit.get(context)
                                                .singleProductModel!
                                                .data!
                                                .id!] ==
                                        true)
                                    ? Text(
                                        LocalKeys.REMOVE_CART.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontWeight: FontWeight.bold,
                                            fontSize: w * 0.05),
                                      )
                                    : Text(
                                        LocalKeys.ADD_CART.tr(),
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
                      listener: (context, state) {})
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//////////////////////////////////////////////////////////////////////////////////////////

sizeColorSelection(
    {required context,
    required double h,
    required double w,
    required String productId,
    required List size,
    required String lang}) {
  return BlocConsumer<HomeCubit, AppCubitStates>(
      builder: (context, state) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocalKeys.SIZE.tr(),
                    style: TextStyle(
                        fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: w * 0.04,
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
                                      fontFamily:
                                          (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontSize: w * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                              BlocConsumer<AppCubit, AppCubitStates>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                        primary: true,
                                        shrinkWrap: true,
                                        itemCount: size.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: h * 0.02),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Radio(
                                                    activeColor: mainColor,
                                                    value: index,
                                                    groupValue:
                                                        AppCubit.get(context)
                                                            .sizeselected,
                                                    onChanged: (value) async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.setString(
                                                        'size_id',
                                                        size[index]
                                                            .id
                                                            .toString(),
                                                      );
                                                      prefs.setString(
                                                          'sizeOption',
                                                          size[index]
                                                              .pivot!
                                                              .id
                                                              .toString());
                                                      AppCubit.get(context)
                                                          .sizeselected = index;
                                                      AppCubit.get(context)
                                                              .sizeTitleselected =
                                                          size[index].name!;
                                                      AppCubit.get(context)
                                                          .sizeSelection(
                                                              selected: index,
                                                              title: size[index]
                                                                  .name!);
                                                      HomeCubit.get(context)
                                                          .getProductColor(
                                                        context: context,
                                                        productId: productId,
                                                        sizeId: size[index]
                                                            .id
                                                            .toString(),
                                                      );
                                                      Navigator.pop(context);
                                                    }),
                                                Text(
                                                  size[index].name!,
                                                  style: TextStyle(
                                                      fontFamily: (lang == 'en')
                                                          ? 'Nunito'
                                                          : 'Almarai',
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey),
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
                        BlocConsumer<AppCubit, AppCubitStates>(
                          builder: (context, state) =>
                              (AppCubit.get(context).sizeTitleselected != null)
                                  ? Text(
                                      AppCubit.get(context)
                                          .sizeTitleselected
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    )
                                  : Container(),
                          listener: (context, state) {},
                        ),
                        SizedBox(
                          width: w * 0.02,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocalKeys.COLOR.tr(),
                    style: TextStyle(
                        fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: w * 0.04,
                  ),
                  InkWell(
                    onTap: () {
                      homeBottomSheet(
                          context: context,
                          child: BlocConsumer<HomeCubit, AppCubitStates>(
                              builder: (context, state) {
                                return ConditionalBuilder(
                                  condition:
                                      state is! SingleProductColorLoaedingState,
                                  builder: (context) => Column(
                                    children: [
                                      SizedBox(
                                        height: h * 0.03,
                                      ),
                                      Center(
                                        child: Text(
                                          LocalKeys.COLOR.tr(),
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: w * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.02,
                                      ),
                                      BlocConsumer<AppCubit, AppCubitStates>(
                                          builder: (context, state) {
                                            return ListView.builder(
                                                primary: true,
                                                shrinkWrap: true,
                                                itemCount: HomeCubit.get(
                                                        context)
                                                    .singleProductColorModel!
                                                    .data!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                                .colorselected,
                                                            onChanged:
                                                                (value) async {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.setString(
                                                                  'color_id',
                                                                  HomeCubit.get(
                                                                          context)
                                                                      .singleProductColorModel!
                                                                      .data![
                                                                          index]
                                                                      .heightId
                                                                      .toString());
                                                              prefs.setString(
                                                                  'colorOption',
                                                                  HomeCubit.get(
                                                                          context)
                                                                      .singleProductColorModel!
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                              AppCubit.get(
                                                                          context)
                                                                      .colorselected =
                                                                  index;
                                                              AppCubit.get(
                                                                      context)
                                                                  .colorTitleselected = HomeCubit
                                                                      .get(
                                                                          context)
                                                                  .singleProductColorModel!
                                                                  .data![index]
                                                                  .name!;
                                                              AppCubit.get(context).colorSelection(
                                                                  selected:
                                                                      index,
                                                                  title: HomeCubit
                                                                          .get(
                                                                              context)
                                                                      .singleProductColorModel!
                                                                      .data![
                                                                          index]
                                                                      .name!);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        Text(
                                                          HomeCubit.get(context)
                                                              .singleProductColorModel!
                                                              .data![index]
                                                              .name!,
                                                          style: TextStyle(
                                                              fontFamily: (lang ==
                                                                      'en')
                                                                  ? 'Nunito'
                                                                  : 'Alamarai',
                                                              fontSize:
                                                                  w * 0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          listener: (context, state) {})
                                    ],
                                  ),
                                  fallback: (context) => Center(
                                    child: CircularProgressIndicator(
                                      color: mainColor,
                                    ),
                                  ),
                                );
                              },
                              listener: (context, state) {}));
                    },
                    child: Row(
                      children: [
                        BlocConsumer<AppCubit, AppCubitStates>(
                            builder: (context, state) =>
                                (AppCubit.get(context).colorTitleselected !=
                                        null)
                                    ? Text(
                                        AppCubit.get(context)
                                            .colorTitleselected
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      )
                                    : Container(),
                            listener: (context, state) {}),
                        SizedBox(
                          width: w * 0.02,
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
            ],
          ),
      listener: (context, state) {});
}

///////////////////////////////////////////////////////////////////////////////////////////////

favouriteButton(
    {required context, required bool login, required String productId}) {
  return BlocConsumer<FavouriteCubit, FavouriteState>(
    builder: (context, state) {
      return InkWell(
        onTap: () {
          if (login) {
            FavouriteCubit.get(context).addtowishlist(productId: productId);
          } else {
            Fluttertoast.showToast(
                msg: LocalKeys.MUST_LOGIN.tr(),
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
          }
        },
        child: (FavouriteCubit.get(context).isFavourite[int.parse(productId)] ==
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
    listener: (context, state) {},
  );
}
