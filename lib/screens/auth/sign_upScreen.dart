// ignore_for_file: use_key_in_widget_constructors, file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login.dart';

final _formKey = GlobalKey<FormState>();
final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

late Timer timer;
int counter = 60;
bool dialogSms = false, makeError = false, finishSms = true, checkRe = false;
// ignore: unused_field
bool visibility1 = true, visibility2 = true, check = true;
FocusNode focusNode1 = FocusNode();
FocusNode focusNode2 = FocusNode();
FocusNode focusNode3 = FocusNode();
FocusNode focusNode4 = FocusNode();
FocusNode focusNode5 = FocusNode();

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

String? verificationId;
String? countryCode;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthcubitCubit, AuthcubitState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: SizedBox(
                    child: SingleChildScrollView(
                      primary: true,
                      child: Column(
                        children: [
                          SizedBox(
                            height: h * 0.07,
                          ),
                          Padding(
                            padding: (lang == 'en')
                                ? EdgeInsets.only(
                                    left: w * 0.3,
                                  )
                                : EdgeInsets.only(right: w * 0.3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Text(
                                    LocalKeys.SIGN_UP.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        color: Colors.white,
                                        fontSize: w * 0.06,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: (lang == 'en')
                                      ? const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.white,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.keyboard_arrow_left,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Container(
                            width: w,
                            height: h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: h * 0.02,
                                  ),
                                  Text(
                                    LocalKeys.NAME.tr(),
                                    style: TextStyle(
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  nametextFormField(),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Text(
                                    LocalKeys.EMAIL.tr(),
                                    style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  emailtextFormField(),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Text(
                                    LocalKeys.PHONE.tr(),
                                    style: TextStyle(
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  phoneFormField(),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Text(
                                    LocalKeys.PASSWORD.tr(),
                                    style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  passwordTextFormField(),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Text(
                                    LocalKeys.CONFIRM_PASS.tr(),
                                    style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontFamily: (lang == 'en')
                                            ? 'Nunito'
                                            : 'Almarai',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  confirmpasswordTextFormField(),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  RoundedLoadingButton(
                                    controller: _btnController,
                                    child: Center(
                                        child: Text(
                                      LocalKeys.REGISTER.tr(),
                                      style: TextStyle(
                                          fontFamily: (lang == 'en')
                                              ? 'Nunito'
                                              : 'Almarai',
                                          color: Colors.white,
                                          fontSize: w * 0.05,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    successColor: Colors.white,
                                    color: mainColor,
                                    borderRadius: w * 0.07,
                                    height: h * 0.06,
                                    disabledColor: Colors.black,
                                    errorColor: Colors.red,
                                    valueColor: Colors.white,
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      AuthcubitCubit.get(context).register(
                                          controller: _btnController,
                                          email: email.text,
                                          password: password.text,
                                          name: name.text,
                                          phone: phone.text,
                                          confirmpassword: confirmPassword.text,
                                          context: context);
                                    },
                                  ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocalKeys.HAVE_ACCOUNT.tr(),
                                        style: TextStyle(
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            color: Colors.black,
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: w * 0.01,
                                      ),
                                      InkWell(
                                        child: Text(
                                          LocalKeys.LOG_IN.tr(),
                                          style: TextStyle(
                                            color: mainColor,
                                            fontFamily: (lang == 'en')
                                                ? 'Nunito'
                                                : 'Almarai',
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()));
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: w * 0.04,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        },
        listener: (context, state) {});
  }

  Widget nametextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: name,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: false,
          textInputAction: TextInputAction.next,
          focusNode: focusNode1,
          onEditingComplete: () {
            focusNode1.unfocus();

            FocusScope.of(context).requestFocus();
          },
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: TextStyle(
              color: Colors.red,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            hintText: LocalKeys.NAME.tr(),
            hintStyle: TextStyle(
              color: Colors.black45,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
        ),
      ),
    );
  }

  Widget emailtextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: false,
          textInputAction: TextInputAction.next,
          focusNode: focusNode2,
          onEditingComplete: () {
            focusNode2.unfocus();
            FocusScope.of(context).requestFocus();
          },
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: TextStyle(
              color: Colors.red,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            hintText: LocalKeys.EMAIL.tr(),
            hintStyle: TextStyle(
              color: Colors.black45,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
        ),
      ),
    );
  }

  Widget phoneFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: phone,
          keyboardType: TextInputType.phone,
          style: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: false,
          textInputAction: TextInputAction.next,
          focusNode: focusNode3,
          onEditingComplete: () {
            focusNode3.unfocus();

            FocusScope.of(context).requestFocus();
          },
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: TextStyle(
              color: Colors.red,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            hintText: LocalKeys.PHONE.tr(),
            hintStyle: TextStyle(
              color: Colors.black45,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
        ),
      ),
    );
  }

  passwordTextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: password,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: visibility1,
          textInputAction: TextInputAction.next,
          focusNode: focusNode4,
          onEditingComplete: () {
            focusNode4.unfocus();

            FocusScope.of(context).requestFocus();
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visibility1 = false;
                });
              },
              child: (visibility1 == true)
                  ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.visibility_outlined,
                      color: Colors.black,
                    ),
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: TextStyle(
              color: Colors.red,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            hintText: LocalKeys.PASSWORD.tr(),
            hintStyle: TextStyle(
              color: Colors.black45,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmpasswordTextFormField() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: confirmPassword,
          style: TextStyle(
            color: Colors.black,
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: visibility2,
          textInputAction: TextInputAction.done,
          focusNode: focusNode5,
          onEditingComplete: () {
            focusNode5.unfocus();

            FocusScope.of(context).requestFocus();
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visibility2 = false;
                });
              },
              child: (visibility2 == true)
                  ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.visibility_outlined,
                      color: Colors.black,
                    ),
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: TextStyle(
              color: Colors.red,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            hintText: LocalKeys.PASSWORD.tr(),
            hintStyle: TextStyle(
              color: Colors.black45,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
            labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    double w = MediaQuery.of(context).size.width;

    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black38, width: 1),
      borderRadius: BorderRadius.circular(w * 0.8),
    );
  }
}
