import 'package:shared_preferences/shared_preferences.dart';

class AppLocalDataSource {
  Future<bool> get isLoggedIn async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isLoggedIn') ?? false;
  }

  Future<int?> get userId async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getInt('userId') ;
  }

  Future<void> setUserLoggedInStatus(bool isLoggedIn) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> setUserId(int userId) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setInt('userId', userId );
  }
}
