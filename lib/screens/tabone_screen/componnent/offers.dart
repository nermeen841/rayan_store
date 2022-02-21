// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/allproducts/all_offers/all_offers.dart';
import 'package:rayan_store/screens/product_detail/product_detail.dart';
import 'package:rayan_store/screens/tabone_screen/componnent/section_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Offers extends StatefulWidget {
  final List offersItem;

  const Offers({Key? key, required this.offersItem}) : super(key: key);
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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
        SizedBox(
          height: h * 0.02,
        ),
        SectionTitle(
            title: LocalKeys.HOME_OFFER.tr(),
            press: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllOffersScreen()))),
        SizedBox(
          height: h * 0.02,
        ),
        Container(
          width: w,
          height: h * 0.34,
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
                            productId: widget.offersItem[index].id.toString());
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
                            width: w * 0.5,
                            height: h * 0.2,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(EndPoints.IMAGEURL2 +
                                        widget.offersItem[index].img),
                                    fit: BoxFit.fitWidth)),
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
                                      ? Text(widget.offersItem[index].titleEn,
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: 'Nunito'),
                                          overflow: TextOverflow.fade)
                                      : Text(widget.offersItem[index].titleAr,
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontFamily: 'Almarai',
                                          ),
                                          overflow: TextOverflow.fade),
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
                                          widget
                                              .offersItem[index].descriptionEn,
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: 'Nunito',
                                              color: Colors.grey),
                                          overflow: TextOverflow.fade)
                                      : Text(
                                          widget
                                              .offersItem[index].descriptionAr,
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontFamily: 'Almarai',
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${widget.offersItem[index].price}'
                                                          " " +
                                                      currency,
                                              style: TextStyle(
                                                  fontFamily: (lang == 'en')
                                                      ? 'Nunito'
                                                      : 'Almarai',
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor)),
                                        ],
                                      ),
                                    ),
                                    (widget.offersItem[index].hasOffer == 1)
                                        ? Text(
                                            '${widget.offersItem[index].beforePrice}'
                                                    " " +
                                                currency,
                                            style: TextStyle(
                                              fontSize: w * 0.035,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: mainColor,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              color: Colors.grey,
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
                  ),
              separatorBuilder: (context, index) => SizedBox(
                    width: w * 0.03,
                  ),
              itemCount: widget.offersItem.length),
        ),
      ],
    );
  }
}
