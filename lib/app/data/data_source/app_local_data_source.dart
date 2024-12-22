import 'package:shared_preferences/shared_preferences.dart';

class AppLocalDataSource {
  Future<bool> get isLoggedIn async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isLoggedIn') ?? false;
  }

  Future<String?> get userId async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId') ;
  }

  Future<void> setUserLoggedInStatus(bool isLoggedIn) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> setUserId(String userId) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString('userId', userId );
  }
}
