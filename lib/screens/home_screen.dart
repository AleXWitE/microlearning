// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/models/drawer_item.dart';

enum AnswerList {
  answer1,
  answer2,
  answer3
}
//созданперечень вариантов ответов и значений для радио кнопок

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>(); // УНИКАЛЬНЫЙ КЛЮЧ СОСТОЯНИЯ ФОРМЫ, БЕЗ НЕГО ФОРМА НЕ РАБОТАЕТ

  String textAnsw1;
  String textAnsw2;
  String textAnsw3;
  String textTitle;
  String textDesc;
  String textUrl;
  String textType;

  int answId = 0;

  double startPos = 0.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticOut;

  //старт и эндпоз месте с курвой нужны для работы анимации перехода

  AnswerList answerCheck;
  bool answ1check = false;
  bool answ2check = false;
  bool answ3check = false;
  //проверка на валидацию значений чекбоксов и радио

  @override
  void initState() {
    super.initState();
  }

  onEndAnimation(double ePos) {
    Future.delayed(Duration(milliseconds: 250), () { //задается отложенное время срабатывания анимации с заменой значений
      curve = curve == Curves.easeOut ? Curves.easeIn : Curves.easeOut;
      double _startPos;
      double _endPos;

      switch (ePos.toString()) { //свич позволяет определить сценарий работы анимации
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

  @override
  Widget build(BuildContext context) {
    Answers question = answers[answId];

    chooseQuestion(int answId) { // функция по замене значений в вопросе
      String _answ1 = question.answer1;
      String _answ2 = question.answer2;
      String _answ3 = question.answer3;
      String _title = question.title;
      String _desc = question.description;
      String _url = question.url;
      String _type = question.type;
      Future.delayed(Duration(milliseconds: 250), () { // отложенная подмена текста чтобы вопрос сменялся за пределами экрана
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

    QuestionBody(Answers question) { //вынесена повторяющаяся группа виджетов, чтобыне загромождать код
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

    ValidateCheckbox(String type) { // проверка на валидацию заполненных значений формы
      switch(type) {
        case 'radio':
          if (answerCheck == null){
            return true;
          } else {
            return false;
          }
          break;
        case 'checkbox':
          if (answ1check == false && answ2check == false && answ3check == false) {
            return true;
          } else {
            return false;
          }
          break;
        default:
          return false;
      }
    }

    ChooseType(String type) { //функция подстановки необходимого типа вопроса (радио, чекбокс, лекция)
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
                    child: QuestionBody(question) //подстановка повторяющейся группы виджетов
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
          break;// при выполнении этого кэйса, при его завершении прекращаем выполнение всего остального свича
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
            // alignment: Alignment.topCenter,
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

    return Scaffold( //скаффолд один из самых главных виджетов материал дизайна
      appBar: AppBar(
        title: Text("Flutter tutorial $count taps"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      drawer: DrawerItem(), //боковая менюшка
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage( //задание заднего фона
                image: AssetImage("assets/images/1.png"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: TweenAnimationBuilder( // анимация которая вынесла весь мозг, работает через твины передвижения, без билдера не сработает
                    tween: Tween<Offset>(
                        begin: Offset(startPos, 0), end: Offset(endPos, 0)),
                    duration: Duration(milliseconds: 250),
                    curve: curve,
                    builder: (context, offset, child) {
                      return FractionalTranslation( // добавление виджета, который оборачивает в себя анимированные объекты
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
                    child: ChooseType(question.type), // объект который анимируется
                  ),
                ),
                SizedBox(
                  height: 1,
                ),

              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton( //активная интерактивная кнопка справа внизу
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
      bottomNavigationBar: BottomAppBar( //наиболее лучшая реализация кнопок вперед назад чтобы они были прифлочены к нижней границе
        color: Colors.blueGrey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              color: Colors.blue,
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              onPressed: answId == 0 || ValidateCheckbox(question.type) //теренарные операторы наше все, позволяют задавать элс иф внутри виджетов
                  ? null
                  : () => {
                setState(() { // при нажатии кнопки определяем в какую сторону сдвигается анимация, меняем id элемента списка и обнуляем все значения, в будущем, надо будет сначала сохранять значения, а потом обнулять
                  endPos = -1.5;
                  answId--;
                  answerCheck = null;
                  answ1check = false;
                  answ2check = false;
                  answ3check = false;
                }),
                chooseQuestion(answId) //вызываем смену вопроса
              },
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 20.0), text: "Back"),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              onPressed: answId == answers.length - 1 || ValidateCheckbox(question.type)
                  ? null
                  : () => {
                setState(() {
                  endPos = 1.5;
                  answId++;
                  answerCheck = null;
                  answ1check = false;
                  answ2check = false;
                  answ3check = false;
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
      ),
    );
  }
}