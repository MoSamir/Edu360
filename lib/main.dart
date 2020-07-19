import 'package:edu360/blocs/BlocDelegate.dart';
import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/ui/screens/CourseName.dart';
import 'package:edu360/ui/screens/ProfileScreen.dart';
import 'package:edu360/ui/screens/WallScreen.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';

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
          value: AppDataBloc(),
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: Resources.FONT_FAMILY_NAME,
            ),
            debugShowCheckedModeBanner: false,
            home: CourseName(),
          ),
        ),
    ),
  );
}