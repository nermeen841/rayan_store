// ignore_for_file: use_key_in_widget_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'category/category.dart';

class SubCategoriesScreen extends StatefulWidget {
  final List catItem;

  const SubCategoriesScreen({Key? key, required this.catItem})
      : super(key: key);
  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          LocalKeys.CAT.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.04,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
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
                badgeContent: Text(
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
        ],
      ),
      body: SizedBox(
        width: w,
        height: h,
        child: ListView.builder(
            itemCount: widget.catItem.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                    padding: EdgeInsets.only(
                      top: h * 0.02,
                      left: h * 0.02,
                      right: h * 0.02,
                      bottom: h * 0.02,
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesSection(
                                    mainCatId:
                                        widget.catItem[index].id.toString(),
                                    subCategory:
                                        widget.catItem[index].categoriesSub,
                                  ))),
                      child: SizedBox(
                          width: w,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: w * 2.5 / 100,
                              ),
                              // Icon(Icons.menu,color: Colors.black,size: w*0.06,),
                              Container(
                                  width: w,
                                  height: h * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(w * 0.05)),
                                  // child: Image.network(categories[i].image,fit: BoxFit.cover,),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(w * 0.05),
                                      child: customCachedNetworkImage(
                                          url: EndPoints.IMAGEURL2 +
                                              widget.catItem[index].imageUrl,
                                          context: context,
                                          fit: BoxFit.cover))),
                              Padding(
                                padding: EdgeInsets.only(top: h * 0.24),
                                child: Container(
                                  height: h * 0.06,
                                  color: Colors.white54,
                                  child: Center(
                                    child: (lang == 'en')
                                        ? Text(
                                            widget.catItem[index].nameEn,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Nunito',
                                                fontSize: w * 0.05,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            widget.catItem[index].nameAr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Almarai',
                                                fontSize: w * 0.05,
                                                fontWeight: FontWeight.w600),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )),
              );
            }),
      ),
    );
  }
}
