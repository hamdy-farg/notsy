import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:notsy/core/common_data/data_source/local/local/local_database.dart';
import 'package:notsy/core/common_presentation/bottom_navigation/view/main_navigation_screen.dart';
import 'package:notsy/core/common_presentation/bottom_navigation/view/main_navigation_view_model.dart';
import 'package:notsy/core/di/app_component/app_component.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart'; // generated

late AppLocalDatabase db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding before async code
  await initAppComponentsLocator();
  await initializeDateFormatting('ar');

  // db = await AppLocalDatabase.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'), // OR dynamically based on user preference
      supportedLocales: const [
        // Locale('ar'), // Arabic
        Locale('en'), // English
      ],
      localizationsDelegates: [
        AppLocalizations.delegate, // generated
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Automatically choose Arabic if user's phone is in Arabic
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff34D399)),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // ← global app bar color
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ChangeNotifierProvider(
        create: (_) => locator<MainNavigationViewModel>(),
        child: const MainNavigationScreen(),
      ),
    );
  }
}
