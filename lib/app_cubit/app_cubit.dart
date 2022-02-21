import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/app_cubit/appstate.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(AppInitialstates());
  static AppCubit get(context) => BlocProvider.of(context);

  int? colorselected;
  void colorSelection({int? selected}) {
    colorselected = selected;
    emit(SelectionColorState());
  }

  int? sizeselected;
  void sizeSelection({int? selected}) {
    sizeselected = selected;
    emit(SelectionSizeState());
  }

  int? addressselected;
  void addressSelection({int? selected}) {
    addressselected = selected;
    emit(SelectionAddressState());
  }
}
