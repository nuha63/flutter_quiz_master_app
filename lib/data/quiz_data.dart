import 'package:flutter/material.dart';
import '../models/quiz_category.dart';
import '../models/quiz_question.dart';

final List<QuizCategory> quizCategories = [
  QuizCategory(
    id: 'sports',
    name: 'Sports',
    icon: '🏀',
    color: Colors.orange,
    questions: [
      QuizQuestion(
        question: 'Which country won the FIFA World Cup in 2022?',
        options: ['France', 'Argentina', 'Brazil', 'Germany'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'How many players are there in a cricket team?',
        options: ['9', '10', '11', '12'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'Which sport is known as the "king of sports"?',
        options: ['Cricket', 'Basketball', 'Football', 'Tennis'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'In which sport would you perform a "slam dunk"?',
        options: ['Football', 'Tennis', 'Basketball', 'Golf'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'How long is a marathon?',
        options: ['26.2 miles', '21 miles', '15 miles', '30 miles'],
        correctAnswerIndex: 0,
      ),
    ],
  ),
  QuizCategory(
    id: 'science',
    name: 'Science',
    icon: '🔬',
    color: Colors.blue,
    questions: [
      QuizQuestion(
        question: 'What is the chemical symbol for water?',
        options: ['O2', 'H2O', 'CO2', 'NaCl'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'What is the powerhouse of the cell?',
        options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Vacuole'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'What gas do plants absorb from the atmosphere?',
        options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'What is the boiling point of water?',
        options: ['90°C', '100°C', '110°C', '120°C'],
        correctAnswerIndex: 1,
      ),
    ],
  ),
  QuizCategory(
    id: 'tech',
    name: 'Technology',
    icon: '💻',
    color: Colors.purple,
    questions: [
      QuizQuestion(
        question: 'Who is the co-founder of Microsoft?',
        options: ['Steve Jobs', 'Bill Gates', 'Elon Musk', 'Mark Zuckerberg'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'What does CPU stand for?',
        options: ['Central Process Unit', 'Central Processing Unit', 'Computer Personal Unit', 'Central Processor Unit'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'Which language is used for Flutter development?',
        options: ['Java', 'Swift', 'Dart', 'Kotlin'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'What was the first version of Android called?',
        options: ['Cupcake', 'Donut', 'Alpha', 'Eclair'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'Which company owns Instagram?',
        options: ['Google', 'Apple', 'Meta', 'Microsoft'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  QuizCategory(
    id: 'history',
    name: 'History',
    icon: '📜',
    color: Colors.brown,
    questions: [
      QuizQuestion(
        question: 'Who was the first President of the USA?',
        options: ['Abraham Lincoln', 'Thomas Jefferson', 'George Washington', 'John Adams'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'In which year did World War II end?',
        options: ['1943', '1944', '1945', '1946'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'Who built the Taj Mahal?',
        options: ['Akbar', 'Shah Jahan', 'Babur', 'Humayun'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'The Great Wall is located in which country?',
        options: ['Japan', 'China', 'India', 'Korea'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'Which empire was ruled by Julius Caesar?',
        options: ['Greek', 'Roman', 'Ottoman', 'Persian'],
        correctAnswerIndex: 1,
      ),
    ],
  ),
  QuizCategory(
    id: 'gk',
    name: 'General Knowledge',
    icon: '🧠',
    color: Colors.green,
    questions: [
      QuizQuestion(
        question: 'Which is the largest continent?',
        options: ['Africa', 'Europe', 'Asia', 'North America'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'Which animal is known as the Ship of the Desert?',
        options: ['Horse', 'Camel', 'Elephant', 'Lion'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'How many colors are there in a rainbow?',
        options: ['5', '6', '7', '8'],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        question: 'Which is the tallest mountain in the world?',
        options: ['K2', 'Mount Everest', 'Kangchenjunga', 'Lhotse'],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: 'Which country is known as the Land of the Rising Sun?',
        options: ['China', 'South Korea', 'Japan', 'Thailand'],
        correctAnswerIndex: 2,
      ),
    ],
  ),
];
