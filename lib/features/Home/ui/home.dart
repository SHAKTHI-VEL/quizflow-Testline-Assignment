import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizflow/features/Home/bloc/home_bloc.dart';
import 'package:quizflow/features/Home/widget/addModal.dart';
import 'package:quizflow/features/Leaderboard/ui/leaderboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OpenAddNameOverlay) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Addmodal(homeBloc: homeBloc));
            });
          }
          return Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                alignment: Alignment.center,
                child: const Image(image: AssetImage('assets/quiz.png')),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ready to Start?',
                    style: GoogleFonts.poppins(
                        fontSize: height * 0.03, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: width),
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Take polls and get bonuses.Determine your level of Knowledge.Become the smartest among friends and acquaintances',
                          style: GoogleFonts.poppins(
                              fontSize: height * 0.017,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.090,
                  ),
                  SizedBox(
                    width: width * 0.81,
                    height: height * 0.064,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade800),
                      onPressed: () {
                        homeBloc.add(StartButtonClicked());
                      },
                      child: Text(
                        'Press to Start',
                        style: GoogleFonts.poppins(
                            fontSize: height * 0.025, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text.rich(
                      TextSpan(
                        text: 'Want to see Rankings?',
                        style: GoogleFonts.poppins(
                            fontSize: height * 0.017,
                            fontWeight: FontWeight.w300),
                        children: <InlineSpan>[
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LeaderboardPage(
                                        quizTitle: 'Genetics and Evolution'),
                                  ),
                                );
                              },
                              child: Text(
                                'Leaderboard',
                                style: GoogleFonts.poppins(
                                    fontSize: height * 0.017,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.orange),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ])
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
