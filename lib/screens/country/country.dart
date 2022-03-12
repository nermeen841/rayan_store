// ignore_for_file: avoid_print, prefer_const_constructors_in_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/componnent/http_services.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/country/cubit/country_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login.dart';
import 'package:easy_localization/easy_localization.dart';

class Country extends StatefulWidget {
  final int select;
  Country(this.select, {Key? key}) : super(key: key);
  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  String lang = '';
  int countryId = 0;

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

    print([2, Navigator.canPop(context)]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          LocalKeys.SELECT_COUNTRY.tr(),
          style: TextStyle(
              fontSize: w * 0.05,
              color: Colors.black,
              fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
              fontWeight: FontWeight.bold),
        ),
        leading: widget.select == 1
            ? const SizedBox()
            : const BackButton(
                color: Colors.black,
              ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<CountryCubit, CountryState>(
          builder: (context, state) {
            return ConditionalBuilder(
                condition: state is! GetCountryLoadingState,
                builder: (context) => Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
                        child: SizedBox(
                          width: w * 0.9,
                          height: h,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: List.generate(
                                      CountryCubit.get(context)
                                          .countryModel!
                                          .data!
                                          .length, (index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width: w * 0.9,
                                          height: h * 0.08,
                                          child: InkWell(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: w * 0.1,
                                                  height: w * 0.1,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            EndPoints
                                                                    .IMAGEURL2 +
                                                                CountryCubit.get(
                                                                        context)
                                                                    .countryModel!
                                                                    .data![
                                                                        index]
                                                                    .imageUrl!),
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: w * 0.03,
                                                ),
                                                (lang == 'en')
                                                    ? Text(
                                                        CountryCubit.get(
                                                                context)
                                                            .countryModel!
                                                            .data![index]
                                                            .nameEn!,
                                                        style: TextStyle(
                                                          fontSize: w * 0.05,
                                                          fontFamily: 'Nunito',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(
                                                        CountryCubit.get(
                                                                context)
                                                            .countryModel!
                                                            .data![index]
                                                            .nameAr!,
                                                        style: TextStyle(
                                                          fontSize: w * 0.05,
                                                          fontFamily: 'Almarai',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                const Expanded(
                                                    child: SizedBox(
                                                  width: 1,
                                                )),
                                                if (widget.select == 2)
                                                  CircleAvatar(
                                                    radius: w * 0.03,
                                                    child: Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                      size: w * 0.04,
                                                    ),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                              ],
                                            ),
                                            onTap: () async {
                                              CountryCubit.get(context)
                                                  .getCity();
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                prefs.setString(
                                                    'country_id',
                                                    CountryCubit.get(context)
                                                        .countryModel!
                                                        .data![index]
                                                        .id!
                                                        .toString());

                                                prefs.setBool(
                                                    'select_country', true);
                                                prefs.setString(
                                                    'currency',
                                                    CountryCubit.get(context)
                                                        .countryModel!
                                                        .data![index]
                                                        .currency!
                                                        .code!);
                                                prefs.setString(
                                                    'country_code',
                                                    CountryCubit.get(context)
                                                        .countryModel!
                                                        .data![index]
                                                        .code!);
                                              });
                                              if (widget.select == 1) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login()));
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.02,
                                        ),
                                        Divider(
                                          height: h * 0.005,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                SizedBox(
                                  height: h * 0.1,
                                ),
                                if (widget.select == 2)
                                  InkWell(
                                    child: Container(
                                      height: h * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: mainColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.select == 2 ? "Save" : "Next",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: (lang == 'en')
                                                  ? 'Nunito'
                                                  : 'Almarai',
                                              fontSize: w * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (countryId != 0) {
                                        if (widget.select == 1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()));
                                        }
                                        if (widget.select == 2) {
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        final snackBar = SnackBar(
                                          content: const Text(
                                              "please choose country first "),
                                          action: SnackBarAction(
                                            label: 'undo',
                                            disabledTextColor: Colors.yellow,
                                            textColor: Colors.yellow,
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                fallback: (context) => Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ));
          },
          listener: (context, state) {}),
    );
  }
}
