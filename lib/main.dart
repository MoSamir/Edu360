import 'package:edu360/blocs/BlocDelegate.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';

import 'blocs/bloc/UserDataBloc.dart';
import 'ui/screens/SplashScreen.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
        path: 'assets/locales',
        useOnlyLangCode: true,
        saveLocale: true,
        startLocale: Locale('en', 'US'),
        fallbackLocale: Locale('en', 'US'),
        child: BlocProvider.value(
          value: UserDataBloc(),
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: Resources.FONT_FAMILY_NAME,
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        ),
    ),
  );
}