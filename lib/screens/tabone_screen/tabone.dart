// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/all_categories.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/bestsellers.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/newproducts.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/offers.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/section_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'componnent/appbar.dart';
import 'componnent/category.dart';

class TaboneScreen extends StatefulWidget {
  @override
  _TaboneScreenState createState() => _TaboneScreenState();
}

class _TaboneScreenState extends State<TaboneScreen> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  final Geolocator geolocator = Geolocator();
  late Position currentPosition;
  late String currentAddress;
  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {}

    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) async {
      setState(() {
        currentPosition = position;
      });
      SharedPreferences pres = await SharedPreferences.getInstance();
      pres.setString('late', position.altitude.toString());
      pres.setString('lang', position.longitude.toString());
      print("lattitude ................. : " + position.altitude.toString());
      print("longtitude ................. : " + position.longitude.toString());
    }).catchError((e) {
      print("location errrrrrrrrrrrrrrrrrrrrrrrr : " + e.toString());
    });
  }

  @override
  void initState() {
    getLang();
    getCurrentLocation();
    DataBaseCubit.get(context).cart.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarHome.app_bar_home(context, lang: lang),
        body: BlocConsumer<HomeCubit, AppCubitStates>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! HomeitemsLoaedingState,
                  builder: (context) => ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            width: w,
                            height: h * 0.3,
                            child: Swiper(
                              pagination: SwiperPagination(
                                  builder: DotSwiperPaginationBuilder(
                                      color: mainColor.withOpacity(0.3),
                                      activeColor: mainColor),
                                  alignment: Alignment.bottomCenter),
                              itemBuilder: (BuildContext context, int i) {
                                return InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            EndPoints.IMAGEURL2 +
                                                HomeCubit.get(context)
                                                    .homeitemsModel!
                                                    .data!
                                                    .sliders![i]
                                                    .img!),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  // overlayColor: ,
                                  onTap: () async {},
                                );
                              },
                              itemCount: HomeCubit.get(context)
                                  .homeitemsModel!
                                  .data!
                                  .sliders!
                                  .length,
                              autoplay: true,
                              autoplayDelay: 5000,
                            ),
                          ),
                          SizedBox(
                            height: h * 0.025,
                          ),
                          SectionTitle(
                              title: LocalKeys.HOME_CAT.tr(),
                              press: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubCategoriesScreen(
                                            catItem: HomeCubit.get(context)
                                                .homeitemsModel!
                                                .data!
                                                .categories!,
                                          )))),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          CategorySection(
                            catItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .categories!,
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          NewProducts(
                            newItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .newArrive!,
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          BestSellers(
                            bestItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .bestSell!,
                          ),
                          Offers(
                            offersItem: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .offers!,
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
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
