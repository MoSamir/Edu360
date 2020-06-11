import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'ui/screens/SplashScreen.dart';

void main() {
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
        path: 'assets/locales',
        useOnlyLangCode: true,
        saveLocale: true,
        startLocale: Locale('en', 'US'),
        fallbackLocale: Locale('en', 'US'),
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: Resources.FONT_FAMILY_NAME,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
    ),
  );
}