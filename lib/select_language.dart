import 'package:flutter/material.dart';
import 'package:student_app/home_page.dart';
import 'package:student_app/preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:student_app/translations/Locale_keys.g.dart';
class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}
enum Languages { English, Hindi, Telugu }

class _SelectLanguageState extends State<SelectLanguage> {
  String  _selectedLanguage = PreferencesApp().codeLang;

  List<String> list = [
    "English",
    "Hindi",
    "Telugu"
  ];

  List<String> values = [
    "en",
    "hi",
    "te"
  ];


  String getText(String langCode){
    if(langCode == "en"){
      return "English";
    }else if(langCode == "hi"){
      return "Hindi";
    }else{
      return "Telugu";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PreferencesApp().getDarkTheme ? Color(0xff252B43):Color(0xffFFFFFF),
        title: Text(LocaleKeys.Choose_Preferred_Language.tr(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.purpleAccent,
          fontSize: 20.0,
        ),),
      ),
      backgroundColor:PreferencesApp().getDarkTheme ? Color(0xff252B43):Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              itemCount: 3,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsetsDirectional.only(start: 50, bottom: 25, top: 10),
              itemBuilder: (context , index){
                return Column(
                  children: [
                    RadioListTile<String>(value: values[index],
                      groupValue: _selectedLanguage,
                      onChanged: (String? value) async{
                        print(value);
                        setState(() {
                          _selectedLanguage = value ?? values[index];
                          PreferencesApp().setLanguage(_selectedLanguage);
                          print(PreferencesApp().setLanguage(_selectedLanguage));
                        });
                        await context.setLocale(Locale(values[index]));
                        },
                      title: Text(list[index],
                      style: TextStyle(
                        color: Colors.purpleAccent,
                      ),),
                    ),
                    Divider(thickness: 1.0,color: Colors.black12,),
                  ],
                );
              },
            ),
            ElevatedButton(
                onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePage()));
            },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.purpleAccent,),
                  primary:PreferencesApp().getDarkTheme ? Color(0xff252B43):Color(0xffFFFFFF),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("${LocaleKeys.continue_with.tr() } ${getText(PreferencesApp().codeLang)}",
                style: TextStyle(
                  color: Colors.purpleAccent,
                ),)),

          ],
        ),
      ),
    );
  }
}
