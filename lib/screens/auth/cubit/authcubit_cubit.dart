// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/auth/cubit/forgetpass_firebase.dart';
import 'package:rayan_store/screens/auth/login.dart';
import 'package:rayan_store/screens/auth/model/checkphone_model.dart';
import 'package:rayan_store/screens/bottomnav/homeScreen.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rayan_store/splash.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constant.dart';
part 'authcubit_state.dart';

class AuthcubitCubit extends Cubit<AuthcubitState> {
  AuthcubitCubit() : super(AuthcubitInitialState());
  static AuthcubitCubit get(context) => BlocProvider.of(context);

  void login(
      {required RoundedLoadingButtonController controller,
      required String email,
      required String password,
      required BuildContext context}) async {
    emit(LoginLoadingState());
    String datamess = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String deviceToken = prefs.get('davice_token').toString();
    final String lang = prefs.get('language').toString();
    try {
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'device_token': deviceToken
      };
      var response = await http.post(Uri.parse(EndPoints.LOGIN),
          body: body, headers: {'Content-Language': lang});
      var data = jsonDecode(response.body);
      print("------------------------------------" + email);
      if (email == '') {
        data['email'].forEach((e) {
          datamess += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(datamess),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (response.statusCode == 200 && data['user'] != null) {
        UserprofileCubit().getUserProfile();
        prefs.setString('token', data['access_token'].toString());
        prefs.setBool('login', true);
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      index: 0,
                    )),
            (route) => false);
        emit(LoginSuccessState());
      } else if (data['status'] == 0) {
        final snackBar = SnackBar(
          content: Text(data['message']),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      emit(LoginErrorState(err.toString()));
      print("login errrrrrrrrrrrr" + err.toString());
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////

  void register(
      {required RoundedLoadingButtonController controller,
      required String email,
      required String password,
      required String name,
      required String phone,
      required String confirmpassword,
      required BuildContext context}) async {
    emit(RegisterLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lang = prefs.get('language').toString();
    String errorMess = '';
    try {
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmpassword,
        'phone': phone
      };
      var response = await http.post(Uri.parse(EndPoints.REGISTER),
          body: body, headers: {'Content-Language': lang});
      var data = jsonDecode(response.body);
      if (data['status'] == 0 && response.statusCode == 200) {
        data['message'].forEach((e) {
          errorMess += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(errorMess),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        prefs.setString('token', data['access_token'].toString());
        UserprofileCubit().getUserProfile();
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        fireSms(context: context, phone: phone, btnController: controller);
        emit(RegisterSuccessState());
      }
    } catch (error) {
      emit(RegisterErrorState(error.toString()));
      print("register error ---------------------------------------" +
          error.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////
  CheckPhoneModel? checkPhoneModel;
  void checkPhone(
      {required BuildContext context,
      required RoundedLoadingButtonController controller,
      required String phone}) async {
    try {
      Map<String, dynamic> body = {
        'phone': phone,
      };

      var response =
          await http.post(Uri.parse(EndPoints.CHECK_PHONE), body: body);
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        checkPhoneModel = CheckPhoneModel.fromJson(data);
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        fireSmsResetPass(context, phone, controller);
        emit(CheckPhoneSuccessState());
      } else {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
      }
    } catch (error) {
      emit(CheckPhoneErrorState(error.toString()));
      print("phone check errrrrrrrrrrrrrrrrrrrr " + error.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////

  void logout({required BuildContext context}) async {
    emit(LogoutLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    try {
      var response = await http
          .post(Uri.parse(EndPoints.LOG_OUT), headers: {'auth-token': token});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == false) {
        print(data['msg']);
      } else if (response.statusCode == 200) {
        prefs.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false);
        emit(LogoutSuccessState());
      }
    } catch (error) {
      emit(LogoutErrorState(error.toString()));
      print("log out errrrrrrrrrrrrrrr" + error.toString());
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////

  void forgetPass(
      {required String password,
      required BuildContext context,
      required RoundedLoadingButtonController controller}) async {
    emit(ForgetpasswordLoadingState());
    String errorMess = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token').toString();
    final String lang = prefs.get('language').toString();
    try {
      Map<String, dynamic> body = {
        'user_id': checkPhoneModel!.data!.id.toString(),
        'password': password
      };
      var response = await http.post(Uri.parse(EndPoints.FORGET_PASS),
          body: body, headers: {'auth-token': token, 'Content-Language': lang});
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        data['message'].forEach((e) {
          errorMess += e + '\n';
        });
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        final snackBar = SnackBar(
          content: Text(errorMess),
          action: SnackBarAction(
            label: LocalKeys.UNDO.tr(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        controller.success();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      }
      emit(ForgetpasswordSuccessState());
    } catch (err) {
      emit(ForgetpasswordErrorState(err.toString()));
      print("forget password error --------------------- " + err.toString());
    }
  }
}
