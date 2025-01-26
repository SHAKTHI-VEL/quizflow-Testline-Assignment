import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardPage extends StatefulWidget {
  final String quizTitle;

  const LeaderboardPage({Key? key, required this.quizTitle}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> _leaderboardScores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final response = await Supabase.instance.client
          .from('quiz_scores')
          .select(
              'username, score_percentage, correct_answers, time_taken_seconds')
          .eq('quiz_title', widget.quizTitle)
          .order('score_percentage', ascending: false)
          .order('time_taken_seconds')
          .limit(50);

      log(response.toString());
      setState(() {
        _leaderboardScores = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load leaderboard: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _leaderboardScores.isEmpty
              ? Center(child: Text('No scores yet'))
              : Container(
                  width: width,
                  height: height,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: height * 0.01),
                  child: ListView.builder(
                    itemCount: _leaderboardScores.length,
                    itemBuilder: (context, index) {
                      final score = _leaderboardScores[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: height * 0.005, horizontal: width * 0.01),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.01),
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade100,
                              child: Text('${index + 1}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width * 0.04)),
                            ),
                            title: Text(score['username'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.045)),
                            subtitle: Text(
                                'Correct: ${score['correct_answers']}',
                                style: TextStyle(fontSize: width * 0.035)),
                            trailing: Text(
                                '${score['score_percentage'].toStringAsFixed(1)}%',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.04)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
