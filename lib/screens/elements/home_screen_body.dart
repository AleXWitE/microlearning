
import 'package:flutter/material.dart';
import 'package:microlearning/components/event.dart';

import '../home_screen.dart';

/*
class HomeScreenBody extends StatefulWidget {
  @override
  HomeScreenBodyState createState() => HomeScreenBodyState();
  int answId;

  HomeScreenBody({Key key,  this.answId}) : super(key: key);
}

class HomeScreenBodyState extends State<HomeScreenBody> {
  final _formKey = GlobalKey<FormState>();

  String textAnsw1;
  String textAnsw2;
  String textAnsw3;
  String textTitle;
  String textDesc;
  String textUrl;
  String textType;

  @override
  void initState() {
    super.initState();
  }

  chooseQuestion(int answId) {
    String _answ1 = answers[answId].answer1;
    String _answ2 = answers[answId].answer2;
    String _answ3 = answers[answId].answer3;
    String _title = answers[answId].title;
    String _desc = answers[answId].description;
    String _url = answers[answId].url;
    String _type = answers[answId].type;
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        textAnsw1 = _answ1;
        textAnsw2 = _answ2;
        textAnsw3 = _answ3;
        textTitle = _title;
        textDesc = _desc;
        textUrl = _url;
        textType = _type;
      });
    });
  }

  AnswerList answerCheck;

  QuestionBody(Answers question) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Image.network(question.url),
          // child: SvgPicture.asset(
          //     "assets/images/LoneWolf.svg"),
        ),
        SizedBox(
          height: 1,
        ),
        Wrap(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: "Redressed",
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: question.title,
                      style: TextStyle(
                          decoration:
                          TextDecoration.underline)),
                  TextSpan(
                    style: TextStyle(
                        color: Colors.red, fontSize: 25.0),
                    text: "\n${question.description}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Answers question = answers[widget.answId];

    String type;

    if (textType == null) {
      type = question.type;
    } else {
      type = textType;
    }

    bool answ1check = false;
    bool answ2check = false;
    bool answ3check = false;

    switch(type) {
      case 'radio':
        return Container(
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(40, 20, 60, 30),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 3,
                      color: Colors.indigo[300],
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: QuestionBody(question)
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent[100]],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 5,
                    color: Colors.teal[100],
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RadioListTile(
                          title: Text(question.answer1),
                          value: AnswerList.answer1,
                          groupValue: answerCheck,
                          activeColor: Colors.white,
                          onChanged: (AnswerList value) {
                            setState(() {
                              answerCheck = value;
                            });
                          }),
                      RadioListTile(
                          title: Text(question.answer2),
                          value: AnswerList.answer2,
                          groupValue: answerCheck,
                          activeColor: Colors.white,
                          onChanged: (AnswerList value) {
                            setState(() {
                              answerCheck = value;
                            });
                          }),
                      RadioListTile(
                          title: Text(question.answer3),
                          value: AnswerList.answer3,
                          groupValue: answerCheck,
                          activeColor: Colors.white,
                          onChanged: (AnswerList value) {
                            setState(() {
                              answerCheck = value;
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case 'checkbox':
        return Container(
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(40, 20, 60, 30),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 3,
                      color: Colors.indigo[300],
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: QuestionBody(question)
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent[100]],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 5,
                    color: Colors.teal[100],
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CheckboxListTile(
                          value: answ1check,
                          title: Text(question.answer1),
                          onChanged: (bool value) =>
                              setState(() => answ1check = value)),
                      CheckboxListTile(
                          value: answ2check,
                          title: Text(question.answer2),
                          onChanged: (bool value) =>
                              setState(() => answ2check = value)),
                      CheckboxListTile(
                          value: answ3check,
                          title: Text(question.answer3),
                          onChanged: (bool value) =>
                              setState(() => answ3check = value)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case 'lecture':
        return Container(
          // height: MediaQuery.of(context).size.height,
          // height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(40, 20, 60, 30),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent[100],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 3,
              color: Colors.indigo[300],
              style: BorderStyle.solid,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: QuestionBody(question),
        );
        break;
      default:
        return Container(
          child: Align(
            alignment: Alignment.center,
            child: Text("Ooooops! Something wrong!"),
          ),
        );
        break;
    }
  }
}
*/
