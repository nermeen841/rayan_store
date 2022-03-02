// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/app_cubit/app_cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/about_us/about_us.dart';
import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
import 'package:rayan_store/screens/auth/login.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:rayan_store/screens/change_password/change_password.dart';
import 'package:rayan_store/screens/orders/cubit/order_cubit.dart';
import 'package:rayan_store/screens/orders/orders.dart';
import 'package:rayan_store/screens/profile/componnent/profileitem.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rayan_store/screens/update_profile/update_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'componnent/user_lang.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? selected;
  String lang = '';
  bool isLogin = false;

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      isLogin = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  List<String> icons = [
    "assets/about.png",
    "assets/payment.png",
    "assets/terms.png",
    "assets/delivery.png",
    "assets/exchange (2).png",
    "assets/terms (2).png",
    "assets/icons/Group 19.png",
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<UserprofileCubit, UserprofileState>(
              builder: (context, state) {
                return ConditionalBuilder(
                    condition: state is! GetAllInfoLoadinState,
                    builder: (context) => ListView(
                          primary: true,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              vertical: h * 0.03, horizontal: w * 0.03),
                          children: [
                            SizedBox(
                              height: h * 0.04,
                            ),
                            (isLogin)
                                ? Center(
                                    child: BlocConsumer<AppCubit,
                                            AppCubitStates>(
                                        builder: (context, state) => Stack(
                                              children: [
                                                Center(
                                                  child: (AppCubit.get(context)
                                                              .image ==
                                                          null)
                                                      ? CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          radius: w * 0.15,
                                                          backgroundImage:
                                                              const AssetImage(
                                                                  "assets/icons/successful-business-woman.jpg"),
                                                        )
                                                      : CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          radius: w * 0.15,
                                                          backgroundImage:
                                                              FileImage(
                                                            AppCubit.get(
                                                                    context)
                                                                .image!,
                                                          ),
                                                        ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: h * 0.1,
                                                      left: w * 0.35,
                                                      right: w * 0.12),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomCenter,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        AppCubit.get(context)
                                                            .getImage();
                                                      },
                                                      child: CircleAvatar(
                                                        radius: w * 0.04,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Image.asset(
                                                            "assets/icons/Path-20.png"),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                        listener: (context, state) {}))
                                : Container(),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            (isLogin)
                                ? ProfileItem(
                                    press: () {
                                      OrderCubit.get(context).getAllorders();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Orders()));
                                    },
                                    title: LocalKeys.MY_ORDERS.tr(),
                                    image: "assets/icons/Group 15.png")
                                : Container(),
                            (isLogin)
                                ? ProfileItem(
                                    press: () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(index: 1)),
                                        (route) => false),
                                    title: LocalKeys.MY_FAV.tr(),
                                    image: "assets/icons/Group 14.png")
                                : Container(),
                            ProfileItem(
                                press: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserLanguageSelection())),
                                title: LocalKeys.LANG.tr(),
                                image: "assets/icons/Group 16.png"),
                            (isLogin)
                                ? ProfileItem(
                                    press: () {
                                      homeBottomSheet(
                                          context: context,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                                Center(
                                                  child: Text(
                                                    LocalKeys.DELIVERY_ADDRESS
                                                        .tr(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            (lang == 'en')
                                                                ? 'Nunito'
                                                                : 'Almarai',
                                                        fontSize: w * 0.05,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                          itemCount: 5,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          h * 0.02),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Radio(
                                                                      activeColor:
                                                                          mainColor,
                                                                      value:
                                                                          index,
                                                                      groupValue:
                                                                          AppCubit.get(context)
                                                                              .addressselected,
                                                                      onChanged:
                                                                          (value) {
                                                                        AppCubit.get(context).addressselected =
                                                                            index;
                                                                        AppCubit.get(context).addressSelection(
                                                                            selected:
                                                                                index);
                                                                      }),
                                                                  Text(
                                                                      "kuwait , hawly ibn khaldon street, ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily: (lang ==
                                                                                'en')
                                                                            ? 'Nunito'
                                                                            : 'Almarai',
                                                                        fontSize:
                                                                            w * 0.04,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    listener:
                                                        (context, state) {}),
                                                SizedBox(
                                                  height: h * 0.03,
                                                ),
                                              ],
                                            ),
                                          ));
                                    },
                                    title: LocalKeys.MY_ADD.tr(),
                                    image: "assets/icons/Group 17.png")
                                : Container(),
                            (isLogin)
                                ? BlocConsumer<UserprofileCubit,
                                        UserprofileState>(
                                    builder: (context, state) {
                                      return ConditionalBuilder(
                                        condition:
                                            state is! GetProfileLoadingState,
                                        builder: (context) => ProfileItem(
                                            press: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            UpdateProfile(
                                                              userEmail: UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .userModel!
                                                                  .email
                                                                  .toString(),
                                                              userName: UserprofileCubit
                                                                      .get(
                                                                          context)
                                                                  .userModel!
                                                                  .name
                                                                  .toString(),
                                                            ))),
                                            title:
                                                LocalKeys.UPDATE_PROFILE.tr(),
                                            image: "assets/icons/Group 18.png"),
                                        fallback: (context) => Container(),
                                      );
                                    },
                                    listener: (context, state) {})
                                : Container(),
                            (isLogin)
                                ? ProfileItem(
                                    press: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePass())),
                                    title: LocalKeys.CHANGE_PASS_TITLE.tr(),
                                    image: "assets/icons/Group 18.png")
                                : Container(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                UserprofileCubit.get(context)
                                    .allinfoModel!
                                    .data!
                                    .length,
                                (index) => ProfileItem(
                                    press: () {
                                      UserprofileCubit.get(context)
                                          .getSingleInfo(
                                              infoItemId:
                                                  UserprofileCubit.get(context)
                                                      .allinfoModel!
                                                      .data![index]
                                                      .id
                                                      .toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AboutUs(
                                                  (lang == 'en')
                                                      ? UserprofileCubit.get(
                                                              context)
                                                          .allinfoModel!
                                                          .data![index]
                                                          .pageTitleEn!
                                                      : UserprofileCubit.get(
                                                              context)
                                                          .allinfoModel!
                                                          .data![index]
                                                          .pageTitleAr!)));
                                    },
                                    title: (lang == 'en')
                                        ? UserprofileCubit.get(context)
                                            .allinfoModel!
                                            .data![index]
                                            .pageTitleEn!
                                        : UserprofileCubit.get(context)
                                            .allinfoModel!
                                            .data![index]
                                            .pageTitleAr!,
                                    image: icons[index]),
                              ),
                            ),
                            BlocConsumer<AuthcubitCubit, AuthcubitState>(
                                builder: (context, state) {
                                  return ProfileItem(
                                      press: () async {
                                        if (isLogin) {
                                          AuthcubitCubit.get(context)
                                              .logout(context: context);
                                        } else {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()),
                                              (route) => false);
                                        }
                                      },
                                      title: (isLogin)
                                          ? LocalKeys.LOG_OUT.tr()
                                          : LocalKeys.LOG_IN.tr(),
                                      image: "assets/icons/Group 21.png");
                                },
                                listener: (context, state) {}),
                          ],
                        ),
                    fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ));
              },
              listener: (context, state) {})),
    );
  }
}
