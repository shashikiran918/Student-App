

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesApp {
  static final PreferencesApp _instance = PreferencesApp._();
  late SharedPreferences _sharedPreferences;

  factory PreferencesApp() {
    return _instance;
  }

  PreferencesApp._();

  SharedPreferences get sharedPreferences => _sharedPreferences;
  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  Future<bool> setDarkTheme(bool darkTheme) async{
    return await _sharedPreferences.setBool('dark_theme', darkTheme);
  }


  bool get getDarkTheme => _sharedPreferences.getBool('dark_theme') ?? false;


  Future<bool> setLanguage(String codeLang) async{
    return await _sharedPreferences.setString("codeLang", codeLang);
  }

  String get codeLang => _sharedPreferences.getString("codeLang") ?? "en";

}