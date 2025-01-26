import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizflow/features/Home/bloc/home_bloc.dart';
import 'package:quizflow/features/Quiz/ui/quizComponent.dart';

class Addmodal extends StatefulWidget {
  const Addmodal({super.key, required this.homeBloc});

  final HomeBloc homeBloc;

  @override
  State<Addmodal> createState() => _AddmodalState();
}

class _AddmodalState extends State<Addmodal> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    final nameController = TextEditingController();
    return Container(
      height: height * 0.80,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.05,
              ),
              Text(
                'Get Started!!',
                style: GoogleFonts.poppins(fontSize: height * 0.035),
              ),
            ],
          ),
          SizedBox(height: height * 0.05),
          Container(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.10,
          ),
          SizedBox(
            width: width * 0.81,
            height: height * 0.064,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizComponent(name: nameController.text),
                    ),
                  );
                }
              },
              child: Text(
                'Continue',
                style: GoogleFonts.poppins(
                    fontSize: height * 0.025, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
