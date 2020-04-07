import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
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
            padding: const EdgeInsets.all(8.0),
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
  QuizBrain quiz = QuizBrain();

  List<Icon> scoreKeeper = [];

  void insertIcon({bool givenAnswer}) {
    if (!quiz.isFinished()) {
      if (givenAnswer ==
          quiz.getQuestionAnswer(questionNumber: quiz.getQuestionNumber())) {
        setState(() {
          scoreKeeper.add(
            Icon(Icons.check, color: Colors.green),
          );
          quiz.increaseScore();
        });
      } else {
        setState(() {
          scoreKeeper.add(
            Icon(Icons.close, color: Colors.red),
          );
        });
      }
      quiz.setQuestionNumber();
    } else {
      showResults();
    }
  }

  void showResults() {
    List<int> information = quiz.getStatistics();
    Alert(
        context: context,
        type: AlertType.success,
        title: "Finished!",
        desc:
            "You've reached the end of the quiz\n\nYou got ${information[0]} of ${information[1]} questions.",
        buttons: [
          DialogButton(
            child: Text(
              "Try again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            width: 120,
          )
        ]).show();
  }

  void resetGame() {
    setState(() {
      quiz.resetCounters();
      scoreKeeper.clear();
    });
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
                quiz.getQuestionText(questionNumber: quiz.getQuestionNumber()),
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
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                insertIcon(givenAnswer: true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                insertIcon(givenAnswer: false);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: scoreKeeper,
            ),
          ),
        )
      ],
    );
  }
}
