import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> saveUserDataToCache(String userName, bool isLoading) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
    prefs.setBool('isLoading', isLoading);
    // Add other fields if needed
  }

  static Future<Map<String, Object>> retrieveUserDataFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? '';
    final isLoading = prefs.getBool('isLoading') ?? true;
    // Retrieve other fields if needed
    return {'userName': userName, 'isLoading': isLoading};
  }
  static Future<void> saveLabsToCache(List<Map<String, dynamic>> labs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> encodedList = labs.map((lab) {
      return jsonEncode(lab);
    }).toList();
    prefs.setStringList('labs', encodedList);
  }

  static Future<List<Map<String, dynamic>>> retrieveLabsFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encodedList = prefs.getStringList('labs');
    if (encodedList != null) {
      return encodedList.map((labString) {
        return jsonDecode(labString) as Map<String, dynamic>;
      }).toList();
    }
    return [];
  }

  static Future<void> saveDrawerDataToCache(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userProfilePic', userData['profilePictureUrl'] ?? '');
    prefs.setString('email', userData['email'] ?? '');
    prefs.setString('userName', userData['name'] ?? '');
    // Add other fields if needed
  }

  static Future<Map<String, dynamic>> retrieveDrawerDataFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'userProfilePic': prefs.getString('userProfilePic') ?? '',
      'email': prefs.getString('email') ?? '',
      'userName': prefs.getString('userName') ?? '',
      // Retrieve other fields if needed
    };
  }

  static Future<void> saveProfileDataToCache(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userProfilePic', userData['profilePictureUrl'] ?? '');
    prefs.setString('email', userData['email'] ?? '');
    prefs.setString('userName', userData['name'] ?? '');
    prefs.setString('phone', userData['phone'] ?? '');
    prefs.setString('age', userData['age'].toString() ?? '');
    prefs.setString('gender', userData['gender'] ?? '');
    prefs.setString('bloodGroup', userData['blood_grp'] ?? '');
    // Add other fields if needed
  }

  static Future<Map<String, dynamic>> retrieveProfileDataFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'userProfilePic': prefs.getString('userProfilePic') ?? '',
      'email': prefs.getString('email') ?? '',
      'userName': prefs.getString('userName') ?? '',
      'phone': prefs.getString('phone') ?? '',
      'age': prefs.getString('age') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'bloodGroup': prefs.getString('bloodGroup') ?? '',
      // Retrieve other fields if needed
    };
  }

  static Future<Map<String, dynamic>> retrieveTestDataFromCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('testData');
    if (jsonData != null && jsonData.isNotEmpty) {
      return Map<String, dynamic>.from(json.decode(jsonData));
    }
    return {};
  }

  static Future<void> saveTestDataToCache(Map<String, dynamic> testData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('testData', json.encode(testData));
  }
}
