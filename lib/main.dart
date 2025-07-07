import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notsy/core/common_data/data_source/local/local/local_database.dart';
import 'package:notsy/core/di/app_component/app_component.dart';

import 'core/common_presentation/bottom_navigation/view/main_navigation_screen.dart';

late AppLocalDatabase db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding before async code
  await initAppComponentsLocator();
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // ← global app bar color
        ),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainNavigationScreen(),
    );
  }
}
