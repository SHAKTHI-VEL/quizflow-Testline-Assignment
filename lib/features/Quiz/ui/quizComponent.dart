import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quizflow/features/QuizSummary/ui/quizSummary.dart';

class QuizComponent extends StatefulWidget {
  final String name;

  const QuizComponent({super.key, required this.name});
  @override
  _QuizComponentState createState() => _QuizComponentState();
}

class _QuizComponentState extends State<QuizComponent> {
  Map<String, dynamic>? _quizData;
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isLoading = true;
  String _errorMessage = '';
  Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
          Uri.parse('https://api.jsonserve.com/Uw5CrX'),
          headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _quizData = data;
          _questions = data['questions'] ?? [];
          _isLoading = false;
        });

        _stopwatch.start();
      } else {
        setState(() {
          _errorMessage = 'HTTP Error ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _checkAnswer(String selectedOption) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedOptionData = currentQuestion['options']
        .firstWhere((option) => option['description'] == selectedOption);

    if (selectedOptionData['is_correct']) {
      _score++;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
          _selectedAnswer = null;
        } else {
          _stopwatch.stop();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizSummaryPage(
                totalQuestions: _questions.length,
                correctAnswers: _score,
                timeTaken: _stopwatch.elapsed,
                quizData: _quizData!,
                username: widget.name,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    final ThemeData theme = ThemeData(
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_quizData?['title'] ?? 'Quiz'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage),
                        ElevatedButton(
                          onPressed: _fetchQuizData,
                          child: Text('Retry'),
                        )
                      ],
                    ),
                  )
                : _questions.isEmpty
                    ? Center(child: Text('No questions available'))
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _questions[_currentQuestionIndex]['description'],
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.02),
                            ...List.generate(
                              _questions[_currentQuestionIndex]['options']
                                  .length,
                              (index) {
                                var option = _questions[_currentQuestionIndex]
                                    ['options'][index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(width * 0.8, height * 0.07),
                                      backgroundColor: _selectedAnswer ==
                                              option['description']
                                          ? Colors.orange.shade700
                                          : Colors.orange,
                                    ),
                                    onPressed: _selectedAnswer == null
                                        ? () {
                                            setState(() {
                                              _selectedAnswer =
                                                  option['description'];
                                            });
                                            _checkAnswer(option['description']);
                                          }
                                        : null,
                                    child: Text(
                                      option['description'],
                                      style: TextStyle(fontSize: width * 0.04),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
