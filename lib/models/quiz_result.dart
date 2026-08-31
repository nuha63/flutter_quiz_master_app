class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final DateTime date;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.date,
  });

  int get wrongAnswers => totalQuestions - correctAnswers;
  double get percentage => (correctAnswers / totalQuestions) * 100;
  String get scoreDisplay => "$correctAnswers/$totalQuestions";

  Map<String, dynamic> toJson() => {
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'date': date.toIso8601String(),
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        totalQuestions: json['totalQuestions'],
        correctAnswers: json['correctAnswers'],
        date: DateTime.parse(json['date']),
      );
}
