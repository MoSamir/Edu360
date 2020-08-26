import 'package:edu360/blocs/BlocDelegate.dart';
import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/events/AppDataEvents.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import 'package:easy_localization/easy_localization.dart';

import 'ui/screens/SplashScreen.dart';

void main() async{
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.mainThemeColor,
    statusBarBrightness: Brightness.light,
  ));



  Constants.CURRENT_LOCALE = "ar";

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/locales',
        useOnlyLangCode: true,
        saveLocale: true,
        startLocale: Locale('ar'),
        fallbackLocale: Locale('ar'),
        child: AppEntrance(),
    ),
  );
}

class AppEntrance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: AppDataBloc()..add(LoadApplicationConstantData()),
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
