import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/student.dart';
import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';
import 'package:uuid/uuid.dart';

import 'color_constants.dart';
import 'custom_gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

class AddUserPage extends StatelessWidget {
  final List<Student> studentList;
  AddUserPage({
    Key? key,
    required this.studentList,
  }) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomGradientBackground(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: PreferencesApp().getDarkTheme ? Color(0xff252B43) : Color(0xffFFFFFF),
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w).copyWith(top: 60.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  TextFormField(
                    controller: _nameController,
                    style: textStyle,
                    validator: (val) {
                      return _nameController.text.isEmpty ? LocaleKeys.enter_name.tr() : null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                    ],
                    decoration:  textFormFieldDecoration2(
                      fillColor: PreferencesApp().getDarkTheme ? primaryColorDark : Colors.blue[100]!.withOpacity(0.7),
                      labelText:  LocaleKeys.Name.tr(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _idController,
                    style: textStyle,
                    validator: (val) {
                      if (_idController.text.isEmpty) {
                        return LocaleKeys.enter_ID.tr();
                      } else {
                        var contain = studentList.where((element) =>
                        element.studentId == int.parse(_idController.text));
                        if (contain.isEmpty) {
                          return null;
                        } else {
                          return LocaleKeys.id_is_already_exist.tr();
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration:  textFormFieldDecoration2(
                      fillColor: PreferencesApp().getDarkTheme ? primaryColorDark : Colors.blue[100]!.withOpacity(0.7),
                      labelText:  LocaleKeys.id.tr(),
                    ),
                  ),
                  SizedBox(height: 16.h),
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
                          return LocaleKeys.enter_number_between_0_to_100.tr();
                        }
                      }
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration:  textFormFieldDecoration2(
                      labelText: LocaleKeys.marks.tr(),
                      fillColor: PreferencesApp().getDarkTheme ? primaryColorDark : Colors.blue[100]!.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(
                          Student(
                            _nameController.text,
                            int.parse(_idController.text),
                            int.parse(_marksController.text),
                            const Uuid().v1(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: linearGradient,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        LocaleKeys.save.tr(),
                        style: TextStyle(
                          color: primaryColorLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
