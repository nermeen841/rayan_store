// ignore_for_file: use_key_in_widget_constructors
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:rayan_store/screens/category/category.dart';
import 'package:rayan_store/screens/searchScreen/componnent/search_history.dart';
import 'package:rayan_store/screens/searchScreen/componnent/searchbody.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String lang = '';
  bool isSearching = false;
  bool login = false;
  TextEditingController search = TextEditingController();
  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      login = preferences.getBool('login') ?? false;
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

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
        appBar: AppBar(
          elevation: 0,
          title: Text(
            LocalKeys.SEARCH.tr(),
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
        body: ListView(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.03),
          primary: true,
          shrinkWrap: true,
          children: [
            TextFormField(
              cursorColor: Colors.black,
              textInputAction: TextInputAction.search,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                if (login) {
                  setState(() {
                    isSearching = true;
                  });
                  if (search.text.isEmpty) {
                    setState(() {
                      isSearching = false;
                    });
                  }
                }
              },
              decoration: InputDecoration(
                focusedBorder: form(),
                enabledBorder: form(),
                errorBorder: form(),
                focusedErrorBorder: form(),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: LocalKeys.SEARCH.tr(),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                ),
              ),
              onChanged: (val) {
                if (login) {
                  setState(() {
                    isSearching = true;
                    search.text = val;
                  });
                  if (search.text.isEmpty) {
                    setState(() {
                      isSearching = false;
                    });
                  }
                }
              },
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Text(
              LocalKeys.CAT.tr(),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: w * 0.035,
                fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            if (login && isSearching) SearchBody(keyword: search.text),
            (login && !isSearching) ? SearchHistory() : Container(),
            if (!login)
              BlocConsumer<HomeCubit, AppCubitStates>(
                  builder: (context, state) {
                    return ConditionalBuilder(
                        condition: state is! HomeitemsLoaedingState,
                        builder: (context) => ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoriesSection(
                                                  mainCatId:
                                                      HomeCubit.get(context)
                                                          .homeitemsModel!
                                                          .data!
                                                          .categories![index]
                                                          .id
                                                          .toString(),
                                                  subCategory:
                                                      HomeCubit.get(context)
                                                          .homeitemsModel!
                                                          .data!
                                                          .categories![index]
                                                          .categoriesSub!,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: w * 0.3,
                                        height: h * 0.09,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    EndPoints.IMAGEURL2 +
                                                        HomeCubit.get(context)
                                                            .homeitemsModel!
                                                            .data!
                                                            .categories![index]
                                                            .imageUrl!),
                                                fit: BoxFit.fitHeight)),
                                      ),
                                      SizedBox(
                                        width: w * 0.03,
                                      ),
                                      Center(
                                        child: (lang == 'en')
                                            ? Text(
                                                HomeCubit.get(context)
                                                    .homeitemsModel!
                                                    .data!
                                                    .categories![index]
                                                    .nameEn!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Nunito',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: w * 0.04),
                                              )
                                            : Text(
                                                HomeCubit.get(context)
                                                    .homeitemsModel!
                                                    .data!
                                                    .categories![index]
                                                    .nameAr!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Almarai',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: w * 0.035),
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: HomeCubit.get(context)
                                .homeitemsModel!
                                .data!
                                .categories!
                                .length),
                        fallback: (context) => Center(
                              child: CircularProgressIndicator(
                                color: mainColor,
                              ),
                            ));
                  },
                  listener: (context, state) {}),
          ],
        ),
      ),
    );
  }

  InputBorder form() {
    double w = MediaQuery.of(context).size.width;
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.white), width: 1),
      borderRadius: BorderRadius.circular(w * 0.01),
    );
  }
}
