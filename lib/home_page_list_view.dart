import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/student.dart';

import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';

import 'color_constants.dart';
import 'edit_page.dart';
import 'package:easy_localization/easy_localization.dart';
class HomePageListView extends StatelessWidget {
  final List<Student> studentList;
  final Function updateStudent;
  final Function deleteStudent;
  final bool sortByRank;
  const HomePageListView(
      {Key? key,
        required this.studentList,
        required this.sortByRank,
        required this.updateStudent,
        required this.deleteStudent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0).copyWith(top: 16.h),
      physics: const BouncingScrollPhysics(),
      itemCount: studentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
          ),
          child: Slidable(
            startActionPane:
            ActionPane(motion: const DrawerMotion(),
                children: [
              SlidableAction(
                onPressed: (context) async {
                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return ClassicGeneralDialogWidget(
                        titleText: LocaleKeys.delete.tr(),
                        contentText: LocaleKeys.do_you_want_to_delete_data.tr(),
                        onPositiveClick: () {
                          Navigator.of(context).pop();
                          deleteStudent(studentList[index], index);
                        },
                        positiveTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        onNegativeClick: () {
                          Navigator.of(context).pop();
                        },
                        negativeTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                    animationType: DialogTransitionType.slideFromRight,
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(seconds: 1),
                  );
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: LocaleKeys.delete.tr(),
              )
            ]),
            child: GestureDetector(
              onTap: () async {
                final Student? student = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EditPage(
                    student: studentList[index],
                    studentList: studentList,
                  );
                }));
                if (student != null) {
                  updateStudent(student, index);
                }
              },
              child: Container(
                padding: EdgeInsets.only(right: 30.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h)
                      .copyWith(left: 52.w, right: 20.w),
                  decoration: BoxDecoration(
                    color: PreferencesApp().getDarkTheme
                        ? primaryColorDark
                        : Colors.blue[100]!.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(55.r),
                      bottomRight: Radius.circular(55.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${LocaleKeys.Name.tr()}: ${studentList[index].name}",
                                style: textStyle.copyWith(
                                    color: PreferencesApp().getDarkTheme
                                        ? textColor
                                        : Color(0xff252B43)),
                            ),
                            SizedBox(height: 8.h),
                            Text("${LocaleKeys.id.tr()}: ${studentList[index].studentId}",
                                style: textStyle.copyWith(
                                    color: PreferencesApp().getDarkTheme
                                        ? textColor
                                        : Color(0xff252B43)),),
                            SizedBox(height: 8.h),
                            Text("${LocaleKeys.marks.tr()}: ${studentList[index].marks}",
                                style: textStyle.copyWith(
                                    color: PreferencesApp().getDarkTheme
                                        ? textColor
                                        : Color(0xff252B43)),),
                          ],
                        ),
                      ),
                      if (sortByRank)
                        Container(
                          height: 70.h,
                          width: 70.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: linearGradient,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.rank.tr(),
                                style: TextStyle(
                                  color: primaryColorLight,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "${studentList[index].rank}",
                                style: TextStyle(
                                  color: primaryColorLight,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
