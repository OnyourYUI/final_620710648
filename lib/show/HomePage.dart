import 'dart:async';
import 'dart:io';
import 'package:final_620710648/model/QuizGame.dart';
import 'package:final_620710648/srv/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QuizGame>? quizL;
  int count = 0;
  int WGuess = 0;
  String MSG = "";

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
      quizL = list.map((item) => QuizGame.fromJson(item)).toList();
    });
  }

  void guess(String choice) {
    setState(() {
      if (quizL![count].choice_list[quizL![count].answer] == choice) {
        MSG = "เก่งมากค่ะ";
      } else {
        MSG = "ตอบผิด กรุณาตอบใหม่";
      }
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        MSG = "";
        if (quizL![count].choice_list[quizL![count].answer] == choice) {
          count++;
        } else {
          WGuess++;
        }
      });
    });
  }

  Widget printGuess() {
    if (MSG.isEmpty) {
      return SizedBox(height: 20, width: 10);
    } else if (MSG == "เก่งมากค่ะ") {
      return Text(MSG);
    } else {
      return Text(MSG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quizL != null && count < quizL!.length-1
          ? buildQuiz()
          : quizL != null && count == quizL!.length-1
          ? buildTryAgain()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTryAgain() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('จบเกม'),
            Text('ทายผิด ${WGuess} ครั้ง'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    WGuess = 0;
                    count = 0;
                    quizL = null;
                    _fetch();
                  });
                },
                child: Text('เริ่มใหม่'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(quizL![count].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < quizL![count].choice_list.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(quizL![count].choice_list[i].toString()),
                            child: Text(quizL![count].choice_list[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printGuess(),
          ],
        ),
      ),
    );
  }
}