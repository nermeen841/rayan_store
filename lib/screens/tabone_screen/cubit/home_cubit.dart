// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/app_cubit/appstate.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/screens/product_detail/model/productcolor_model.dart';
import 'package:rayan_store/screens/product_detail/model/singleproduct_model.dart';
import 'package:rayan_store/screens/tabone_screen/model/home_model.dart';

class HomeCubit extends Cubit<AppCubitStates> {
  HomeCubit() : super(AppInitialstates());

  static HomeCubit get(context) => BlocProvider.of(context);

  HomeitemsModel? homeitemsModel;
  void getHomeitems() async {
    emit(HomeitemsLoaedingState());
    try {
      var response = await http.get(Uri.parse(EndPoints.HOME_ITEMS));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        homeitemsModel = HomeitemsModel.fromJson(data);
      }
      emit(HomeitemsSuccessState());
    } catch (error) {
      print("error while get home data =================================" +
          error.toString());
      emit(HomeitemsErrorState(error.toString()));
    }
  }

  SingleProductModel? singleProductModel;

  void getProductdata({required String productId}) async {
    emit(SingleProductLoaedingState());
    try {
      var response = await http
          .get(Uri.parse(EndPoints.BASE_URL + "get-product/$productId"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        singleProductModel = SingleProductModel.fromJson(data);
      }
      emit(SingleProductSuccessState());
    } catch (error) {
      print("error while get home data =================================" +
          error.toString());
      emit(SingleProductErrorState(error.toString()));
    }
  }

  SingleProductColorModel? singleProductColorModel;
  void getProductColor(
      {required String productId,
      required String sizeId,
      required BuildContext context}) async {
    emit(SingleProductColorLoaedingState());
    try {
      var response = await http
          .get(Uri.parse(EndPoints.PRODUCT_COLOR + "$productId/$sizeId"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        singleProductColorModel = SingleProductColorModel.fromJson(data);
      }
      emit(SingleProductColorSuccessState());
    } catch (error) {
      print("error while get product color =================================" +
          error.toString());
      emit(SingleProductColorErrorState(error.toString()));
    }
  }
}
