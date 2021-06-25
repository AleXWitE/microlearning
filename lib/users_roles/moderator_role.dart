import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/components/bread_dots.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModeratorRole extends StatefulWidget {
  @override
  _ModeratorRoleState createState() => _ModeratorRoleState();
}

class _ModeratorRoleState extends State<ModeratorRole> {
  final _keyAddCourseModer = GlobalKey<FormState>();
  final _keyAddCourseModerUpdate = GlobalKey<FormState>();
  final _keyAddCourseCardModer = GlobalKey<FormState>();
  final _keyAddCourseCardModerUpdate = GlobalKey<FormState>();

  TextEditingController _textControllerModCardName = TextEditingController();
  TextEditingController _textControllerModCardQuestion =
      TextEditingController();
  TextEditingController _textControllerModCardUrl = TextEditingController();

  TextEditingController _textControllerModCourse = TextEditingController();
  TextEditingController _textControllerModAnswer1 = TextEditingController();
  TextEditingController _textControllerModAnswer2 = TextEditingController();
  TextEditingController _textControllerModAnswer3 = TextEditingController();
  TextEditingController _textControllerModAnswerCorrect =
      TextEditingController();

  String _title = "";

  final _controller = PageController(initialPage: 0);
  int _selectedIndex = 0;

  int _cardId;

  Curve curve = Curves.decelerate;

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

  String _cardNameUpdate;
  String _cardQuestionUpdate;
  String _cardContentUrlUpdate;

  Courses selectedCourseInCard;
  Courses selectedCourseUpdate;
  String selectedCardType;
  String selectedCardTypeUpdate;
  String selectedCardUpdate;

  List<Courses> _courses = [];
  List<String> _cards = [];

  List<String> row = ['1', '2', '3', 'current'];

  List<String> _typeCard = ["radio", "checkbox", "lecture", "video"];

  var databaseRef = FirebaseFirestore.instance
      .collection('divisions')
      .doc(userDivision)
      .collection('courses');

  int _lastId = 0;

  @override
  void initState() {
    super.initState();
    databaseRef.get().then((value) => value.docs.forEach((element) {
          setState(() {
            // _courses.clear();
            _courses.add(
                Courses(course: element.id, division: element.data()['title']));
          });
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
        color: Theme.of(context).primaryColor,
        height: 50.0,
        child: Center(
          child: Text(
            _name,
            style:
                TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
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

  Widget answInput(String _i) {
    return Container(
      margin: EdgeInsets.only(left: 50.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty && _i != 'current')
            return AppLocalizations.of(context).wrongAnswer;
          else if (value != _answer1 &&
              value != _answer2 &&
              value != _answer3 &&
              _i == 'current')
            return AppLocalizations.of(context).wrongCurrentAnswer;
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
        controller: _i == '1'
            ? _textControllerModAnswer1
            : _i == '2'
                ? _textControllerModAnswer2
                : _i == '3'
                    ? _textControllerModAnswer3
                    : _textControllerModAnswerCorrect,
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
              ? AppLocalizations.of(context).answer + ' $_i'
              : AppLocalizations.of(context).curAnswer,
          focusColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _butList = [
      AppLocalizations.of(context).addCourse,
      AppLocalizations.of(context).addCourseCard,
    ];

    final List<String> _butListUpdate = [
      AppLocalizations.of(context).updateCourse,
      AppLocalizations.of(context).updateCourseCard,
    ];

    courseForm() {
      bool _courseValidate() {
        final _formCourse = _keyAddCourseModer.currentState;
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
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something wrong"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddCourseModer,
            child: ListView(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context).courseError;
                    else
                      _courseName = value;
                  },
                  onSaved: (value) => _courseName = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).courseName,
                    focusColor: Theme.of(context).primaryColor,
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
                    AppLocalizations.of(context).add,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 22.0),
                  ),
                ),
              ],
            )),
      );
    }

    courseFormUpdate() {
      bool _courseValidate() {
        final _formCourse = _keyAddCourseModerUpdate.currentState;
        if (_formCourse.validate()) {
          _formCourse.save();
          return true;
        }
        return false;
      }

      void _onSavedCourse() {
        if (_courseValidate()) {
          databaseRef
              .doc(selectedCourseUpdate.division)
              .set({'title': _courseName});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Course ${selectedCourseUpdate.division} updated to $_courseName"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something wrong"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddCourseModerUpdate,
            child: ListView(
              children: [
                DropdownButton<Courses>(
                    hint: _courses.isEmpty
                        ? Text(AppLocalizations.of(context).emptyCoursesInDiv)
                        : Text(AppLocalizations.of(context).dropdownCourse),
                    value: selectedCourseUpdate,
                    onChanged: (value) {
                      setState(() {
                        selectedCourseUpdate = value;
                        _textControllerModCourse.text =
                            selectedCourseUpdate.course;
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
                  controller: _textControllerModCourse,
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context).courseError;
                    else
                      _courseName = value;
                  },
                  onSaved: (value) => _courseName = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).courseName,
                    focusColor: Theme.of(context).primaryColor,
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.0),
                OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ))),
                  onPressed: () async {
                    _onSavedCourse();
                    print("click!");
                  },
                  child: Text(
                    AppLocalizations.of(context).update,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 22.0),
                  ),
                ),
              ],
            )),
      );
    }

    cardForm() {
      bool _cardValidate() {
        final _formCard = _keyAddCourseCardModer.currentState;
        if (_formCard.validate()) {
          _formCard.save();
          return true;
        }
        return false;
      }

      void _onSavedCard() {
        if (_cardValidate()) {
          databaseRef
              .doc(selectedCourseInCard.course)
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
            'id': _lastId,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Card $_cardName in course ${selectedCourseInCard.course} added. Card id $_lastId"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something wrong"),
          ));
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _keyAddCourseCardModer,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButton<Courses>(
                  hint: _courses.isEmpty
                      ? Text(AppLocalizations.of(context).emptyCoursesInDiv)
                      : Text(AppLocalizations.of(context).dropdownCourse),
                  value: selectedCourseInCard,
                  onChanged: (value) {
                    setState(() {
                      selectedCourseInCard = value;
                      databaseRef
                          .doc(selectedCourseInCard.course)
                          .collection('cards')
                          .orderBy('id')
                          .get()
                          .then((value) => _lastId = value.size);
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
                    return AppLocalizations.of(context).cardNameError;
                  else
                    _cardName = value;
                },
                onSaved: (value) => _cardName = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).cardName,
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<String>(
                  hint: Text(AppLocalizations.of(context).dropdownType),
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
                    return AppLocalizations.of(context).cardQuestionError;
                  else
                    _cardName = value;
                },
                minLines: 1,
                maxLines: 15,
                onSaved: (value) => _cardQuestion = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).cardQuestion,
                  focusColor: Theme.of(context).primaryColor,
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
                  labelText: AppLocalizations.of(context).cardContentUrl,
                  focusColor: Theme.of(context).primaryColor,
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
                  setState(() {
                    _lastId++;
                  });
                  // _cardValidate();
                  _onSavedCard();
                  print("click!");
                },
                child: Text(
                  AppLocalizations.of(context).add,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 22.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    cardFormUpdate() {
      bool _cardValidate() {
        final _formCard = _keyAddCourseCardModerUpdate.currentState;
        if (_formCard.validate()) {
          _formCard.save();
          return true;
        }
        return false;
      }

      void _onSavedCard() async {
        if (_cardValidate()) {
          await databaseRef
              .doc(selectedCourseInCard.division)
              .collection('cards')
              .doc(selectedCardUpdate)
              .delete();

          await databaseRef
              .doc(selectedCourseInCard.division)
              .collection('cards')
              .doc(_cardNameUpdate)
              .set(
                  {
                'card_title': _cardNameUpdate,
                'card_type': selectedCardTypeUpdate,
                'card_question': _cardQuestionUpdate,
                'card_answers': {
                  'answer_1': _answer1,
                  'answer_2': _answer2,
                  'answer_3': _answer3,
                  'correct_answer': _answerCurrent,
                },
                'card_url': _cardContentUrlUpdate,
                'id': _cardId,
              },
                  SetOptions(
                    merge: true,
                  ));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Card $_cardName in course ${selectedCourseInCard.course} added"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something wrong"),
          ));
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _keyAddCourseCardModerUpdate,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButton<Courses>(
                  hint: _courses.isEmpty
                      ? Text(AppLocalizations.of(context).emptyCoursesInDiv)
                      : Text(AppLocalizations.of(context).dropdownCourse),
                  value: selectedCourseInCard,
                  onChanged: (value) {
                    setState(() {
                      selectedCourseInCard = value;
                    });
                    databaseRef
                        .doc(selectedCourseInCard.division)
                        .collection('cards')
                        .get()
                        .then((value) {
                      setState(() {
                        _cards.clear();
                        value.docs.forEach((element) {
                          _cards.add(element.data()['card_title']);
                        });
                      });
                    });
                  },
                  items: _courses.map((item) {
                    return DropdownMenuItem<Courses>(
                        value: item, child: Text(item.course));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<String>(
                  hint: _cards.isEmpty
                      ? Text(AppLocalizations.of(context).emptyCardsInCourse)
                      : Text(AppLocalizations.of(context).dropdownCard),
                  value: selectedCardUpdate,
                  onChanged: (value) {
                    setState(() {
                      selectedCardUpdate = value;
                    });
                    databaseRef
                        .doc(selectedCourseInCard.division)
                        .collection('cards')
                        .doc(selectedCardUpdate)
                        .get()
                        .then((value) {
                      setState(() {
                        _textControllerModCardName.text =
                            value.data()['card_title'];
                        _textControllerModCardQuestion.text =
                            value.data()['card_question'];
                        selectedCardTypeUpdate = value.data()['card_type'];
                        _textControllerModCardUrl.text =
                            value.data()['card_url'];
                        _textControllerModAnswer1.text =
                            value.data()['card_answers']['answer_1'];
                        _textControllerModAnswer2.text =
                            value.data()['card_answers']['answer_2'];
                        _textControllerModAnswer3.text =
                            value.data()['card_answers']['answer_3'];
                        _textControllerModAnswerCorrect.text =
                            value.data()['card_answers']['correct_answer'];
                        _cardId = value.data()['id'];
                      });
                    });
                  },
                  items: _cards.map((item) {
                    return DropdownMenuItem<String>(
                        value: item, child: Text(item));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _textControllerModCardName,
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).cardNameError;
                  else
                    _cardName = value;
                },
                onSaved: (value) => _cardName = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).cardName,
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<String>(
                  hint: Text(AppLocalizations.of(context).dropdownType),
                  value: selectedCardTypeUpdate,
                  onChanged: (value) {
                    setState(() {
                      selectedCardTypeUpdate = value;
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
                controller: _textControllerModCardQuestion,
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).cardQuestionError;
                  else
                    _cardName = value;
                },
                onSaved: (value) => _cardQuestion = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).cardQuestion,
                  focusColor: Theme.of(context).primaryColor,
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
                controller: _textControllerModCardUrl,
                onSaved: (value) => _cardContentUrl = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).cardContentUrl,
                  focusColor: Theme.of(context).primaryColor,
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
                  AppLocalizations.of(context).update,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 22.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    _formColumnCreate() {
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

    _formColumnUpdate() {
      return Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListUpdate[0], 0))),
          _visibleCourse
              ? Expanded(flex: 13, child: courseFormUpdate())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListUpdate[1], 1))),
          _visibleCard
              ? Expanded(flex: 13, child: cardFormUpdate())
              : Container(),
        ],
      );
    }

    final List<String> _chooseActions = [
      AppLocalizations.of(context).create,
      AppLocalizations.of(context).update,
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          _title = AppLocalizations.of(context).adminBlock;
          _controller.animateToPage(0,
              duration: Duration(milliseconds: 800), curve: curve);
        } else {
          _title = AppLocalizations.of(context).adminBlockUpdate;
          _controller.animateToPage(1,
              duration: Duration(milliseconds: 800), curve: curve);
        }
      });
    }

    return userRole != 'moderator'
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(_title),
            ),
            drawer: MediaQuery.of(context).size.width > 600
                ? null
                : Drawer(
                    child: DrawerItem(),
                  ),
            body: MediaQuery.of(context).size.width < 600
                ? Column(children: [
                    Expanded(
                        flex: 1,
                        child: BreadDots(
                          title: AppLocalizations.of(context).breadDotsPanel,
                        )),
                    Expanded(
                      flex: 9,
                      child: Center(
                        child: Text(AppLocalizations.of(context).notModerator),
                      ),
                    ),
                  ])
                : Row(
                    children: [
                      Container(
                        width: 200,
                        child: DrawerItem(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Column(children: [
                          Expanded(
                              flex: 1,
                              child: BreadDots(
                                title:
                                    AppLocalizations.of(context).breadDotsPanel,
                              )),
                          Expanded(
                            flex: 9,
                            child: Center(
                              child: Text(
                                  AppLocalizations.of(context).notModerator),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).adminBlock),
              // actions: [widgetActions()],
            ),
            drawer: MediaQuery.of(context).size.width > 600
                ? null
                : Drawer(
                    child: DrawerItem(),
                  ),
            body: SafeArea(
              // child: ListView(
              //   shrinkWrap: true,
              child: MediaQuery.of(context).size.width < 600
                  ? Column(children: [
                      Expanded(
                          flex: 1,
                          child: BreadDots(
                            title: AppLocalizations.of(context).breadDotsPanel,
                          )),
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: _onItemTapped,
                            children: [
                              _formColumnCreate(),
                              _formColumnUpdate()
                            ],
                          ),
                        ),
                      ),
                    ])
                  : Row(
                      children: [
                        Container(
                          width: 200,
                          child: DrawerItem(),
                        ),
                        Column(children: [
                          Expanded(
                              flex: 1,
                              child: BreadDots(
                                title:
                                    AppLocalizations.of(context).breadDotsPanel,
                              )),
                          Expanded(
                            flex: 9,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Container(
                                child: PageView(
                                  controller: _controller,
                                  onPageChanged: _onItemTapped,
                                  children: [
                                    _formColumnCreate(),
                                    _formColumnUpdate()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ])
                      ],
                    ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedIconTheme: IconThemeData(
                  color: Theme.of(context).accentColor, opacity: 1.0, size: 45),
              unselectedIconTheme: IconThemeData(
                  color: Colors.grey[500], opacity: 0.5, size: 25),
              items: [
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context).add,
                    icon: Icon(Icons.add),
                    tooltip: AppLocalizations.of(context).add),
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context).update,
                    icon: Icon(Icons.update),
                    tooltip: AppLocalizations.of(context).update),
              ],
              currentIndex: _selectedIndex,
              backgroundColor: Theme.of(context).primaryColor,
              selectedItemColor: Theme.of(context).accentColor,
              unselectedItemColor: Colors.grey[500],
              onTap: _onItemTapped,
            ),
          );
  }
}
