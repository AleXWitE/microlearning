import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/models/drawer_item.dart';

class AdminRole extends StatefulWidget {
  @override
  _AdminRoleState createState() => _AdminRoleState();
}

class _AdminRoleState extends State<AdminRole> {
  final _keyDivision = GlobalKey<FormState>();
  final _keyAddModerator = GlobalKey<FormState>();
  final _keyAddCourse = GlobalKey<FormState>();
  final _keyAddCourseCard = GlobalKey<FormState>();

  final databaseRefUsers = FirebaseFirestore.instance.collection('users');
  final databaseRefDivs = FirebaseFirestore.instance.collection('divisions');

  List<Users> _users = [];
  List<Users> _usersInDiv = [];
  List<Divisions> _divisions = [];
  List<Courses> _courses = [];

  List<String> _typeCard = ["radio", "checkbox", "lecture", "video"];

  Divisions selectedDivision;
  Divisions selectedDivisionInCourse;
  Divisions selectedDivisionInCard;
  Courses selectedCourseInCard;
  String selectedCardType;
  Users selectedModUser;

  String _divName;
  String _divModName;

  String _modName;
  String _modDivName;

  String _courseName;
  String _courseDiv;

  String _cardDiv;
  String _cardName;
  String _cardCourse;
  String _cardQuestion;
  String _cardContentUrl;
  String _answer1;
  String _answer2;
  String _answer3;
  String _answerCurrent;

  bool _visibleDiv = true;
  bool _visibleMod = false;
  bool _visibleCourse = false;
  bool _visibleCard = false;

  String _cardType;

  Future clearList() async {
    // setState(() {
    _users.clear();
    _divisions.clear();
    // });
  }

  getData() async {
    await databaseRefUsers.get().then((value) => value.docs.forEach((element) {
          _users.add(Users(email: element.id));
          print(element.id);
        }));
    await databaseRefDivs.get().then((value) => value.docs.forEach((element) {
          _divisions.add(Divisions(division: element.id));
          print(element.id);
        }));
    selectedDivision = _divisions.first;
    selectedDivisionInCourse = _divisions.first;
    selectedDivisionInCard = _divisions.first;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _butList = [
      (AppLocalizations.of(context).addDivision),
      AppLocalizations.of(context).addModerator,
      AppLocalizations.of(context).addCourse,
      AppLocalizations.of(context).addCourseCard,
    ];

    materialButList(String _name, int _id) {
      var currentState;

      visDivision() {
        setState(() {
          _visibleDiv = true;
          _visibleMod = false;
          _visibleCourse = false;
          _visibleCard = false;
        });
      }

      visModerator() {
        setState(() {
          _visibleDiv = false;
          _visibleMod = true;
          _visibleCourse = false;
          _visibleCard = false;
        });
      }

      visCourse() {
        setState(() {
          _visibleDiv = false;
          _visibleMod = false;
          _visibleCourse = true;
          _visibleCard = false;
        });
      }

      visCard() {
        setState(() {
          _visibleDiv = false;
          _visibleMod = false;
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
              style: TextStyle(
                  fontSize: 20.0, color: Theme.of(context).accentColor),
            ),
          ),
          onPressed: () {
            switch (_id) {
              case 0:
                currentState = visDivision();
                break;
              case 1:
                currentState = visModerator();
                break;
              case 2:
                currentState = visCourse();
                break;
              case 3:
                currentState = visCard();
                break;
            }
          });
    }

    divForm() {
      bool _divValidate() {
        final _formDivision = _keyDivision.currentState;
        if (_formDivision.validate()) {
          _formDivision.save();
          return true;
        }
        return false;
      }

      void _saveDivision(String _div) {
        databaseRefDivs.doc(_div).set({
          'title': _div,
          'add': true,
        }, SetOptions(merge: true));
      }

      void _onSavedDivision() {
        if (_divValidate()) {
          _saveDivision(_divName);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${AppLocalizations.of(context).division} $_divName added"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyDivision,
            child: ListView(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context).divisionError;
                    else
                      _divName = value;
                  },
                  onSaved: (value) => _divName = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).division,
                    focusColor: Theme.of(context).primaryColor,
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  // Модератор может быть добавлен вручную через панель, поэтому данная валидация закомментирована
                  // validator: (value) {
                  //   if (value.isEmpty)
                  //     return AppLocalizations.of(context).divisionError;
                  //   else
                  //     _divName = value;
                  // },
                  onSaved: (value) => _divModName = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).moderator,
                    focusColor: Theme.of(context).primaryColor,
                  ),
                  keyboardType: TextInputType.text,
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
                    _onSavedDivision();
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

    modForm() {
      bool _modValidate() {
        final _formModerator = _keyAddModerator.currentState;
        if (_formModerator.validate()) {
          _formModerator.save();
          return true;
        }
        return false;
      }

      // databaseRefUsers.get().then((value) => _usersInDiv.add(value.docs
      //     .where((element) => element.data()['user_division'] == _modDivName)
      //     .toString()));

      void _onSavedModerator() {
        if (_modValidate()) {
          databaseRefUsers.doc(selectedModUser.email).update({
            'user_role': 'moderator',
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User ${selectedModUser.email} updated to moderator"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddModerator,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivision,
                    onChanged: (value) async {
                       setState(() {
                        selectedDivision = value;
                        if (_usersInDiv.isNotEmpty) _usersInDiv.clear();

                      });

                       await databaseRefUsers.get().then((value) {
                         value.docs.forEach((element) {
                           if (element.data()['user_division'] ==
                               selectedDivision.division)
                             setState(() {
                               _usersInDiv.add(Users(email: element.id));
                             });
                         });
                       });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.division));
                    }).toList()),
                SizedBox(height: 20.0),
                DropdownButton<Users>(
                    hint: _usersInDiv.isEmpty
                        ? Text(AppLocalizations.of(context).emptyModUserInDiv)
                        : Text(AppLocalizations.of(context).dropdownModerator),
                    value: selectedModUser,
                    onChanged: (value) {
                      setState(() {
                        selectedModUser = value;
                      });
                    },
                    items: _usersInDiv.map((item) {
                      return DropdownMenuItem<Users>(
                          value: item, child: Text(item.email));
                    }).toList()),
                SizedBox(
                  height: 25.0,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ))),
                  onPressed: /*selectedModUser.email.isNotEmpty ? null :*/ () {
                    _onSavedModerator();
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
          databaseRefDivs
              .doc(selectedDivisionInCourse.division)
              .collection('courses')
              .doc(_courseName)
              .set({'title': _courseName});

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${AppLocalizations.of(context).courseName} $_courseName added"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
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
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivisionInCourse,
                    onChanged: (value) {
                      setState(() {
                        selectedDivisionInCourse = value;
                      });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.division));
                    }).toList()),
                SizedBox(
                  height: 25.0,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ))),
                  onPressed: () {
                    _onSavedCourse();
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
          databaseRefDivs
              .doc(selectedDivisionInCard.division)
              .collection('courses')
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
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Card $_cardName added to course ${selectedCourseInCard.course}"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
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

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _keyAddCourseCard,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButton<Divisions>(
                  hint: Text(AppLocalizations.of(context).dropdownDivisions),
                  value: selectedDivisionInCard,
                  onChanged: (value) async {
                    setState(() {
                      selectedDivisionInCard = value;
                    });

                      await databaseRefDivs
                          .doc(selectedDivisionInCard.division)
                          .collection('courses')
                          .get()
                          .then((value) {
                            _courses.clear();
                        value.docs.forEach((element) {
                          _courses.add(Courses(course: element.id));
                        });
                      });
                  },
                  items: _divisions.map((item) {
                    return DropdownMenuItem<Divisions>(
                        value: item, child: Text(item.division));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<Courses>(
                  hint: _courses.isEmpty
                      ? Text(AppLocalizations.of(context).emptyCoursesInDiv)
                      : Text(AppLocalizations.of(context).dropdownCourse),
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

    _formColumn() {
      return Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butList[0], 0))),
          _visibleDiv ? Expanded(flex: 10, child: divForm()) : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butList[1], 1))),
          _visibleMod ? Expanded(flex: 10, child: modForm()) : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butList[2], 2))),
          _visibleCourse
              ? Expanded(flex: 10, child: courseForm())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butList[3], 3))),
          _visibleCard ? Expanded(flex: 10, child: cardForm()) : Container(),
        ],
      );
    }

    return userRole != 'admin'
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).adminBlock, style: TextStyle(fontSize: 22.0),),
            ),
            drawer: MediaQuery.of(context).size.width > 600
                ? null
                : Drawer(
                    child: DrawerItem(),
                  ),
            body: MediaQuery.of(context).size.width < 600
                ? Center(
                    child: Text(AppLocalizations.of(context).notAdmin),
                  )
                : Row(
                    children: [
                      Container(
                        width: 200,
                        child: DrawerItem(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Center(
                          child: Text(AppLocalizations.of(context).notAdmin),
                        ),
                      )
                    ],
                  ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).adminBlock),
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
                  ? _formColumn()
                  : Row(
                      children: [
                        Container(
                          width: 200,
                          child: DrawerItem(),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: _formColumn(),
                        )
                      ],
                    ),
            ),
          );
  }
}
//  flutter config --android-studio-dir=