import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/student.dart';
import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';
import 'color_constants.dart';
import 'custom_gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

class EditPage extends StatefulWidget {
  final Student student;
  final List<Student> studentList;
  const EditPage({Key? key, required this.student, required this.studentList})
      : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.student.name!;
    _idController.text = widget.student.studentId!.toString();
    _marksController.text = widget.student.marks!.toString();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomGradientBackground(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w).copyWith(top: 60.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    FlutterRemix.arrow_left_line,
                    color: primaryColorLight,
                    size: 24.w,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                      color: PreferencesApp().getDarkTheme
                          ? primaryColorDark
                          : Colors.blue[100]!.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${LocaleKeys.Name.tr()}: ${widget.student.name}",
                                style: textStyle.copyWith(
                                  color: PreferencesApp().getDarkTheme
                                      ? textColor
                                      : Color(0xff252B43),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "${LocaleKeys.marks.tr()}:${widget.student.marks}",
                                style: textStyle.copyWith(
                                  color: PreferencesApp().getDarkTheme
                                      ? textColor
                                      : Color(0xff252B43),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${LocaleKeys.id.tr()}:${widget.student.studentId}",
                                style: textStyle.copyWith(
                                  color: PreferencesApp().getDarkTheme
                                      ? textColor
                                      : Color(0xff252B43),
                                ),
                              ),
                              SizedBox(height: 8.h),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        alignment: Alignment.topCenter,
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 250.h),
                            height: 150,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: linearGradient,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Scaffold(
                              resizeToAvoidBottomInset: false,
                              body: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    TextFormField(
                                      controller: _nameController,
                                      style: textStyle,
                                      validator: (val) {
                                        return _nameController.text.isEmpty
                                            ? LocaleKeys.enter_name.tr()
                                            : null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[a-zA-Z]'))
                                      ],
                                      decoration: textFormFieldDecoration.copyWith(
                                          labelText: LocaleKeys.Name.tr(),
                                          errorStyle: const TextStyle(fontSize: 10)),
                                    ),
                                    SizedBox(height: 8.h),
                                    TextFormField(
                                      readOnly: true,
                                      controller: _idController,
                                      style: textStyle,
                                      // validator: (val) {
                                      //   if (_idController.text.isEmpty) {
                                      //     return LocaleKeys.enter_ID.tr();
                                      //   } else {
                                      //     var contain = widget.studentList.where((element) =>
                                      //         element.studentId == int.parse(_idController.text));
                                      //     if (contain.isEmpty) {
                                      //       return null;
                                      //     } else {
                                      //       return  LocaleKeys.id_is_already_exist.tr();
                                      //     }
                                      //   }
                                      // },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: textFormFieldDecoration.copyWith(
                                          labelText: LocaleKeys.id.tr(),
                                          errorStyle: TextStyle(fontSize: 10)),
                                    ),
                                    SizedBox(height: 8.h),
                                    TextFormField(
                                      controller: _marksController,
                                      style: textStyle,
                                      validator: (val) {
                                        if (_marksController.text.isEmpty) {
                                          return LocaleKeys.enter_marks.tr();
                                        } else {
                                          if (int.parse(_marksController.text) >= 0 &&
                                              int.parse(_marksController.text) < 101) {
                                            return null;
                                          } else {
                                            return  LocaleKeys.enter_number_between_0_to_100.tr();
                                          }
                                        }
                                      },
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.number,
                                      decoration: textFormFieldDecoration.copyWith(
                                          labelText: LocaleKeys.marks.tr(),
                                          errorStyle: TextStyle(fontSize: 10)),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop(Student(
                                        _nameController.text,
                                        int.parse(_idController.text),
                                        int.parse(_marksController.text),
                                        widget.student.id,
                                      ));
                                        }
                                      },
                                      child: Container(
                                        height: 40.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: primaryColorLight,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          LocaleKeys.submit.tr(),
                                          style: TextStyle(
                                            color: primaryColor2,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(flex: 2),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        animationType: DialogTransitionType.slideFromRight,
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    child: Container(
                      height: 28.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        gradient: linearGradient,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        LocaleKeys.edit.tr(),
                        style: TextStyle(
                          color: primaryColorLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
