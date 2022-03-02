// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/country/cubit/country_cubit.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressInfo extends StatefulWidget {
  @override
  _AddressInfoState createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  String? areaName;
  late int areaId;
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
      if (preferences.getBool('login') == true) {
        _listEd[0].text = UserprofileCubit.get(context).userModel!.name ?? '';
        _listEd[1].text = UserprofileCubit.get(context).userModel!.email ?? '';
        _listEd[2].text = UserprofileCubit.get(context).userModel!.phone ?? '';
      } else {
        _listEd[0].text = '';
        _listEd[1].text = '';
        _listEd[2].text = '';
      }
      _listEd[4].text = preferences.getString('user_address') ?? '';
    });
  }

  final List<FocusNode> _listFocus =
      List<FocusNode>.generate(6, (_) => FocusNode());
  final List<TextEditingController> _listEd =
      List<TextEditingController>.generate(6, (_) => TextEditingController());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  String getText(int index) {
    return _listEd[index].text;
  }

  @override
  void initState() {
    getLang();
    CountryCubit.get(context).getCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final List<String> _hint = (lang == 'en')
        ? [
            'Name',
            'E-mail (optional)',
            'phone number',
            'Country',
            'Address',
            'Note (optional)'
          ]
        : [
            'الاسم',
            'البريد الإلكتروني ( اختياري)',
            'رقم الهاتف',
            'الدوله',
            'العنوان',
            'ملاحظات ( اختياري)'
          ];
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              LocalKeys.ADD_INFO.tr(),
              style: TextStyle(
                  fontSize: w * 0.05,
                  fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            leading: const BackButton(
              color: Colors.black,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Center(
            child: SizedBox(
              width: w * 0.9,
              height: h,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: List.generate(_listFocus.length, (index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.03,
                            ),
                            if (index != 3)
                              TextFormField(
                                cursorColor: Colors.black,
                                controller: _listEd[index],
                                focusNode: _listFocus[index],
                                textInputAction: index == 4 || index == 3
                                    ? TextInputAction.newline
                                    : TextInputAction.next,
                                keyboardType: index == 1
                                    ? TextInputType.emailAddress
                                    : index == 4 || index == 5
                                        ? TextInputType.multiline
                                        : index == 2
                                            ? TextInputType.number
                                            : TextInputType.text,
                                inputFormatters: index != 0
                                    ? null
                                    : [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"[0-9 a-z  @ .]")),
                                      ],
                                maxLines: index == 5 || index == 4 ? 4 : 1,
                                onEditingComplete: () {
                                  _listFocus[index].unfocus();
                                  if (index < _listEd.length - 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_listFocus[index + 1]);
                                  }
                                },
                                validator: (value) {
                                  if (index != 1 && index != 5) {
                                    if (value!.isEmpty) {
                                      return LocalKeys.VALID.tr();
                                    }
                                  }
                                  if (index == 1) {
                                    if (value != null && value.isNotEmpty) {
                                      if (value.length < 4 ||
                                          !value.endsWith('.com') ||
                                          '@'.allMatches(value).length != 1) {
                                        return LocalKeys.VALID_EMAIL.tr();
                                      }
                                    }
                                  }
                                  if (index == 2) {
                                    if (value!.length < 8) {
                                      return LocalKeys.VALID_PHONE.tr();
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusedBorder: form(),
                                  enabledBorder: form(),
                                  errorBorder: form(),
                                  focusedErrorBorder: form(),
                                  hintText: _hint[index],
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            if (index == 3)
                              SizedBox(
                                width: w * 0.9,
                                child: FormField(
                                  builder: (state) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BlocConsumer<CountryCubit,
                                                CountryState>(
                                            builder: (context, state) {
                                              return ConditionalBuilder(
                                                  condition: state
                                                      is! GetCityLoadingState,
                                                  builder:
                                                      (context) => Container(
                                                            width: w * 0.9,
                                                            height: h * 0.09,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      mainColor,
                                                                  width: 1.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            w * 0.02),
                                                                child: SizedBox(
                                                                  width:
                                                                      w * 0.9,
                                                                  child:
                                                                      DropdownButton<
                                                                          String>(
                                                                    isDense:
                                                                        true,
                                                                    isExpanded:
                                                                        true,
                                                                    underline:
                                                                        const SizedBox(),
                                                                    iconEnabledColor:
                                                                        mainColor,
                                                                    iconDisabledColor:
                                                                        mainColor,
                                                                    iconSize:
                                                                        w * 0.08,
                                                                    hint: Text(
                                                                      LocalKeys
                                                                          .AREA
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          fontFamily: (lang == 'en')
                                                                              ? 'Nunito'
                                                                              : 'Almarai',
                                                                          color:
                                                                              Colors.grey[400]),
                                                                    ),
                                                                    items: List.generate(
                                                                        CountryCubit.get(context)
                                                                            .cityModel!
                                                                            .data!
                                                                            .length,
                                                                        (index) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: (lang ==
                                                                                'en')
                                                                            ? CountryCubit.get(context).cityModel!.data![index].nameEn
                                                                            : CountryCubit.get(context).cityModel!.data![index].nameAr,
                                                                        child: (lang ==
                                                                                'en')
                                                                            ? Text(
                                                                                CountryCubit.get(context).cityModel!.data![index].nameEn!,
                                                                                style: TextStyle(
                                                                                  color: Colors.grey[600],
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                CountryCubit.get(context).cityModel!.data![index].nameAr!,
                                                                                style: TextStyle(
                                                                                  color: Colors.grey[600],
                                                                                ),
                                                                              ),
                                                                        onTap:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            areaName = (lang == 'en')
                                                                                ? CountryCubit.get(context).cityModel!.data![index].nameEn
                                                                                : CountryCubit.get(context).cityModel!.data![index].nameAr;
                                                                            areaId =
                                                                                CountryCubit.get(context).cityModel!.data![index].id!;
                                                                          });
                                                                          SharedPreferences
                                                                              prefs =
                                                                              await SharedPreferences.getInstance();
                                                                          prefs
                                                                              .setString('city_id', CountryCubit.get(context).cityModel!.data![index].id!.toString())
                                                                              .then((value) {
                                                                            CartCubit.get(context).getDelivery(context: context);
                                                                          });
                                                                        },
                                                                      );
                                                                    }),
                                                                    onChanged:
                                                                        (val) async {
                                                                      SharedPreferences
                                                                          prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      prefs
                                                                          .setString(
                                                                              'city_id',
                                                                              CountryCubit.get(context).cityModel!.data![index].id!.toString())
                                                                          .then((value) {
                                                                        CartCubit.get(context).getDelivery(
                                                                            context:
                                                                                context);
                                                                      });
                                                                    },
                                                                    value:
                                                                        areaName,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ), // your widget

                                                  fallback: (context) =>
                                                      Container());
                                            },
                                            listener: (context, state) {}),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        if (state.errorText != null)
                                          Text(
                                            state.errorText ?? '',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).errorColor,
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                  validator: (val) {
                                    if (areaName == null) {
                                      return "";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    BlocConsumer<CartCubit, CartState>(
                        builder: (context, state) {
                          return RoundedLoadingButton(
                            child: Container(
                              height: h * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: mainColor,
                              ),
                              child: Center(
                                child: Text(
                                  LocalKeys.CONTINUE.tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          (lang == 'en') ? 'Nunito' : 'Almarai',
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            controller: _btnController,
                            successColor: mainColor,
                            color: mainColor,
                            disabledColor: mainColor,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                CartCubit.get(context).saveOrder(
                                    name: _listEd[0].text,
                                    phone: _listEd[2].text,
                                    email: _listEd[1].text,
                                    address: _listEd[4].text,
                                    note: _listEd[5].text,
                                    context: context,
                                    controller: _btnController);
                              } else {
                                _btnController.error();
                                await Future.delayed(
                                    const Duration(milliseconds: 1000));
                                _btnController.stop();
                              }
                            },
                          );
                        },
                        listener: (context, state) {}),
                    SizedBox(
                      height: h * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: mainColor, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
