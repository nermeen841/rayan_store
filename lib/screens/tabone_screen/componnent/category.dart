// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/screens/category/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySection extends StatefulWidget {
  final List catItem;

  const CategorySection({Key? key, required this.catItem}) : super(key: key);
  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
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
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: w,
      height: h * 0.5,
      child: GridView.builder(
        primary: true,
        itemCount: widget.catItem.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.2)),
                margin: EdgeInsets.all(w * 0.01),
                alignment: Alignment.center,
                child: InkWell(
                  child: Container(
                    width: w * 0.7,
                    height: h * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                            EndPoints.IMAGEURL2 +
                                widget.catItem[index].imageUrl,
                          ),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesSection(
                                  mainCatId:
                                      widget.catItem[index].id.toString(),
                                  subCategory:
                                      widget.catItem[index].categoriesSub,
                                )));
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: (lang == 'en')
                    ? Text(
                        widget.catItem[index].nameEn,
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            color: Colors.black,
                            fontSize: w * 0.04),
                        overflow: TextOverflow.clip,
                      )
                    : Text(
                        widget.catItem[index].nameAr,
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                            color: Colors.black,
                            fontSize: w * 0.04),
                        overflow: TextOverflow.clip,
                      ),
              )
            ],
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: h * 0.001,
            mainAxisSpacing: w * 0.015),
      ),
    );
  }
}
