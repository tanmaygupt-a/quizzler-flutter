import 'dart:ffi';
import 'quiz_brain.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> icons = [];
  QuizBrain quizBrain = new QuizBrain();
  int correctAns = 0;

  String getScore() {
    int totalQues = quizBrain.getTotalQuestions();
    return '$correctAns/$totalQues';
  }

  void checkAnswer(bool userPickedAnswer) {
    if (quizBrain.isFinished()) {
      bool corrAns = quizBrain.getQuestionAnswer();
      if (userPickedAnswer == corrAns) {
        icons.add(new Icon(Icons.check, color: Colors.green));
        correctAns++;
      } else {
        icons.add(new Icon(Icons.close, color: Colors.red));
      }
      String res = getScore();
      Alert(
        context: context,
        closeIcon: Icon(Icons.close),
        title: "Finished!",
        desc: "You have reached the end of the Quiz\n Your Score: $res ",
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
      setState(() {
        icons.clear();
        quizBrain.reset();
        correctAns = 0;
      });
    } else {
      bool corrAns = quizBrain.getQuestionAnswer();

      setState(() {
        if (userPickedAnswer == corrAns) {
          icons.add(new Icon(Icons.check, color: Colors.green));
          correctAns++;
        } else {
          icons.add(new Icon(Icons.close, color: Colors.red));
        }
        quizBrain.nextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  checkAnswer(false);
                }),
          ),
        ),
        Row(
          children: icons,
        )
      ],
    );
  }
}
