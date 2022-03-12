part of 'authcubit_cubit.dart';

abstract class AuthcubitState {}

class AuthcubitInitialState extends AuthcubitState {}

class LoginLoadingState extends AuthcubitState {}

class LoginErrorState extends AuthcubitState {
  final String error;

  LoginErrorState(this.error);
}

class LoginSuccessState extends AuthcubitState {}

class RegisterLoadingState extends AuthcubitState {}

class RegisterErrorState extends AuthcubitState {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterSuccessState extends AuthcubitState {}

class ForgetpasswordLoadingState extends AuthcubitState {}

class ForgetpasswordSuccessState extends AuthcubitState {}

class ForgetpasswordErrorState extends AuthcubitState {
  final String error;

  ForgetpasswordErrorState(this.error);
}

class ChangepasswordLoadingState extends AuthcubitState {}

class ChangepasswordSuccessState extends AuthcubitState {}

class ChangepasswordErrorState extends AuthcubitState {
  final String error;

  ChangepasswordErrorState(this.error);
}

class CheckPhoneLoadingState extends AuthcubitState {}

class CheckPhoneSuccessState extends AuthcubitState {}

class CheckPhoneErrorState extends AuthcubitState {
  final String error;

  CheckPhoneErrorState(this.error);
}

class LogoutLoadingState extends AuthcubitState {}

class LogoutSuccessState extends AuthcubitState {}

class LogoutErrorState extends AuthcubitState {
  final String error;
  LogoutErrorState(this.error);
}
