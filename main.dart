import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/auth_gate.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/bookings_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/notifications_page.dart';
import 'l10n/app_localizations.dart';

enum AppTheme { light, dark, blue, green }

final ValueNotifier<AppTheme> themeNotifier = ValueNotifier(AppTheme.light);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, currentLocale, _) {
        return ValueListenableBuilder<AppTheme>(
          valueListenable: themeNotifier,
          builder: (_, currentTheme, __) {
            ThemeData themeData;
            switch (currentTheme) {
              case AppTheme.dark:
                themeData = ThemeData.dark();
                break;
              case AppTheme.blue:
                themeData = ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Colors.blue,
                    secondary: Colors.blueAccent,
                    surface: const Color.fromARGB(255, 170, 189, 220),
                  ),
                  scaffoldBackgroundColor: const Color.fromARGB(255, 207, 235, 255),
                  appBarTheme: const AppBarTheme(
                    color: Color.fromARGB(255, 105, 188, 255),
                    foregroundColor: Colors.white,
                  ),
                );
                break;
              case AppTheme.green:
                themeData = ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Colors.green,
                    secondary: Colors.greenAccent,
                    surface: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  scaffoldBackgroundColor: const Color.fromARGB(255, 208, 255, 213),
                  appBarTheme: const AppBarTheme(
                    color: Color.fromARGB(255, 146, 255, 149),
                    foregroundColor: Colors.white,
                  ),
                );
                break;
              case AppTheme.light:
                themeData = ThemeData.light();
            }

            return MaterialApp(
              title: 'Hotel Booking',
              debugShowCheckedModeBanner: false,
              theme: themeData,
              locale: currentLocale,
              supportedLocales: const [
                Locale('en'),
                Locale('ru'),
                Locale('kk'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const AuthGate(),
            );
          },
        );
      },
    );
  }
}
