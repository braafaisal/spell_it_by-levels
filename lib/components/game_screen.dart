import 'package:flutter/material.dart';
import 'package:spell_it/services/score.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spell_it/pages/result_page.dart';

class GameScreen extends StatefulWidget {
  final List<String> questions;
  final String level;
  final List<dynamic> gameScoreList;
  final Score gameScore;
  final Function(int, int) onLevelComplete; // توقع اثنين من الوسيطات

  const GameScreen({
    Key? key,
    required this.questions,
    required this.level,
    required this.gameScoreList,
    required this.gameScore,
    required this.onLevelComplete, // توقع اثنين من الوسيطات
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  int _currentQuestionIndex = 0;
  String _userAnswer = '';
  bool _isCorrect = false;
  int _correctAnswers = 0;
  int _wrongAttempts = 0;

  @override
  void initState() {
    super.initState();
    _speakCurrentQuestion();
  }

  Future<void> _speakCurrentQuestion() async {
    // نطق السؤال الحالي
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(widget.questions[_currentQuestionIndex]);
  }

  void _checkAnswer() {
    setState(() {
      _isCorrect = _controller.text.trim().toLowerCase() ==
          widget.questions[_currentQuestionIndex].trim().toLowerCase();
    });

    if (_isCorrect) {
      _correctAnswers++;
      _showCorrectAnswerDialog();
    } else {
      _wrongAttempts++;
      _showIncorrectAnswerDialog();
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _controller.clear();
        _isCorrect = false;
      });
      _speakCurrentQuestion();
    } else {
      _showResultsScreen();
      widget.onLevelComplete(
        widget.questions.length,
        _correctAnswers,
      ); // تمرير الإجابات الصحيحة وعدد الأسئلة
    }
  }

  void _showCorrectAnswerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Correct!'),
          content: const Text('You have answered correctly!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(
                    const Duration(milliseconds: 300), _goToNextQuestion);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showIncorrectAnswerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect'),
          content: const Text('Your answer is not correct, please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(
                    const Duration(milliseconds: 300), _goToNextQuestion);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showResultsScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          totalQuestions: widget.questions.length,
          correctAnswers: _correctAnswers,
          wrongAttempts: _wrongAttempts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level: ${widget.level}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                  color: Colors.blue,
                  value: _currentQuestionIndex / widget.questions.length),
              const SizedBox(height: 20.0),
              // Text(
              //   'Question: ${widget.questions[_currentQuestionIndex]}',
              //   style: const TextStyle(
              //       fontSize: 24.0, fontWeight: FontWeight.bold),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your answer',
                  hintText: 'Type your answer here',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    _userAnswer = text;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('Submit Answer'),
              ),
              const SizedBox(height: 40.0),
              Text(
                _isCorrect ? 'Correct!' : 'Please enter your answer.',
                style: TextStyle(
                  fontSize: 20.0,
                  color: _isCorrect ? Colors.green : Colors.red,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Question ${_currentQuestionIndex + 1} of ${widget.questions.length}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }
}
