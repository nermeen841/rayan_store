// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/screens/favourite_screen/cubit/favourite_cubit.dart';
import 'package:rayan_store/screens/product_detail/model/singleproduct_model.dart';

class FullSliderScreen extends StatefulWidget {
  final List<Images> image;
  final String productId;
  FullSliderScreen({Key? key, required this.image, required this.productId})
      : super(key: key);

  @override
  _FullSliderScreenState createState() => _FullSliderScreenState();
}

class _FullSliderScreenState extends State<FullSliderScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SizedBox(
              width: w,
              height: h,
              child: Swiper(
                pagination: const SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white38, activeColor: Colors.white),
                    alignment: Alignment.bottomCenter),
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(
                            EndPoints.IMAGEURL + widget.image[i].img!),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                },
                itemCount: widget.image.length,
                autoplay: true,
                autoplayDelay: 5000,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.02, vertical: h * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: mainColor,
                    ),
                  ),
                  BlocConsumer<FavouriteCubit, FavouriteState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            FavouriteCubit.get(context)
                                .addtowishlist(productId: widget.productId);
                          },
                          child: (FavouriteCubit.get(context).isFavourite[
                                      int.parse(widget.productId)] ==
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
                      listener: (context, state) {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
