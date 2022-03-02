// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rayan_store/app_cubit/appstate.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(AppInitialstates());
  static AppCubit get(context) => BlocProvider.of(context);

  int? colorselected;
  String? colorTitleselected;
  void colorSelection({int? selected, String? title}) {
    colorselected = selected;
    colorTitleselected = title;
    emit(SelectionColorState());
  }

  int? sizeselected;
  String? sizeTitleselected;
  void sizeSelection({int? selected, String? title}) {
    sizeselected = selected;
    sizeTitleselected = title;
    emit(SelectionSizeState());
  }

  int? addressselected;
  void addressSelection({int? selected}) {
    addressselected = selected;
    emit(SelectionAddressState());
  }

  File? image;
  String image1 = "";

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image1 = pickedFile.path;
      image = File(pickedFile.path);
      emit(ProfileImageState());
    } else {
      print('No image selected.');
    }
  }
}
