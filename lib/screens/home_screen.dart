import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart'; //полезный импорт, без него не получится вставить svg картинку. Вставлять только с помощью assert
import 'package:microlearning/api/youtube.dart';
import 'package:microlearning/components/bread_dots.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AnswerList { answer1, answer2, answer3 }
//созданперечень вариантов ответов и значений для радио кнопок

class HomeScreen extends StatefulWidget {
  String _course;

  HomeScreen({String course}) : _course = course;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<
      FormState>(); // УНИКАЛЬНЫЙ КЛЮЧ СОСТОЯНИЯ ФОРМЫ, БЕЗ НЕГО ФОРМА НЕ РАБОТАЕТ

  String textAnsw1;
  String textAnsw2;
  String textAnsw3;
  String textAnswCorrect;
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

  // Future _getAnswers() async {
  //    await FirebaseFirestore.instance
  //        .collection('divisions')
  //        .doc(userDivision)
  //        .collection('courses')
  //        .doc(widget._course)
  //        .collection('cards')
  //        .get()
  //        .then((value) => value.docs.forEach((element) {
  //      answers.add(Answers(title: element.data()['card_title'],
  //        description: element.data()['card_question'],
  //        type: element.data()['card_type'],
  //        answer1: element.data()['card_answers']['answer_1'],
  //        answer2: element.data()['card_answers']['answer_2'],
  //        answer3: element.data()['card_answers']['answer_3'],
  //        answerCorrect: element.data()['card_answers']['correct_answer'],
  //        url: element.data()['card_url'],
  //      ));
  //    }));
  //  }

  @override
  void initState() {
    // _getAnswers();
    super.initState();
  }

  onEndAnimation(double ePos) {
    Future.delayed(Duration(milliseconds: 250), () {
      //задается отложенное время срабатывания анимации с заменой значений
      curve = curve == Curves.easeOut ? Curves.easeIn : Curves.easeOut;
      double _startPos;
      double _endPos;

      switch (ePos.toString()) {
        //свич позволяет определить сценарий работы анимации
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

    chooseQuestion(int answId) {
      // функция по замене значений в вопросе
      String _answ1 = question.answer1;
      String _answ2 = question.answer2;
      String _answ3 = question.answer3;
      String _title = question.title;
      String _desc = question.description;
      String _url = question.url;
      String _type = question.type;
      Future.delayed(Duration(milliseconds: 250), () {
        // отложенная подмена текста чтобы вопрос сменялся за пределами экрана
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

    Widget QuestionBody(Answers question) {
      //вынесена повторяющаяся группа виджетов, чтобыне загромождать код
      return Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(40, 20, 60, 30),
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 1,
              color: Theme.of(context).accentColor,
              style: BorderStyle.solid,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(children: [
            Text("${question.title}\n",
                style: TextStyle(
                    fontFamily: "Redressed",
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).accentColor,
                    decoration: TextDecoration.underline)),
            question.url == "" || question.url == "-"
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).accentColor,
                            blurRadius: 15,
                            spreadRadius: 3)
                      ],
                    ),
                    child: question.type == "video"
                        ? YouTubePlay(url: question.url)
                        : Image.network(question.url)),
            SizedBox(
              height: 25.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 60.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                "${question.description}",
                style: TextStyle(
                    // color: question.type == "video" ? Colors.white : Colors.red,
                    color: Theme.of(context).primaryColor,
                    fontSize: 25.0),
              ),
            )
          ]));
    }

    ValidateCheckbox(String type) {
      // проверка на валидацию заполненных значений формы
      switch (type) {
        case 'radio':
          if (answerCheck == null) {
            return true;
          } else {
            return false;
          }
          break;
        case 'checkbox':
          if (answ1check == false && answ2check == false && answ3check == false)
            return true;
          else
            return false;

          break;
        default:
          return false;
      }
    }

    ChooseType(String type) {
      //функция подстановки необходимого типа вопроса (радио, чекбокс, лекция)
      switch (type) {
        case 'radio':
          return Container(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                QuestionBody(
                    question) //подстановка повторяющейся группы виджетов
                ,
                Container(
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 3,
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
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
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (AnswerList value) {
                              setState(() {
                                answerCheck = value;
                              });
                            }),
                        RadioListTile(
                            title: Text(question.answer2),
                            value: AnswerList.answer2,
                            groupValue: answerCheck,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (AnswerList value) {
                              setState(() {
                                answerCheck = value;
                              });
                            }),
                        RadioListTile(
                            title: Text(question.answer3),
                            value: AnswerList.answer3,
                            groupValue: answerCheck,
                            activeColor: Theme.of(context).primaryColor,
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
          break; // при выполнении этого кэйса, при его завершении прекращаем выполнение всего остального свича
        case 'checkbox':
          return Container(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                QuestionBody(question),
                Container(
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 3,
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
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
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(question.answer1),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool value) =>
                                setState(() => answ1check = value)),
                        CheckboxListTile(
                            value: answ2check,
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(question.answer2),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool value) =>
                                setState(() => answ2check = value)),
                        CheckboxListTile(
                            value: answ3check,
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(question.answer3),
                            controlAffinity: ListTileControlAffinity.leading,
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
          return QuestionBody(question);
          break;
        case 'video':
          return QuestionBody(question);
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

    Widget ScrollElement() {
      return Column(children: [
        Expanded(
            flex: 1,
            child: BreadDots(
              title: AppLocalizations.of(context).breadDotsCard,
            )),
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: TweenAnimationBuilder(
                        // анимация которая вынесла весь мозг, работает через твины передвижения, без билдера не сработает
                        tween: Tween<Offset>(
                            begin: Offset(startPos, 0), end: Offset(endPos, 0)),
                        duration: Duration(milliseconds: 250),
                        curve: curve,
                        builder: (context, offset, child) {
                          return FractionalTranslation(
                            // добавление виджета, который оборачивает в себя анимированные объекты
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
                        child: ChooseType(
                            question.type), // объект который анимируется
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
        ),
      ]);
    }

    return Scaffold(
      //скаффолд один из самых главных виджетов материал дизайна
      appBar: AppBar(
        title: Text(
            "${AppLocalizations.of(context).chooseCourse} ${widget._course}",
            style: TextStyle(
              fontSize: 22.0,
            )),
        centerTitle: true,
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: DrawerItem(),
            ),
      //боковая менюшка
      body: SafeArea(
        child: Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              //задание заднего фона
              image: AssetImage("assets/images/polytech_logo.png"),
              // alignment: Alignment.center
            )),
            child: MediaQuery.of(context).size.width < 600
                ? ScrollElement()
                : Row(
                    children: [
                      Container(
                        child: DrawerItem(),
                        width: 200,
                      ),
                      Container(
                        child: ScrollElement(),
                        width: MediaQuery.of(context).size.width - 200,
                      ),
                    ],
                  )),
      ),
      bottomNavigationBar: BottomAppBar(
        //наиболее лучшая реализация кнопок вперед назад чтобы они были прифлочены к нижней границе
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: MaterialButton(
                elevation: 5.0,
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(10),
                onPressed: answId == 0 ||
                        ValidateCheckbox(question
                            .type) //теренарные операторы наше все, позволяют задавать элс иф внутри виджетов
                    ? null
                    : () => {
                          setState(() {
                            // при нажатии кнопки определяем в какую сторону сдвигается анимация, меняем id элемента списка и обнуляем все значения, в будущем, надо будет сначала сохранять значения, а потом обнулять
                            endPos = -1.5;
                            answId--;
                            answerCheck = null;
                            answ1check = false;
                            answ2check = false;
                            answ3check = false;
                            // _videoController.pause();
                          }),
                          chooseQuestion(answId) //вызываем смену вопроса
                        },
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor),
                      text: AppLocalizations.of(context).back),
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: MaterialButton(
                elevation: 5.0,
                color: Theme.of(context).accentColor,
                padding: EdgeInsets.all(10),
                onPressed: answId == answers.length - 1 ||
                        ValidateCheckbox(question.type)
                    ? null
                    : () => {
                          setState(() {
                            endPos = 1.5;
                            answId++;
                            answerCheck = null;
                            answ1check = false;
                            answ2check = false;
                            answ3check = false;
                            // _videoController.pause();
                          }),
                          chooseQuestion(answId)
                        },
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor),
                      text: AppLocalizations.of(context).next),
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    answers.clear();
    answId = 0;

    super.dispose();
  }
}
