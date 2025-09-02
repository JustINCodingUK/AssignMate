import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getVersion() async {
  final prefs = await SharedPreferences.getInstance();
  final version = prefs.getString("version");
  return version;
}

Future<void> setVersion(String newVersion) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("version", newVersion);
}