// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/allproducts/new_product/new_product.dart';
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/section_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProducts extends StatefulWidget {
  final List newItem;

  const NewProducts({Key? key, required this.newItem}) : super(key: key);
  @override
  _NewProductsState createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  String lang = '';
  String currency = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      currency = preferences.getString('currency').toString();
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
    return Column(
      children: [
        SectionTitle(
            title: LocalKeys.HOME_NEW.tr(),
            press: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewProductScreen()))),
        SizedBox(
          height: h * 0.02,
        ),
        Container(
          width: w,
          height: h * 0.39,
          color: Colors.white,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: h * 0.01, horizontal: w * 0.01),
                    child: InkWell(
                      onTap: () {
                        HomeCubit.get(context).getProductdata(
                            productId: widget.newItem[index].id.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetail()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: w * 0.45,
                            height: h * 0.28,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(EndPoints.IMAGEURL2 +
                                        widget.newItem[index].img.toString()),
                                    fit: BoxFit.fitHeight)),
                          ),
                          SizedBox(
                            width: w * 0.45,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: h * 0.07,
                                  ),
                                  child: (lang == 'en')
                                      ? Text(widget.newItem[index].titleEn,
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontFamily: 'Nunito',
                                          ),
                                          overflow: TextOverflow.fade)
                                      : Text(
                                          widget.newItem[index].titleAr,
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontFamily: 'Almarai',
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                ),
                                SizedBox(
                                  height: h * 0.005,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: h * 0.07,
                                  ),
                                  child: (lang == 'en')
                                      ? Text(
                                          widget.newItem[index].descriptionEn,
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              color: Colors.grey),
                                          overflow: TextOverflow.fade)
                                      : Text(
                                          widget.newItem[index].descriptionAr,
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              color: Colors.grey),
                                          overflow: TextOverflow.fade),
                                ),
                                SizedBox(
                                  height: h * 0.005,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.newItem[index].price.toString() +
                                          " " +
                                          currency,
                                      style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        color: mainColor,
                                      ),
                                    ),
                                    (widget.newItem[index].hasOffer == 1)
                                        ? Text(
                                            widget.newItem[index].beforePrice
                                                    .toString() +
                                                " " +
                                                currency,
                                            style: TextStyle(
                                                fontSize: w * 0.035,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                decorationColor: mainColor),
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
                  ),
              separatorBuilder: (context, index) => SizedBox(
                    width: w * 0.03,
                  ),
              itemCount: widget.newItem.length),
        ),
      ],
    );
  }
}
