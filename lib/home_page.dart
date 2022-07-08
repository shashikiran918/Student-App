import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_app/preferences.dart';
import 'package:student_app/select_language.dart';
import 'package:student_app/student.dart';
import 'package:student_app/student_database.dart';
import 'package:student_app/style_constants.dart';
import 'package:student_app/translations/Locale_keys.g.dart';

import 'add_user_page.dart';
import 'color_constants.dart';
import 'custom_gradient_background.dart';
import 'home_page_grid_view.dart';
import 'home_page_list_view.dart';
import 'package:easy_localization/easy_localization.dart';

enum View { grid, list }
enum Sort { none, name, marks, id, rank }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var view = View.list;
  List<Student> studentList = [];
  List<Student> sortedStudentList = [];
  var sortBy = Sort.none;
  bool isLoading = true;
  bool selectDarkTheme = false;
  bool selectLightTheme = false;
  List<int> indexSelectedList = [];
  List<Student> selectedStudent = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void fetchStudents() async {
    final List<Student> list = await StudentDatabase.instance.readAllNotes();
    setState(() {
      studentList.addAll(list);
      isLoading = false;
    });
  }

  sorting(Sort sort) {
    sortedStudentList.clear();
    sortedStudentList.addAll(studentList);
    if (sort == Sort.marks) {
      sortedStudentList.sort((a, b) => b.marks!.compareTo(a.marks!));
      sortBy = Sort.marks;
    } else if (sort == Sort.id) {
      sortedStudentList.sort((a, b) => a.studentId!.compareTo(b.studentId!));
      sortBy = Sort.id;
    } else if (sort == Sort.name) {
      sortedStudentList.sort((a, b) => a.name!.compareTo(b.name!));
      sortBy = Sort.name;
    } else if (sort == Sort.rank) {
      sortedStudentList.sort((a, b) => b.marks!.compareTo(a.marks!));
      var r ;
      var w = 1;
      for (var stu in sortedStudentList) {
        if (sortedStudentList.firstWhere((e) => e.marks == stu.marks).rank != 0) {
          stu.rank = sortedStudentList.firstWhere((e) => e.marks == stu.marks).rank;
          r = (sortedStudentList.last.rank! + sortedStudentList.where((e) => e.marks == stu.marks).length + 1 );
          // w++;
          setState(() {});
        } else {
          setState(() {});
          stu.rank = w++;
          setState(() {});
        }
      }
      sortBy = Sort.rank;
    }
    print(sortedStudentList);
    setState(() {});
  }

  void updateStudent(Student stu) {
    studentList.removeAt(studentList.indexWhere((element) => element.id == stu.id));
    studentList.add(stu);
    if (sortBy != Sort.none) {
      sortedStudentList.removeAt(sortedStudentList.indexWhere((element) => element.id == stu.id));
      sortedStudentList.add(stu);
    }
    studentList.map((e) => e.rank = 0).toList();
    sorting(sortBy);
    setState(() {});
    StudentDatabase.instance.update(stu);
  }

  void deleteStudent(Student stu) {
    if (sortBy != Sort.none) {
      sortedStudentList.removeAt(
          sortedStudentList.indexWhere((element) => element.id == stu.id));
    }
    studentList.removeAt(studentList.indexWhere((element) => element.id == stu.id));
    studentList.map((e) => e.rank = 0).toList();
    sorting(sortBy);
    setState(() {});
    StudentDatabase.instance.delete(stu.id!);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? willPop = false;
        willPop = await showAnimatedDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ClassicGeneralDialogWidget(
              titleText: LocaleKeys.Exit.tr(),
              contentText:LocaleKeys.Do_You_Want_to_Exit_From_App.tr(),
              onPositiveClick: () {
                Navigator.of(context).pop(true);
              },
              positiveTextStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              onNegativeClick: () {
                Navigator.of(context).pop(false);
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
        return willPop!;
      },
      child:  CustomGradientBackground(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        )
            : Scaffold(
          drawer: Container(
              color: PreferencesApp().getDarkTheme
                  ? Color(0xff252B43)
                  : Color(0xff8D67FF),
              width: 300.w,
            child: Column(
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
                    Text(  LocaleKeys.HelloSignin.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          color: Colors.white, fontSize: 25),
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
                              primary:
                              PreferencesApp().getDarkTheme == false
                                  ? const Color(0xff8D67FF)
                                  : const Color(0xffFFFFFF),),
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
                                    color: PreferencesApp().getDarkTheme ==
                                        false
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
                            color: Colors.white
                        )),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(LocaleKeys.Settings.tr(),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        )),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.language, size: 25,),
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
                            color: Colors.white
                        )),
                  ),
                  ListTile(
                    leading: Icon(Icons.border_color),
                    title: Text(LocaleKeys.Feedback.tr(),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        )),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text(LocaleKeys.Logout.tr(),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        )),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
            ]
          )
        ),
          appBar: AppBar(
            backgroundColor: PreferencesApp().getDarkTheme ? Color(0xff252B43):Color(0xffFFFFFF),
            title: Text(LocaleKeys.STUDENT_DATA.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.purpleAccent,
            ),
            ),
            centerTitle: true,
            actions: [
              // Visibility(
              //   visible: selectedStudent.length != 0,
              //   child: IconButton(
              //       onPressed: (){
              //     deleteAllSelected();
              //   }, icon: Icon(Icons.delete)),
              // ),
              PopupMenuButton(
                child: Icon(
                  FlutterRemix.menu_3_line,
                  color: PreferencesApp().getDarkTheme
                      ? Colors.white
                      : Color(0xff2F3651),
                  size: 24.w,
                ),
                color: PreferencesApp().getDarkTheme ? Color(0xff252B43):Color(0xffFFFFFF),
                initialValue: view == View.list ? 1 : 2,
                onSelected: (index) {
                  if (index == 1) {
                    setState(() {
                      view = View.list;
                    });
                  } else if (index == 2) {
                    setState(() {
                      view = View.grid;
                    });
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(
                      LocaleKeys.list_view.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text(
                      LocaleKeys.grid_view.tr(),
                      style:TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: PopupMenuButton(
                      color: PreferencesApp().getDarkTheme ? Color(0xff252B43):Color(0xffFFFFFF),
                      onSelected: (index) {
                        if (index == 4) {
                          sorting(Sort.name);
                        } else if (index == 5) {
                          sorting(Sort.id);
                        } else if (index == 6) {
                          sorting(Sort.rank);
                        }
                        else if (index == 7) {
                          sorting(Sort.marks);
                        }
                      },
                      child: Text(LocaleKeys.sort_by.tr(),
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      itemBuilder:  (BuildContext context){
                        return [
                          PopupMenuItem(
                              value: 4,
                              child: Text(LocaleKeys.Name.tr(),
                                style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.purpleAccent,
                                ),
                              ),),
                          PopupMenuItem(
                              value: 5,
                              child: Text(LocaleKeys.id.tr(),
                                  style:TextStyle(
                                      fontWeight: FontWeight.bold,
                                           fontSize: 15.0,
                                          color: Colors.purpleAccent,
                        ),
                        ),),
                          PopupMenuItem(
                              value: 6,
                              child: Text(LocaleKeys.rank.tr(),
                                      style:TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.purpleAccent,
                        ),
                        ),),
                          PopupMenuItem(
                            value: 7,
                            child: Text(LocaleKeys.marks.tr(),
                              style:TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.purpleAccent,
                              ),
                            ),),
                        ];
                      },
                  ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: Container(
            decoration: const BoxDecoration(
              gradient: linearGradient,
              shape: BoxShape.circle,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () async {
                final Student? student = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddUserPage(
                        studentList: studentList,
                      );
                    },
                  ),
                );
                if (student != null) {
                  studentList.add(student);
                  StudentDatabase.instance.create(student);
                  if (sortBy == Sort.none) {
                    setState(() {});
                  } else {
                    studentList.map((e) => e.rank = 0).toList();
                    sorting(sortBy);
                    setState(() {});
                  }
                }
              },
              child: Icon(
                Icons.add,
                color: primaryColorLight,
                size: 24.w,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Expanded(
                child: view == View.list
                    ? HomePageListView(
                  studentList: sortBy == Sort.none
                      ? studentList
                      : sortedStudentList,
                  sortByRank: sortBy == Sort.rank,
                  updateStudent: (Student stu, int index) {
                    updateStudent(stu);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.purple,
                        content: Text(
                          LocaleKeys.data_updated_successfully.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )));
                  },
                  deleteStudent: (Student stu, int index) {
                    deleteStudent(stu);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.purple,
                        content: Text(
                          LocaleKeys.data_deleted_successfully.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )));
                  },
                )
                    : HomePageGridView(
                  studentList: sortBy == Sort.none
                      ? studentList
                      : sortedStudentList,
                  setIndex: (index) {
                    indexSelectedList.contains(index)
                        ? indexSelectedList.remove(index)
                        : indexSelectedList.add(index);
                    selectedStudent.contains(index)
                        ? selectedStudent.remove(studentList[index])
                        : selectedStudent.add(studentList[index]);
                    setState(() {});

                  },
                  indexSelectedList: indexSelectedList,
                  sortByRank: sortBy == Sort.rank,
                  updateStudent: (Student stu, int index) {
                    updateStudent(stu);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.purple,
                        content: Text(
                          LocaleKeys.data_updated_successfully.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )));
                  },
                    deleteStudent: (Student stu, int index) {
                      deleteStudent(stu);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.purple,
                          content: Text(
                            LocaleKeys.data_deleted_successfully.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )));
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}