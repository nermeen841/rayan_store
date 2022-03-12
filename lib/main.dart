import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/app_cubit.dart';
import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/favourite_screen/cubit/favourite_cubit.dart';
import 'package:rayan_store/screens/orders/cubit/order_cubit.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:rayan_store/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/coden_loader.dart';
import 'screens/country/cubit/country_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations', // <-- change patch to your
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(
              create: (BuildContext context) => AppCubit()
                ..sizeSelection()
                ..colorSelection()
                ..addressSelection()),
          BlocProvider<CartCubit>(
              create: (BuildContext context) => CartCubit()),
          BlocProvider<OrderCubit>(create: (context) => OrderCubit()),
          BlocProvider<FavouriteCubit>(create: (context) => FavouriteCubit()),
          BlocProvider<CountryCubit>(
              create: (BuildContext context) => CountryCubit()..getCountry()),
          BlocProvider<DataBaseCubit>(
              create: (BuildContext context) => DataBaseCubit()..createDb()),
          BlocProvider<UserprofileCubit>(
              create: (BuildContext context) =>
                  UserprofileCubit()..getAllinfo()),
          BlocProvider<AuthcubitCubit>(
              create: (BuildContext context) => AuthcubitCubit()),
          BlocProvider<HomeCubit>(
              create: (BuildContext context) => HomeCubit()..getHomeitems()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
              ),
            ),
            fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
          ),
          home: SplashScreen(),
        ));
  }
}
