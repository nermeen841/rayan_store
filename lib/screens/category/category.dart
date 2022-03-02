// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'componnent/body.dart';

class CategoriesSection extends StatefulWidget {
  final List subCategory;
  final String mainCatId;

  const CategoriesSection(
      {Key? key, required this.subCategory, required this.mainCatId})
      : super(key: key);
  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection>
    with SingleTickerProviderStateMixin {
  int selectedSubCat = 0;
  String subCatId = "0";
  TabController? tabController;
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
    tabController =
        TabController(length: widget.subCategory.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            LocalKeys.CAT.tr(),
            style: TextStyle(color: Colors.white, fontSize: w * 0.04),
          ),
          centerTitle: true,
          backgroundColor: mainColor,
          leading: const BackButton(
            color: Colors.white,
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
          ],
          bottom: PreferredSize(
            preferredSize: Size(w, h * 0.06),
            child: Container(
              height: h * 0.06 + 10,
              width: w,
              padding: const EdgeInsets.only(top: 10),
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                controller: tabController,
                indicatorColor: Colors.pinkAccent[200],
                indicatorWeight: w * 0.01,
                labelColor: mainColor,
                unselectedLabelColor: Colors.black45,
                labelStyle: TextStyle(
                  color: mainColor,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.black45,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                ),
                tabs: List.generate(
                  widget.subCategory.length,
                  (index) => Center(
                    child: (lang == 'en')
                        ? Text(
                            widget.subCategory[index].nameEn,
                          )
                        : Text(
                            widget.subCategory[index].nameAr,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: w * 0.025),
          child: SizedBox(
              width: w,
              height: h,
              child: (widget.subCategory.isNotEmpty)
                  ? TabBarView(
                      controller: tabController,
                      children: List.generate(
                          widget.subCategory.length,
                          (index) => CategoryProducts(
                              subCatId:
                                  widget.subCategory[index].id.toString())))
                  : CategoryProducts(
                      subCatId: widget.mainCatId.toString(),
                    )),
        ),
      ),
    );
  }
}
