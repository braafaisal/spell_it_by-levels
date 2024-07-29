import 'dart:math';

class GameData {
  final String levelName;
  List<String>? questions;

  GameData({required this.levelName});

  // Here we define lists of words for each level
  final Map<String, List<String>> wordBanks = {
    "Easy": [
      "apple",
      "banana",
      "cat",
      // "dog",
      // "egg",
      // "fish",
      // "goat",
      // "hat",
      // "ice",
      // "jug"
    ],
    "Medium": [
      "bee",
      "so",
      "go",
      // "umbrella",
      // "flower",
      // "spider",
      // "laptop",
      // "jungle",
      // "rainbow",
      // "mountain"
    ],
    "Hard": [
      "need",
      "yet",
      "no",
      // "archaeology",
      // "parliament",
      // "encyclopedia",
      // "synchronization",
      // "juxtaposition",
      // "symbiosis",
      // "benevolent"
    ],
    "Extreme": [
      "over",
      "lib",
      "since",
      // "onomatopoeia",
      // "sesquipedalian",
      // "floccinaucinihilipilification",
      // "pneumonoultramicroscopicsilicovolcanoconiosis",
      // "antidisestablishmentarianism",
      // "honorificabilitudinitatibus",
      // "supercalifragilisticexpialidocious"
    ],
  };

  Future<void> getQuestions() async {
    // Instead of calling an API, we load questions from the local word bank
    questions = wordBanks[levelName];
    questions!.shuffle(Random());
  }
}














// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class GameData {
//   String levelName;
//   List<dynamic>? questions;

//   GameData({required this.levelName});

//   Future<void> getQuestions() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cachedData = prefs.getString('level-$levelName');

//     if (cachedData != null) {
//       Map<String, dynamic> cache = json.decode(cachedData);

//       DateTime now = DateTime.now();
//       DateTime expiry = DateTime.parse(cache['expiry']);
//       Duration difference = now.difference(expiry);

//       if (difference.inDays > 1) {
//         prefs.remove('level-$levelName');
//         await makeAPIRequest();
//       } else {
//         questions = cache['questions'];
//       }
//     } else {
//       await makeAPIRequest();
//     }
//   }

//   Future<void> makeAPIRequest() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       http.Response response = await http.get(Uri.parse(
//           'https://ms.akashrajpurohit.com/api/spell-it/level/$levelName'));

//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);

//         questions = data['data'];

//         Map<String, dynamic> cacheData = {
//           'questions': data['data'],
//           'expiry': DateTime.now().toString(),
//         };

//         prefs.setString('level-$levelName', json.encode(cacheData));
//       } else {
//         questions = [-2];
//       }
//     } on SocketException {
//       questions = [-1];
//     } catch (e) {
//       print(e);
//       questions = [-2];
//     }
//   }
// }

