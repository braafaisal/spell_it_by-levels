class Score {
  int _score = 0;
  final String level;

  Score({required this.level});

  Future<void> addScore(String question) async {
    // Implement logic to add score based on the question
    _score += 10; // Example logic to add 10 points
  }

  Future<List<dynamic>> getScore() async {
    // Implement logic to get score list
    return ['example']; // Example score list
  }

  int get currentScore => _score;
}
