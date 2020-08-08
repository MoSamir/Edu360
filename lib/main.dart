import 'package:edu360/blocs/BlocDelegate.dart';
import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/events/AppDataEvents.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
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
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/locales',
        useOnlyLangCode: true,
        saveLocale: true,
        startLocale: Locale('en'),
        fallbackLocale: Locale('en'),
        child: BlocProvider.value(
          value: AppDataBloc()..add(LoadApplicationConstantData()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        ),
    ),
  );
}