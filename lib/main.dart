import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spell_it/components/game_screen.dart';
import 'package:spell_it/services/score.dart';
import 'package:spell_it/services/game_data.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.redAccent,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/game') {
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;

            return MaterialPageRoute(
              builder: (context) {
                return GameScreen(
                  questions: args['questions'] as List<String>,
                  level: args['level'] as String,
                  gameScoreList: args['gameScoreList'] as List<dynamic>,
                  gameScore: args['gameScore'] as Score,
                  onLevelComplete: args['onLevelComplete'] as Function(
                      int, int), // تم التعديل هنا لتوقع اثنين من الوسيطات
                );
              },
            );
          }
          return null;
        },
      ),
    );

class Level {
  final String name;
  final int number;
  final Color color;

  Level({required this.name, required this.number, required this.color});
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Level> levels = [
    Level(name: "Easy", number: 1, color: Colors.green),
    Level(name: "Medium", number: 2, color: Colors.greenAccent),
    Level(name: "Hard", number: 3, color: Colors.blueAccent),
    Level(name: "Extreme", number: 4, color: Colors.red),
  ];

  List<bool> levelUnlocked = [true, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadLevelState(); // تحميل حالة المستويات عند بدء التطبيق
  }

  Future<void> _loadLevelState() async {
    // تحميل حالة المستويات من التخزين
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedState = prefs.getStringList('levelUnlocked');

    if (savedState != null) {
      setState(() {
        levelUnlocked = savedState.map((state) => state == 'true').toList();
      });
    }
  }

  Future<void> _saveLevelState() async {
    // حفظ حالة المستويات في التخزين
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedState =
        levelUnlocked.map((state) => state.toString()).toList();
    await prefs.setStringList('levelUnlocked', savedState);
  }

  Future<void> _resetLevelState() async {
    // إعادة تعيين حالة المستويات إلى الوضع الافتراضي
    setState(() {
      levelUnlocked = [true, false, false, false]; // المستوى الأول فقط مفتوح
    });
    await _saveLevelState();
    _showResetConfirmationDialog(context);
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Completed"),
          content: const Text("All levels have been reset to default."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _goToGame(BuildContext context, Level level) async {
    int levelIndex = levels.indexOf(level);

    if (!levelUnlocked[levelIndex]) {
      _showLockedLevelDialog(context);
      return;
    }

    GameData instance = GameData(levelName: level.name);
    await instance.getQuestions();

    if (instance.questions == null || instance.questions!.isEmpty) {
      _showNoQuestionsDialog(context);
      return;
    }

    if (instance.questions![0] is! String || instance.questions![0].isEmpty) {
      _showInvalidQuestionDialog(context);
      return;
    }

    Score gameScore = Score(level: level.name);
    List<dynamic> gameScoreList = await gameScore.getScore();

    Navigator.pushNamed(
      context,
      '/game',
      arguments: {
        'questions': instance.questions,
        'level': level.name,
        'gameScoreList': gameScoreList,
        'gameScore': gameScore,
        'onLevelComplete': (int totalQuestions, int correctAnswers) =>
            _onLevelComplete(levelIndex, totalQuestions, correctAnswers),
      },
    );
  }

  void _onLevelComplete(
      int levelIndex, int totalQuestions, int correctAnswers) {
    // حساب النسبة المئوية للإجابات الصحيحة
    double percentage = (correctAnswers / totalQuestions) * 100;

    setState(() {
      if (percentage >= 90.0 && levelIndex < levels.length - 1) {
        levelUnlocked[levelIndex + 1] = true; // فتح المستوى التالي
        _saveLevelState(); // حفظ الحالة الجديدة
        _showLevelUnlockedDialog(context);
      } else if (percentage < 90.0) {
        _showIncompleteLevelDialog(
            context); // إظهار حوار لمستخدمي أن النسبة غير كافية للانتقال
      } else if (percentage >= 90.0 && levelIndex == levels.length - 1) {
        // تحقق من أن المستخدم أكمل المستوى الأخير بنجاح
        _showAllLevelsCompleteDialog(context); // عرض حوار انتهاء المستويات
        _resetLevelState(); // إعادة تعيين حالة المستويات إلى الافتراضي
      }
    });
  }

  void _showAllLevelsCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text(
              "You have completed all levels! Levels will now be reset to default."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showLockedLevelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Level Locked"),
          content: const Text(
              "This level is locked. Please complete previous levels first."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showNoQuestionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Questions Available"),
          content:
              const Text("There are no questions available for this level."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid Question"),
          content: const Text("The question format is invalid."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showIncompleteLevelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Level Incomplete"),
          content: const Text(
              "You need to score at least 90% to proceed to the next level."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showLevelUnlockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Level Unlocked!"),
          content:
              const Text("Congratulations! You have unlocked the next level."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spell-IT'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 12.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 100.0,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(levels.length, (index) {
                  final level = levels[index];
                  return Center(
                    child: Card(
                      color: levelUnlocked[index]
                          ? level.color
                          : Colors.grey, // Update color
                      child: ListTile(
                        onTap: () => _goToGame(context, level),
                        title: Center(
                          child: Text(
                            level.name,
                            style: TextStyle(
                              color: levelUnlocked[index]
                                  ? Colors.white
                                  : Colors.black, // Update text color
                              fontSize: 30.0,
                              letterSpacing: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed: _resetLevelState, // ربط الزر بدالة إعادة التعيين
              child: const Text("Reset Levels"),
            ),
          ],
        ),
      ),
    );
  }
}
