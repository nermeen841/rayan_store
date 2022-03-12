// ignore_for_file: non_constant_identifier_names
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/appState.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/category/category.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';

class AppBarHome {
  late int currentindex;

  static PreferredSizeWidget app_bar_home(BuildContext context,
      {required String lang}) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      title: InkWell(
        onTap: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(index: 2))),
        child: Container(
          width: w * 0.8,
          height: w * 0.1,
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black38),
              color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/icons/search.png"),
              SizedBox(
                width: w * 0.02,
              ),
              Center(
                child: Text(
                  LocalKeys.SEARCH.tr(),
                  style: TextStyle(
                      fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                      fontSize: w * 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: w * 0.01),
          child: Padding(
            padding: const EdgeInsets.all(5),
            // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
            child: Badge(
              badgeColor: mainColor,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                padding: EdgeInsets.zero,
                focusColor: Colors.white,
                onPressed: () {},
              ),
              animationDuration: const Duration(
                seconds: 2,
              ),
              badgeContent: Text(
                "0",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.03,
                ),
              ),
              position: BadgePosition.topStart(start: w * 0.03, top: h * 0.001),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.01),
            child: BlocConsumer<DataBaseCubit, DatabaseStates>(
                builder: (context, state) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: Badge(
                        badgeColor: mainColor,
                        child: InkWell(
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.black,
                          ),
                          focusColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Cart()));
                          },
                        ),
                        animationDuration: const Duration(
                          seconds: 2,
                        ),
                        badgeContent:
                            (DataBaseCubit.get(context).cart.isNotEmpty)
                                ? Text(
                                    DataBaseCubit.get(context)
                                        .cart
                                        .length
                                        .toString(),
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
                        position: BadgePosition.topStart(start: w * 0.002),
                      ),
                    ),
                listener: (context, state) {})),
      ],
      bottom: PreferredSize(
          preferredSize: Size(w, h * 0.07),
          child: BlocConsumer<HomeCubit, AppCubitStates>(
              builder: (context, state) {
                return ConditionalBuilder(
                    condition: state is! HomeitemsLoaedingState,
                    builder: (context) => Container(
                          width: w,
                          height: h * 0.07,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: h * 0.01, horizontal: w * 0.05),
                          child: ListView.separated(
                              primary: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoriesSection(
                                                    subCategory:
                                                        HomeCubit.get(context)
                                                            .homeitemsModel!
                                                            .data!
                                                            .categories![index]
                                                            .categoriesSub!,
                                                    mainCatId:
                                                        HomeCubit.get(context)
                                                            .homeitemsModel!
                                                            .data!
                                                            .categories![index]
                                                            .id
                                                            .toString(),
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: h * 0.01,
                                          horizontal: w * 0.05),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 3),
                                                spreadRadius: 3,
                                                blurRadius: 3,
                                                color: Colors.grey
                                                    .withOpacity(0.1))
                                          ],
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: (lang == 'en')
                                            ? Text(
                                                HomeCubit.get(context)
                                                    .homeitemsModel!
                                                    .data!
                                                    .categories![index]
                                                    .nameEn!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: w * 0.04,
                                                    color: Colors.black,
                                                    fontFamily: 'Nunito'),
                                              )
                                            : Text(
                                                HomeCubit.get(context)
                                                    .homeitemsModel!
                                                    .data!
                                                    .categories![index]
                                                    .nameAr!,
                                                style: TextStyle(
                                                    fontSize: w * 0.04,
                                                    color: Colors.black,
                                                    fontFamily: 'Almarai'),
                                              ),
                                      ),
                                    ),
                                  ),
                              separatorBuilder: (context, index) => SizedBox(
                                    width: w * 0.04,
                                  ),
                              itemCount: HomeCubit.get(context)
                                  .homeitemsModel!
                                  .data!
                                  .categories!
                                  .length),
                        ),
                    fallback: (context) => Container());
              },
              listener: (context, state) {})),
    );
  }
}
