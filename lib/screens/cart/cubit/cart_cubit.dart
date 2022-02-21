// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/DBhelper/cubit.dart';
import 'dart:convert';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/screens/cart/model/delivery.dart';
import 'package:rayan_store/screens/checkout/checkout.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static CartCubit get(context) => BlocProvider.of(context);

  void checkProductQty(
      {required String productId,
      required String productQty,
      required String sizeId,
      required String colorId,
      required BuildContext context}) async {
    emit(CheckProductAddcartLoadingState());
    try {
      Map<String, dynamic> body = {
        'product_id': productId,
        'size_id': sizeId,
        'color_id': colorId,
        'quantity': productQty
      };
      var response = await http.post(Uri.parse(EndPoints.ADD_CART), body: body);
      var data = jsonDecode(response.body);
      print(response.body);
      if (data['status'] == 1) {
        DataBaseCubit.get(context).counter[int.parse(productId)] =
            int.parse(productQty) + 1;
        DataBaseCubit.get(context).updateDatabase(
            productId: int.parse(productId),
            productQty:
                DataBaseCubit.get(context).counter[int.parse(productId)]!);
        emit(CheckProductAddcartSuccessState());
      } else {
        Fluttertoast.showToast(
            msg: "available amount ${data['data']}",
            textColor: Colors.white,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    } catch (error) {
      emit(CheckProductAddcartErroState(error.toString()));
      print("erooooooooooor quantity : " + error.toString());
    }
  }

  void getCheckcobon(
      {required String cobon,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(AddCobonLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cobon', cobon);
    try {
      var response = await http
          .post(Uri.parse(EndPoints.CHECK_COBON + "?coupon_code=$cobon"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Fluttertoast.showToast(
            msg: data['message'].toString(),
            textColor: Colors.white,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        Navigator.pop(context);
        emit(AddCobonSuccessState());
      } else {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Fluttertoast.showToast(
            msg: data['message'].toString(),
            textColor: Colors.white,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        Navigator.pop(context);
        emit(AddCobonSuccessState());
      }
    } catch (error) {
      emit(AddCobonErrorState(error.toString()));
      print("errrrrrrrrrrrrrrrrrrrrrrrrrro " + error.toString());
    }
  }

  DeliveryModel? deliveryModel;
  getDelivery({required BuildContext context}) async {
    emit(DeliveryLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cityId = prefs.getString('city_id').toString();
    try {
      Map<String, dynamic> body = {
        'city': cityId,
        'totalQty': "${DataBaseCubit.get(context).quantity}"
      };
      var response = await http.post(Uri.parse(EndPoints.DELIVERY), body: body);
      var data = jsonDecode(response.body);
      print(response.body);
      print(DataBaseCubit.get(context).quantity.toString());
      if (data['success'] == 1) {
        deliveryModel = DeliveryModel.fromJson(data);
        emit(DeliverySuccessState());
        return deliveryModel;
      }
    } catch (error) {
      emit(DeliveryErroState(error.toString()));
      print("delivery errrrrrrrrrrrrrrrrrrrrrrrrrrrrrro : " + error.toString());
    }
  }

  void saveOrder(
      {required String name,
      required String phone,
      required String email,
      required String address,
      required String note,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(SaveOrderLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lang = prefs.get('language').toString();
    final String lattitude = prefs.getString('late').toString();
    final String longtitude = prefs.getString('lang').toString();
    final String countryId = prefs.getString('country_id').toString();
    final String cityId = prefs.getString('city_id').toString();
    final String cobon = prefs.getString('cobon') ?? '';
    String productId = '';
    DataBaseCubit.get(context).cart.forEach((element) {
      productId += '${element['productId'].toString()}' ',';
    });

    Map<String, dynamic> productsOptions = {};
    DataBaseCubit.get(context).cart.forEach((element) {
      productsOptions.addAll({
        "${element['productId']}": [
          {'height': element['colorOption']},
          {'size': element['sizeOption']},
          {'quantity': element['productQty']}
        ]
      });
    });
    var options = json.encode(productsOptions);
    print(options);
    print(productId);
    try {
      Map<dynamic, dynamic> body = {
        'note': note,
        'name': name,
        'email': email,
        'phone': phone,
        'country_id': countryId,
        'city_id': cityId,
        'address1': address,
        'products_id': productId,
        'optionValue_products': options,
        'lat_and_long': lattitude + ',' + longtitude,
        'coupon_code': cobon,
        'postal_code': "0"
      };
      var response = await http.post(Uri.parse(EndPoints.SAVE_ORDER),
          body: body,
          headers: {
            'Content-Language': lang,
            'auth-token': prefs.getString('token') ?? ''
          });
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmCart(
                      subTotal:
                          DataBaseCubit.get(context).finalPrice.toString(),
                      totalPrice: data['order']['total_price'].toString(),
                    )));
        emit(SaveOrderSuccessState());
      } else {
        controller.error();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
      }
    } catch (error) {
      controller.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      controller.stop();
      emit(SaveOrderErroState(error.toString()));
      print("error while saving order --------------- " + error.toString());
    }
  }
}
