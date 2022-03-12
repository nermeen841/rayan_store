abstract class AppCubitStates {}

class AppInitialstates extends AppCubitStates {}

class SelectionColorState extends AppCubitStates {}

class SelectionSizeState extends AppCubitStates {}

class ProfileImageState extends AppCubitStates {}

class SelectionAddressState extends AppCubitStates {}

class HomeitemsLoaedingState extends AppCubitStates {}

class HomeitemsSuccessState extends AppCubitStates {}

class HomeitemsErrorState extends AppCubitStates {
  final String error;
  HomeitemsErrorState(this.error);
}

class SingleProductLoaedingState extends AppCubitStates {}

class SingleProductSuccessState extends AppCubitStates {}

class SingleProductErrorState extends AppCubitStates {
  final String error;
  SingleProductErrorState(this.error);
}

class SingleProductColorLoaedingState extends AppCubitStates {}

class SingleProductColorSuccessState extends AppCubitStates {}

class SingleProductColorErrorState extends AppCubitStates {
  final String error;
  SingleProductColorErrorState(this.error);
}
