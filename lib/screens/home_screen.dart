import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/models/drawer_item.dart';

enum AnswerList {
  answer1,
  answer2,
  answer3 /*, answer4, answer5, answer6, answer7, answer8, answer9*/
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int answId = 0;

  String textAnsw1;
  String textAnsw2;
  String textAnsw3;
  String textTitle;
  String textDesc;
  String textUrl;

  bool _selected = false;

  double startPos = 0.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticOut;
  final List<Answers> answers = [
    Answers(
        answer1: "answer1",
        answer2: "answer2",
        answer3: "answer3",
        title: "Title 1",
        description: "Short description 1",
        url: "https://picsum.photos/250?image=10"),
    Answers(
        answer1: "answer4",
        answer2: "answer5",
        answer3: "answer6",
        title: "Title 2",
        description: "Short description 2",
        url: "https://picsum.photos/250?image=11"),
    Answers(
        answer1: "answer7",
        answer2: "answer8",
        answer3: "answer9",
        title: "Title 3",
        description: "Short description 3",
        url: "https://picsum.photos/250?image=12"),
    Answers(
        answer1: "answer10",
        answer2: "answer11",
        answer3: "answer12",
        title: "Title 4",
        description: "Short description 4",
        url: "https://picsum.photos/250?image=13"),
  ];

  chooseQuestion(int answId) {
    String _answ1 = answers[answId].answer1;
    String _answ2 = answers[answId].answer2;
    String _answ3 = answers[answId].answer3;
    String _title = answers[answId].title;
    String _desc = answers[answId].description;
    String _url = answers[answId].url;
    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        textAnsw1 = _answ1;
        textAnsw2 = _answ2;
        textAnsw3 = _answ3;
        textTitle = _title;
        textDesc = _desc;
        textUrl = _url;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Answers _answ = answers[0];
    setState(() {
      textAnsw1 = _answ.answer1;
      textAnsw2 = _answ.answer2;
      textAnsw3 = _answ.answer3;
      textTitle = _answ.title;
      textDesc = _answ.description;
      textUrl = _answ.url;
    });
  }

  onEndAnimation(double ePos) {
    Future.delayed(Duration(milliseconds: 250), () {
      curve = curve == Curves.easeOut ? Curves.easeIn : Curves.easeOut;
      double _startPos;
      double _endPos;

      switch (ePos.toString()) {
        case '-1.5':
          _startPos = -1.5;
          _endPos = 0.0;
          break;
        case '1.5':
          _startPos = 1.5;
          _endPos = 0.0;
          break;
        default:
          _startPos = 0.0;
          _endPos = 0.0;
      }
      setState(() {
        startPos = _startPos;
        endPos = _endPos;
      });
    });
  }

  int count = 0;

  final _formKey = GlobalKey<FormState>();
  AnswerList _answer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter tutorial $count taps"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      drawer: DrawerItem(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/1.png"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                TweenAnimationBuilder(
                  tween: Tween<Offset>(
                      begin: Offset(startPos, 0), end: Offset(endPos, 0)),
                  duration: Duration(milliseconds: 250),
                  curve: curve,
                  builder: (context, offset, child) {
                    return FractionalTranslation(
                      translation: offset,
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: child,
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    onEndAnimation(endPos);
                  },
                  child: Column(
                    children: [
                      Container(
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: Image.network(textUrl),
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
                                          text: textTitle,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline)),
                                      TextSpan(
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 25.0),
                                        text: "\n$textDesc",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                  title: Text(textAnsw1),
                                  value: AnswerList.answer1,
                                  groupValue: _answer,
                                  activeColor: Colors.white,
                                  onChanged: (AnswerList value) {
                                    setState(() {
                                      _answer = value;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text(textAnsw2),
                                  value: AnswerList.answer2,
                                  groupValue: _answer,
                                  activeColor: Colors.white,
                                  toggleable: _selected,
                                  onChanged: (AnswerList value) {
                                    setState(() {
                                      _answer = value;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text(textAnsw3),
                                  value: AnswerList.answer3,
                                  groupValue: _answer,
                                  activeColor: Colors.white,
                                  toggleable: _selected,
                                  onChanged: (AnswerList value) {
                                    setState(() {
                                      _answer = value;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                      onPressed: answId == 0 || _answer == null
                          ? null
                          : () => {
                                setState(() {
                                  endPos = -1.5;
                                  answId--;
                                  _answer = null;
                                }),
                                chooseQuestion(answId)
                              },
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 20.0), text: "Back"),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                      onPressed: answId == answers.length - 1 || _answer == null
                          ? null
                          : () => {
                                setState(() {
                                  endPos = 1.5;
                                  answId++;
                                  _answer = null;
                                }),
                                chooseQuestion(answId)
                              },
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 20.0), text: "Next"),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          size: 40.0,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
        onPressed: () {
          print("tap");
          setState(() => count++);
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(),
    );
  }
}
