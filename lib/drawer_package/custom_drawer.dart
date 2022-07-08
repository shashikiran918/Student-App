import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:student_app/preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:student_app/translations/Locale_keys.g.dart';

import '../select_language.dart';


class CustomGuitarDrawer extends StatefulWidget {
  final Widget? child;

  const CustomGuitarDrawer({Key? key, this.child}) : super(key: key);

  static CustomGuitarDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<CustomGuitarDrawerState>();

  @override
  CustomGuitarDrawerState createState() => new CustomGuitarDrawerState();
}

class CustomGuitarDrawerState extends State<CustomGuitarDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void toggle() => animationController!.isDismissed
      ? animationController!.forward()
      : animationController!.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (context, _) {
          return Material(
            color: Colors.blueGrey,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset:
                      Offset(maxSlide * (animationController!.value - 1), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - animationController!.value)),
                    alignment: Alignment.centerRight,
                    child: MyDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * animationController!.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * animationController!.value / 2),
                    alignment: Alignment.centerLeft,
                    child: widget.child,
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  left: 4.0 + animationController!.value * maxSlide,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController!.isDismissed;
    bool isDragCloseFromRight = animationController!.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      animationController!.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {

    double _kMinFlingVelocity = 365.0;

    if (animationController!.isDismissed || animationController!.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController!.fling(velocity: visualVelocity);
    } else if (animationController!.value < 0.5) {
      animationController!.reverse();
    } else {
      animationController!.forward();
    }
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  static _MyDrawer? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyDrawer>();

  @override
  _MyDrawer createState() => new _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  var selectDarkTheme = false;
  var selectLightTheme = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      height: double.infinity,
      child: Material(
        color: Colors.blue,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                  color: Colors.redAccent,
                  width: double.infinity,
                  height: 100,
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        size: 50.h,
                      ),
                      SizedBox(
                        width: 25.h,
                      ),
                      Text(
                        LocaleKeys.HelloSignin.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25),
                      ),
                    ],
                  )),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.wb_sunny,
                      color: Colors.black45,
                      size: 30.h,
                    ),
                    SizedBox(
                      width: 25.h,
                    ),
                    Text(
                      LocaleKeys.theme.tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectDarkTheme = false;
                            selectLightTheme = true;
                            PreferencesApp().setDarkTheme(selectDarkTheme);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: PreferencesApp().getDarkTheme == false
                              ? const Color(0xff8D67FF)
                              : const Color(0xffFFFFFF),
                        ),
                        child: Text(LocaleKeys.light.tr(),
                            style: TextStyle(
                              color: PreferencesApp().getDarkTheme
                                  ? const Color(0xff8D67FF)
                                  : const Color(0xffFFFFFF),
                            ))),
                    Container(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectDarkTheme = true;
                              selectLightTheme = false;
                              PreferencesApp().setDarkTheme(selectDarkTheme);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: PreferencesApp().getDarkTheme
                                  ? Color(0xff8D67FF)
                                  : Colors.white),
                          child: Text(LocaleKeys.dark.tr(),
                              style: TextStyle(
                                color: PreferencesApp().getDarkTheme == false
                                    ? Color(0xff8D67FF)
                                    : Colors.white,
                              ))),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.verified_user),
                title: Text(LocaleKeys.Profile.tr(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(LocaleKeys.Settings.tr(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(
                  Icons.language,
                  size: 25,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectLanguage()));
                },
                title: Text(LocaleKeys.Language.tr(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.border_color),
                title: Text(LocaleKeys.Feedback.tr(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(LocaleKeys.Logout.tr(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                onTap: () => {},
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
