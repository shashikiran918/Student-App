import 'package:flutter/material.dart';

import 'package:student_app/preferences.dart';

class CustomGradientBackground extends StatelessWidget {
  final Widget child;
  const CustomGradientBackground({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: PreferencesApp().getDarkTheme
              ? [
            Color(0xff252b43),
            Color(0xf252B43),
          ]
              : [
            Color(0xffffffff),
            Color(0xffFFFFFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
