// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http; // تغيير اسم المكتبة لتفادي التعارض
// import 'package:shared_preferences/shared_preferences.dart';

// class GameData {
//   String levelName;
//   List<dynamic>? questions; // إضافة ? لتدعيم القيم القابلة للـ null

//   GameData({required this.levelName}); // استخدام required للبارامترات المطلوبة

//   Future<void> getQuestions() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cachedData =
//         prefs.getString('level-$levelName'); // نوع القيم String?

//     if (cachedData != null) {
//       // التحقق من انتهاء الصلاحية في الكاش
//       Map<String, dynamic> cache = json.decode(cachedData);

//       DateTime now = DateTime.now();
//       DateTime expiry = DateTime.parse(cache['expiry']);
//       Duration difference = now.difference(expiry);

//       // حفظ الكاش ليوم واحد فقط
//       if (difference.inDays > 1) {
//         // إزالة الكاش
//         prefs.remove('level-$levelName');
//         // استدعاء API للحصول على الأسئلة الجديدة
//         await makeAPIRequest();
//       } else {
//         // تقديم الأسئلة من الكاش
//         questions = cache['questions'];
//       }
//     } else {
//       // استدعاء API
//       await makeAPIRequest();
//     }
//   }

//   Future<void> makeAPIRequest() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();

//       http.Response response = await http.get(Uri.parse(
//           'https://ms.akashrajpurohit.com/api/spell-it/level/$levelName'));

//       Map<String, dynamic> data = json.decode(response.body);

//       questions = data['data'];

//       Map<String, dynamic> cacheData = {
//         'questions': data['data'],
//         'expiry': DateTime.now().toString()
//       };

//       prefs.setString('level-$levelName', json.encode(cacheData));
//     } on SocketException {
//       questions = [-1];
//     } catch (e) {
//       print(e);
//       questions = [-2];
//     }
//   }
// }
