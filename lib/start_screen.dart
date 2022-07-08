import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';

import 'color_constants.dart';
import 'custom_gradient_background.dart';
import 'home_page.dart';
import 'package:easy_localization/easy_localization.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomGradientBackground(
        child: Scaffold(
          backgroundColor: PreferencesApp().getDarkTheme ? Color(0xff252B43) : Colors.white,
          body: Column(
            children: [
              const Spacer(),
              Image.asset(
                "assets/images/cap.png",
                height: 200.h,
                width: 200.h,
              ),
              Text(
                  LocaleKeys.go_school.tr(),
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 130.h),
              Text(
                LocaleKeys.welcome.tr(),
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Spacer(),
              SizedBox(height: 250.h),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(
                      MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                },
                child: Container(
                  height: 42.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: 30.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    gradient: linearGradient,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    LocaleKeys.get_started.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColorLight,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
