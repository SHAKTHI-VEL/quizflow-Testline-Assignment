import 'package:flutter/material.dart';
import 'package:quizflow/features/Leaderboard/ui/leaderboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizSummaryPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;
  final Map<String, dynamic> quizData;
  final String username;

  const QuizSummaryPage({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.quizData,
    required this.username
  }) : super(key: key);

  Future<void> _submitScore(BuildContext context) async {
    try {
      final double scorePercentage = (correctAnswers / totalQuestions) * 100;
      
      await Supabase.instance.client.from('quiz_scores').insert({
        'username': username,
        'quiz_title': quizData['title'] ?? 'Quiz',
        'total_questions': totalQuestions,
        'correct_answers': correctAnswers,
        'score_percentage': scorePercentage,
        'time_taken_seconds': timeTaken.inSeconds,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit score: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double scorePercentage = (correctAnswers / totalQuestions) * 100;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitScore(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Summary'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, 
          vertical: height * 0.02
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quizData['title'] ?? 'Quiz Summary',
              style: TextStyle(
                fontSize: width * 0.06, 
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.02),

            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: width * 0.05, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      '$correctAnswers / $totalQuestions',
                      style: TextStyle(
                        fontSize: width * 0.06, 
                        color: Colors.orange
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      '${scorePercentage.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: width * 0.045),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.02),
            Card(
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Total Questions', '$totalQuestions'),
                    _buildDetailRow('Correct Answers', '$correctAnswers'),
                    _buildDetailRow('Incorrect Answers', '${totalQuestions - correctAnswers}'),
                    _buildDetailRow('Time Taken', '${timeTaken.inMinutes}m ${timeTaken.inSeconds % 60}s'),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.02),
            Text(
              _getPerformanceInterpretation(scorePercentage),
              style: TextStyle(
                fontSize: width * 0.04, 
                fontStyle: FontStyle.italic
              ),
              textAlign: TextAlign.center,
            ),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.3, height * 0.06)
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('Home'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.3, height * 0.06)
                  ),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => LeaderboardPage(
                          quizTitle: quizData['title'] ?? 'Genetics and Evolution'
                        )
                      )
                    );
                  },
                  child: Text('Leaderboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String _getPerformanceInterpretation(double percentage) {
    if (percentage >= 90) return 'Excellent performance! 🏆';
    if (percentage >= 75) return 'Great job! Keep improving! 👍';
    if (percentage >= 50) return 'Good effort. Practice more! 💪';
    return 'Need more practice. Don\'t give up! 📚';
  }
}