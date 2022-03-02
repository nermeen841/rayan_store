// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUs extends StatefulWidget {
  final title;
  AboutUs(this.title, {Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: TextStyle(
                fontSize: w * 0.05,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          leading: const BackButton(
            color: Colors.black,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<UserprofileCubit, UserprofileState>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! GetSingleInfoLoadinState,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: w * .05, left: w * 0.05, top: h * 0.01),
                        child: SizedBox(
                          width: w * 0.9,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: mainColor,
                                        radius: w * 0.02,
                                      ),
                                      SizedBox(
                                        width: w * .05,
                                      ),
                                      SizedBox(
                                        width: w * 0.75,
                                        child: (lang == 'en')
                                            ? Text(
                                                UserprofileCubit.get(context)
                                                    .singleItemModel!
                                                    .data!
                                                    .pageTitleEn!,
                                              )
                                            : Text(
                                                UserprofileCubit.get(context)
                                                    .singleItemModel!
                                                    .data!
                                                    .pageTitleAr!,
                                              ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  Wrap(
                                    children: [
                                      (lang == 'en')
                                          ? Text(
                                              UserprofileCubit.get(context)
                                                  .singleItemModel!
                                                  .data!
                                                  .pageDetailsEn!,
                                              style: TextStyle(
                                                height: w * 0.005,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                              ),
                                            )
                                          : Text(
                                              UserprofileCubit.get(context)
                                                  .singleItemModel!
                                                  .data!
                                                  .pageDetailsAr!,
                                              style: TextStyle(
                                                height: w * 0.005,
                                                fontFamily: (lang == 'en')
                                                    ? 'Nunito'
                                                    : 'Almarai',
                                              ),
                                            )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  fallback: (context) => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ));
            },
            listener: (context, state) {}));
  }
}
