import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/start_screen.dart';
import 'package:student_app/translations/codegen_loader.g.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PreferencesApp().initPreferences();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(EasyLocalization(
      path: "assets/translations",
      supportedLocales: [
        Locale("en"),
        Locale("hi"),
        Locale("te"),
      ],
      fallbackLocale: Locale(PreferencesApp().codeLang),
      assetLoader: CodegenLoader(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () {
        return MaterialApp(
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColorBrightness: PreferencesApp().getDarkTheme
                ? Brightness.dark
                : Brightness.light,
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: const StartScreen(),
        );
      },
    );
  }
}

