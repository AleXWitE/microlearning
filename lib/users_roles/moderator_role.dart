import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModeratorRole extends StatefulWidget {
  @override
  _ModeratorRoleState createState() => _ModeratorRoleState();
}

class _ModeratorRoleState extends State<ModeratorRole> {
  final _keyAddCourse = GlobalKey<FormState>();
  final _keyAddCourseCard = GlobalKey<FormState>();

  bool _visibleCourse = true;
  bool _visibleCard = false;

  String _courseName;

  String _cardName;
  String _cardQuestion;
  String _cardContentUrl;
  String _answer1;
  String _answer2;
  String _answer3;
  String _answerCurrent;

  Courses selectedCourseInCard;
  String selectedCardType;

  List<Courses> _courses = [];

  List<String> _typeCard = ["radio", "checkbox", "lecture", "video"];


  var databaseRef = FirebaseFirestore.instance.collection('divisions').doc(
      userDivision).collection('courses');

  @override
  void initState() {
    super.initState();
    databaseRef.get().then((value) =>
        value.docs.forEach((element) {
          _courses.add(Courses(course: element.id));
        }));
  }

  materialButList(String _name, int _id) {
    var currentState;

    visCourse() {
      setState(() {
        _visibleCourse = true;
        _visibleCard = false;
      });
    }

    visCard() {
      setState(() {
        _visibleCourse = false;
        _visibleCard = true;
      });
    }

    return MaterialButton(
        color: Theme
            .of(context)
            .primaryColor,
        height: 50.0,
        child: Center(
          child: Text(
            _name,
            style:
            TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor),
          ),
        ),
        onPressed: () {
          switch (_id) {
            case 0:
              currentState = visCourse();
              break;
            case 1:
              currentState = visCard();
              break;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _butList = [
      AppLocalizations
          .of(context)
          .addCourse,
      AppLocalizations
          .of(context)
          .addCourseCard,
    ];

    courseForm() {
      bool _courseValidate() {
        final _formCourse = _keyAddCourse.currentState;
        if (_formCourse.validate()) {
          _formCourse.save();
          return true;
        }
        return false;
      }

      void _onSavedCourse() {
        if (_courseValidate()) {
          databaseRef.doc(_courseName).set({'title': _courseName});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Course $_courseName added"),
          ));
        }
        else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something wrong"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddCourse,
            child: ListView(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations
                          .of(context)
                          .courseError;
                    else
                      _courseName = value;
                  },
                  onSaved: (value) => _courseName = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations
                        .of(context)
                        .courseName,
                    focusColor: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.0),
                OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ))),
                  onPressed: () {
                    _onSavedCourse();
                    print("click!");
                  },
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .add,
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor, fontSize: 22.0),
                  ),
                ),
              ],
            )),
      );
    }

    cardForm() {
      List<String> row = ['1', '2', '3', 'current'];

      bool _cardValidate() {
        final _formCard = _keyAddCourseCard.currentState;
        if (_formCard.validate()) {
          _formCard.save();
          return true;
        }
        return false;
      }

      void _onSavedCard() {
        if (_cardValidate()) {
          databaseRef.doc(selectedCourseInCard.course)
              .collection('cards')
              .doc(_cardName)
              .set({
            'card_title': _cardName,
            'card_type': selectedCardType,
            'card_question': _cardQuestion,
            'card_answers': {
              'answer_1': _answer1,
              'answer_2': _answer2,
              'answer_3': _answer3,
              'correct_answer': _answerCurrent,
            },
            'card_url': _cardContentUrl,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Card $_cardName in course ${selectedCourseInCard
                .course} added"),
          ));
        }
        else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something wrong"),
          ));
      }

      Widget answInput(String _i) {
        return Container(
          margin: EdgeInsets.only(left: 50.0),
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty && _i != 'current')
                return AppLocalizations
                    .of(context)
                    .wrongAnswer;
              else if (value != _answer1 &&
                  value != _answer2 &&
                  value != _answer3 &&
                  _i == 'current')
                return AppLocalizations
                    .of(context)
                    .wrongCurrentAnswer;
              else
                setState(() {
                  switch (_i) {
                    case '1':
                      _answer1 = value;
                      break;
                    case '2':
                      _answer2 = value;
                      break;
                    case '3':
                      _answer3 = value;
                      break;
                    case 'current':
                      _answerCurrent = value;
                      break;
                  }
                });
            },
            onSaved: (value) {
              setState(() {
                switch (_i) {
                  case '1':
                    _answer1 = value;
                    break;
                  case '2':
                    _answer2 = value;
                    break;
                  case '3':
                    _answer3 = value;
                    break;
                  case 'current':
                    _answerCurrent = value;
                    break;
                }
              });
            },
            decoration: InputDecoration(
              labelText: _i != 'current'
                  ? AppLocalizations
                  .of(context)
                  .answer + ' $_i'
                  : AppLocalizations
                  .of(context)
                  .curAnswer,
              focusColor: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
        );
      }

      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _keyAddCourseCard,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButton<Courses>(
                  hint: _courses.isEmpty
                      ? Text(AppLocalizations
                      .of(context)
                      .emptyCoursesInDiv)
                      : Text(AppLocalizations
                      .of(context)
                      .dropdownCourse),
                  value: selectedCourseInCard,
                  onChanged: (value) {
                    setState(() {
                      selectedCourseInCard = value;
                    });
                  },
                  items: _courses.map((item) {
                    return DropdownMenuItem<Courses>(
                        value: item, child: Text(item.course));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations
                        .of(context)
                        .cardNameError;
                  else
                    _cardName = value;
                },
                onSaved: (value) => _cardName = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations
                      .of(context)
                      .cardName,
                  focusColor: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<String>(
                  hint: Text(AppLocalizations
                      .of(context)
                      .dropdownType),
                  value: selectedCardType,
                  onChanged: (value) {
                    setState(() {
                      selectedCardType = value;
                    });
                  },
                  items: _typeCard.map((item) {
                    return DropdownMenuItem<String>(
                        value: item, child: Text(item));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations
                        .of(context)
                        .cardQuestionError;
                  else
                    _cardName = value;
                },
                onSaved: (value) => _cardQuestion = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations
                      .of(context)
                      .cardQuestion,
                  focusColor: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              for (var i in row) answInput(i), //генерация списка ввода текста
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onSaved: (value) => _cardContentUrl = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations
                      .of(context)
                      .cardContentUrl,
                  focusColor: Theme
                      .of(context)
                      .primaryColor,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              OutlinedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ))),
                onPressed: () {
                  // _cardValidate();
                  _onSavedCard();
                  print("click!");
                },
                child: Text(
                  AppLocalizations
                      .of(context)
                      .add,
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColor, fontSize: 22.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    _formColumn() {
      return Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butList[0], 0))),
          _visibleCourse
              ? Expanded(flex: 13, child: courseForm())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butList[1], 1))),
          _visibleCard ? Expanded(flex: 13, child: cardForm()) : Container(),
        ],
      );
    }

    return userRole != 'moderator'
        ? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations
            .of(context)
            .adminBlock),
      ),
      drawer: MediaQuery
          .of(context)
          .size
          .width > 600
          ? null
          : Drawer(
        child: DrawerItem(),
      ),
      body: MediaQuery
          .of(context)
          .size
          .width < 600
          ? Center(
        child: Text(AppLocalizations
            .of(context)
            .notModerator),
      )
          : Row(
        children: [
          Container(
            width: 200,
            child: DrawerItem(),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 200,
            child: Center(
              child: Text(AppLocalizations
                  .of(context)
                  .notAdmin),
            ),
          )
        ],
      ),
    )
        : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations
            .of(context)
            .adminBlock),
      ),
      drawer: MediaQuery
          .of(context)
          .size
          .width > 600
          ? null
          : Drawer(
        child: DrawerItem(),
      ),
      body: SafeArea(
        // child: ListView(
        //   shrinkWrap: true,
        child: MediaQuery
            .of(context)
            .size
            .width < 600
            ? _formColumn()
            : Row(
          children: [
            Container(
              width: 200,
              child: DrawerItem(),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 200,
              child: _formColumn(),
            )
          ],
        ),
      ),
    );
  }
}
