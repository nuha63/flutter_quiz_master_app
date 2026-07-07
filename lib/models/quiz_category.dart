import 'package:flutter/material.dart';
import 'quiz_question.dart';

class QuizCategory {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final List<QuizQuestion> questions;

  QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.questions,
  });
}
