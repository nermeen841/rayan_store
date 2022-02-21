import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';

class UpdateProfile extends StatefulWidget {
  final String userName;
  final String userEmail;
  const UpdateProfile(
      {Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  List<FocusNode> listFocus = List<FocusNode>.generate(2, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> listEd = List<TextEditingController>.generate(
        2,
        (_) => TextEditingController(
            text: _ == 0 ? widget.userName : widget.userEmail));
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            LocalKeys.UPDATE_PROFILE.tr(),
            style: TextStyle(
                fontSize: w * 0.05,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: mainColor,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
            child: SizedBox(
              width: w * 0.9,
              child: Column(
                children: [
                  Column(
                    children: List.generate(listFocus.length, (index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: h * 0.03,
                          ),
                          TextFormField(
                            cursorColor: Colors.black,
                            inputFormatters: index != 1
                                ? null
                                : [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"[0-9 a-z  @ .]")),
                                  ],
                            controller: listEd[index],
                            focusNode: listFocus[index],
                            textInputAction: index == 0
                                ? TextInputAction.next
                                : TextInputAction.done,
                            keyboardType: index == 1
                                ? TextInputType.emailAddress
                                : TextInputType.text,
                            onEditingComplete: () {
                              listFocus[index].unfocus();
                              if (index < 1) {
                                FocusScope.of(context)
                                    .requestFocus(listFocus[index + 1]);
                              }
                            },
                            decoration: InputDecoration(
                              focusedBorder: form(),
                              enabledBorder: form(),
                              errorBorder: form(),
                              focusedErrorBorder: form(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  BlocConsumer<UserprofileCubit, UserprofileState>(
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
                                LocalKeys.SEND.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          controller: _btnController,
                          successColor: mainColor,
                          color: mainColor,
                          disabledColor: mainColor,
                          onPressed: () {
                            UserprofileCubit.get(context).updateUserdata(
                                name: listEd[0].text,
                                email: listEd[1].text,
                                context: context,
                                controller: _btnController);
                          },
                        );
                      },
                      listener: (context, state) {}),
                  SizedBox(
                    height: h * 0.08,
                  ),
                  SizedBox(
                    height: h * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(25));
  }
}
