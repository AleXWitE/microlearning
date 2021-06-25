import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microlearning/components/bread_dots.dart';
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

  final _keyDivisionUpdate = GlobalKey<FormState>();
  final _keyAddModeratorUpdate = GlobalKey<FormState>();
  final _keyAddCourseUpdate = GlobalKey<FormState>();
  final _keyAddCourseCardUpdate = GlobalKey<FormState>();

  final _keyDivisionDelete = GlobalKey<FormState>();
  final _keyAddModeratorDelete = GlobalKey<FormState>();
  final _keyAddCourseDelete = GlobalKey<FormState>();
  final _keyAddCourseCardDelete = GlobalKey<FormState>();

  String _title = "";
  TextEditingController _textControllerCardName = TextEditingController();
  TextEditingController _textControllerCardQuestion = TextEditingController();
  TextEditingController _textControllerCardAnswer1 = TextEditingController();
  TextEditingController _textControllerCardAnswer2 = TextEditingController();
  TextEditingController _textControllerCardAnswer3 = TextEditingController();
  TextEditingController _textControllerCardAnswerCorrect =
      TextEditingController();
  TextEditingController _textControllerCardUrl = TextEditingController();
  TextEditingController _textControllerCourse = TextEditingController();
  TextEditingController _textControllerDiv = TextEditingController();

  final databaseRefUsers = FirebaseFirestore.instance.collection('users');
  final databaseRefDivs = FirebaseFirestore.instance.collection('divisions');

  List<Users> _users = [];
  List<Users> _usersInDiv = [];
  List<Users> _oldUsersInDiv = [];
  List<Users> _newUsersInDiv = [];
  List<Divisions> _divisions = [];
  List<Courses> _courses = [];
  List<String> _cards = [];

  List<String> _typeCard = ["radio", "checkbox", "lecture", "video"];

  Divisions selectedDivision;
  Divisions selectedDivisionInCourse;
  Divisions selectedDivisionInCard;
  Courses selectedCourseInCard;
  String selectedCardType;
  Users selectedModUser;

  Divisions selectedDivisionUpdate;
  Divisions selectedDivModUpdate;
  Divisions selectedDivisionInCourseUpdate;
  Divisions selectedDivisionInCardUpdate;
  Courses selectedCourseUpdate;
  Courses selectedCourseDelete;
  Courses selectedCourseInCardUpdate;
  String selectedCardTypeUpdate;
  String selectedCardUpdate;
  Users selectedNewModUserUpdate;
  Users selectedOldModUserUpdate;

  Divisions selectedDivisionDelete;
  Divisions selectedDivisionInCourseDelete;
  Divisions selectedDivisionInCardDelete;
  Courses selectedCourseInCardDelete;
  String selectedCardTypeDelete;
  Users selectedModUserDelete;
  String selectedCardDelete;

  String _divName;

  String _divNameUpdate;

  String _courseName;

  String _courseNameUpdate;

  String _courseNameDelete;

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

  String initCardAnswer1 = "";
  String initCardAnswer2 = "";
  String initCardAnswer3 = "";
  String initCardAnswerCorrect = "";

  bool _visibleDiv = true;
  bool _visibleMod = false;
  bool _visibleCourse = false;
  bool _visibleCard = false;

  int _lastId = 0;

  final _controller = PageController(initialPage: 0);
  int _selectedIndex = 0;

  Curve curve = Curves.easeIn;

  Future clearList() async {
    _users.clear();
    _divisions.clear();
  }

  getData() async {
    await databaseRefUsers.get().then((value) => value.docs.forEach((element) {
          setState(() {
            _users.add(Users(email: element.id));
          });
          print(element.id);
        }));
    await databaseRefDivs.get().then((value) => value.docs.forEach((element) {
          setState(() {
            _divisions.add(Divisions(
                division: element.id, title: element.data()['title_division']));
          });
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
    final List<String> _butListCreate = [
      AppLocalizations.of(context).addDivision,
      AppLocalizations.of(context).addModerator,
      AppLocalizations.of(context).addCourse,
      AppLocalizations.of(context).addCourseCard,
    ];

    final List<String> _butListUpdate = [
      AppLocalizations.of(context).updateDivision,
      AppLocalizations.of(context).updateModerator,
      AppLocalizations.of(context).updateCourse,
      AppLocalizations.of(context).updateCourseCard,
    ];

    final List<String> _butListDelete = [
      AppLocalizations.of(context).deleteDivision,
      AppLocalizations.of(context).deleteModerator,
      AppLocalizations.of(context).deleteCourse,
      AppLocalizations.of(context).deleteCourseCard,
    ];

    final List<String> _chooseActions = [
      AppLocalizations.of(context).create,
      AppLocalizations.of(context).update,
      AppLocalizations.of(context).del,
    ];

    List<String> row = ['1', '2', '3', 'current'];

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
              ? _textControllerCardAnswer1
              : _i == '2'
                  ? _textControllerCardAnswer2
                  : _i == '3'
                      ? _textControllerCardAnswer3
                      : _textControllerCardAnswerCorrect,
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

    divFormUpdate() {
      bool _divValidate() {
        final _formDivision = _keyDivisionUpdate.currentState;
        if (_formDivision.validate()) {
          _formDivision.save();
          return true;
        }
        return false;
      }

      void _saveDivision(String _div) {
        databaseRefDivs.doc(_div).set({
          'title_division': _divNameUpdate,
        }, SetOptions(merge: true));
      }

      void _onSavedDivision() {
        if (_divValidate()) {
          _saveDivision(selectedDivisionUpdate.division);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context).division} $_divNameUpdate updated"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyDivisionUpdate,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivisionUpdate,
                    onChanged: (value) {
                      setState(() {
                        selectedDivisionUpdate = value;
                        _textControllerDiv.text = value.title;
                      });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.title));
                    }).toList()),
                TextFormField(
                  controller: _textControllerDiv,
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context).divisionError;
                    else
                      _divNameUpdate = value;
                  },
                  onSaved: (value) => _divNameUpdate = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).division,
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
                    AppLocalizations.of(context).update,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 22.0),
                  ),
                ),
              ],
            )),
      );
    }

    divFormDelete() {
      bool _divValidate() {
        final _formDivision = _keyDivisionDelete.currentState;
        if (_formDivision.validate()) {
          _formDivision.save();
          return true;
        }
        return false;
      }

      void _saveDivision(String _div) {
        databaseRefDivs.doc(_div).delete();
      }

      void _onSavedDivision() {
        if (_divValidate()) {
          _saveDivision(selectedDivisionDelete.division);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context).division} ${selectedDivisionDelete.division} deleted"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyDivisionDelete,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivisionDelete,
                    onChanged: (value) {
                      setState(() {
                        selectedDivisionDelete = value;
                      });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.title));
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
                    _onSavedDivision();
                    print("click!");
                  },
                  child: Text(
                    AppLocalizations.of(context).del,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 22.0),
                  ),
                ),
              ],
            )),
      );
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
          'title_division': _div,
        }, SetOptions(merge: true));
      }

      void _onSavedDivision() {
        if (_divValidate()) {
          _saveDivision(_divName);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context).division} $_divName added"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyDivisionUpdate,
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
                          value: item, child: Text(item.title));
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

    modFormUpdate() {
      bool _modValidate() {
        final _formModerator = _keyAddModeratorUpdate.currentState;
        if (_formModerator.validate()) {
          _formModerator.save();
          return true;
        }
        return false;
      }

      void _onSavedModerator() {
        if (_modValidate()) {
          databaseRefUsers.doc(selectedNewModUserUpdate.email).update({
            'user_role': 'moderator',
          });
          databaseRefUsers.doc(selectedOldModUserUpdate.email).update({
            'user_role': '-',
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "User ${selectedNewModUserUpdate.email} updated to moderator"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddModeratorUpdate,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivModUpdate,
                    onChanged: (value) async {
                      setState(() {
                        selectedDivModUpdate = value;
                        if (_usersInDiv.isNotEmpty) _usersInDiv.clear();
                      });

                      await databaseRefUsers.get().then((value) {
                        value.docs.forEach((element) {
                          if (element.data()['user_division'] ==
                                  selectedDivModUpdate.division &&
                              element.data()['user_role'] == 'moderator')
                            setState(() {
                              _oldUsersInDiv.add(Users(email: element.id));
                            });
                          else if (element.data()['user_division'] ==
                                  selectedDivModUpdate.division &&
                              element.data()['user_role'] != 'moderator')
                            setState(() {
                              _newUsersInDiv.add(Users(email: element.id));
                            });
                        });
                      });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.title));
                    }).toList()),
                SizedBox(height: 20.0),
                DropdownButton<Users>(
                    hint: _oldUsersInDiv.isEmpty
                        ? Text(AppLocalizations.of(context).emptyModUserInDiv)
                        : Text(
                            AppLocalizations.of(context).dropdownOldModerator),
                    value: selectedOldModUserUpdate,
                    onChanged: (value) {
                      setState(() {
                        selectedOldModUserUpdate = value;
                      });
                    },
                    items: _oldUsersInDiv.map((item) {
                      return DropdownMenuItem<Users>(
                          value: item, child: Text(item.email));
                    }).toList()),
                SizedBox(height: 20.0),
                DropdownButton<Users>(
                    hint: _newUsersInDiv.isEmpty
                        ? Text(AppLocalizations.of(context).emptyModUserInDiv)
                        : Text(AppLocalizations.of(context).dropdownModerator),
                    value: selectedNewModUserUpdate,
                    onChanged: (value) {
                      setState(() {
                        selectedNewModUserUpdate = value;
                      });
                    },
                    items: _newUsersInDiv.map((item) {
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
                  onPressed: () {
                    _onSavedModerator();
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

    modFormDelete() {
      bool _modValidate() {
        final _formModerator = _keyAddModeratorDelete.currentState;
        if (_formModerator.validate()) {
          _formModerator.save();
          return true;
        }
        return false;
      }

      void _onSavedModerator() {
        if (_modValidate()) {
          databaseRefUsers.doc(selectedModUser.email).set(
              {
                "user_role": "-",
              },
              SetOptions(
                merge: true,
              ));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User ${selectedModUser.email} deleted"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddModeratorDelete,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivisionDelete,
                    onChanged: (value) async {
                      setState(() {
                        selectedDivisionDelete = value;
                        if (_usersInDiv.isNotEmpty) _usersInDiv.clear();
                      });

                      await databaseRefUsers.get().then((value) {
                        value.docs.forEach((element) {
                          if (element.data()['user_division'] ==
                                  selectedDivisionDelete.division &&
                              element.data()['user_role'] == 'moderator')
                            setState(() {
                              _usersInDiv.add(Users(email: element.id));
                            });
                        });
                      });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.title));
                    }).toList()),
                SizedBox(height: 20.0),
                DropdownButton<Users>(
                    hint: _usersInDiv.isEmpty
                        ? Text(AppLocalizations.of(context).emptyModUserInDiv)
                        : Text(AppLocalizations.of(context).dropdownModerator),
                    value: selectedModUserDelete,
                    onChanged: (value) {
                      setState(() {
                        selectedModUserDelete = value;
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
                    AppLocalizations.of(context).del,
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
            content: Text(
                "${AppLocalizations.of(context).courseName} $_courseName added"),
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
                          value: item, child: Text(item.title));
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

    courseFormUpdate() {
      bool _courseValidate() {
        final _formCourse = _keyAddCourseUpdate.currentState;
        if (_formCourse.validate()) {
          _formCourse.save();
          return true;
        }
        return false;
      }

      void _onSavedCourse() async {
        if (_courseValidate()) {
          await databaseRefDivs
              .doc(selectedDivisionInCourseUpdate.division)
              .collection('courses')
              .doc(selectedCourseUpdate.division)
              .update({'title': _courseNameUpdate});

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context).courseName} $_courseNameUpdate updated"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      String initCourseUpdate = AppLocalizations.of(context).dropdownCourse;

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddCourseUpdate,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivisionInCourseUpdate,
                    onChanged: (value) async {
                      setState(() {
                        selectedDivisionInCourseUpdate = value;
                      });
                      await databaseRefDivs
                          .doc(selectedDivisionInCourseUpdate.division)
                          .collection('courses')
                          .get()
                          .then((value) {
                        setState(() {
                          _courses.clear();
                          value.docs.forEach((element) {
                            _courses.add(Courses(
                                division: element.id,
                                course: element.data()['title']));
                          });
                        });
                      });
                      // await getData();
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.title));
                    }).toList()),
                SizedBox(height: 20.0),
                DropdownButton<Courses>(
                    hint: Text(AppLocalizations.of(context).dropdownCourse),
                    value: selectedCourseUpdate,
                    onChanged: (value) {
                      setState(() {
                        selectedCourseUpdate = value;
                        _textControllerCourse.text =
                            selectedCourseUpdate.course;
                      });
                    },
                    items: _courses.map((item) {
                      return DropdownMenuItem<Courses>(
                          value: item, child: Text(item.course));
                    }).toList()),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _textControllerCourse,
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context).courseError;
                    else
                      _courseNameUpdate = value;
                  },
                  onSaved: (value) => _courseNameUpdate = value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).courseName,
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
                    _onSavedCourse();
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

    courseFormDelete() {
      bool _courseValidate() {
        final _formCourse = _keyAddCourseDelete.currentState;
        if (_formCourse.validate()) {
          _formCourse.save();
          return true;
        }
        return false;
      }

      void _onSavedCourse() {
        if (_courseValidate()) {
          databaseRefDivs
              .doc(selectedDivisionInCourseDelete.division)
              .collection('courses')
              .doc(selectedCourseDelete.division)
              .delete();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${AppLocalizations.of(context).courseName} $_courseNameDelete deleted"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: _keyAddCourseDelete,
            child: ListView(
              children: [
                DropdownButton<Divisions>(
                    hint: Text(AppLocalizations.of(context).dropdownDivisions),
                    value: selectedDivisionInCourseDelete,
                    onChanged: (value) async {
                      setState(() {
                        selectedDivisionInCourseDelete = value;
                      });
                      await databaseRefDivs
                          .doc(selectedDivisionInCourseDelete.division)
                          .collection('courses')
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          setState(() {
                            _courses.clear();
                            _courses.add(Courses(
                                division: element.id,
                                course: element.data()['title']));
                          });
                        });
                      });
                    },
                    items: _divisions.map((item) {
                      return DropdownMenuItem<Divisions>(
                          value: item, child: Text(item.title));
                    }).toList()),
                SizedBox(height: 20.0),
                DropdownButton<Courses>(
                    hint: Text(AppLocalizations.of(context).dropdownCourse),
                    value: selectedCourseDelete,
                    onChanged: (value) {
                      setState(() {
                        selectedCourseDelete = value;
                      });
                    },
                    items: _courses.map((item) {
                      return DropdownMenuItem<Courses>(
                          value: item, child: Text(item.course));
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
                    AppLocalizations.of(context).del,
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
              .doc(selectedCourseInCard.division)
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
                "Card $_cardName added to course ${selectedCourseInCard.course}"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
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
                        _courses.add(Courses(
                            division: element.id,
                            course: element.data()['title']));
                      });
                    });
                  },
                  items: _divisions.map((item) {
                    return DropdownMenuItem<Divisions>(
                        value: item, child: Text(item.title));
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
                      databaseRefDivs
                          .doc(selectedCourseInCard.division)
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
      int _cardId;

      bool _cardValidate() {
        final _formCard = _keyAddCourseCardUpdate.currentState;
        if (_formCard.validate()) {
          _formCard.save();
          return true;
        }
        return false;
      }

      void _onSavedCard() async {
        if (_cardValidate()) {
          await databaseRefDivs
              .doc(selectedDivisionInCardUpdate.division)
              .collection('courses')
              .doc(selectedCourseInCardUpdate.division)
              .collection('cards')
              .doc(selectedCardUpdate)
              .delete();

          await databaseRefDivs
              .doc(selectedDivisionInCardUpdate.division)
              .collection('courses')
              .doc(selectedCourseInCardUpdate.division)
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
                "Card $_cardNameUpdate update in course ${selectedCourseInCardUpdate.course}"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _keyAddCourseCardUpdate,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButton<Divisions>(
                  hint: Text(AppLocalizations.of(context).dropdownDivisions),
                  value: selectedDivisionInCardUpdate,
                  onChanged: (value) async {
                    setState(() {
                      selectedDivisionInCardUpdate = value;
                    });
                    if (_cards.isNotEmpty)
                      setState(() {
                        _courses.clear();
                        _cards.clear();
                        _textControllerCardName.clear();
                        _textControllerCardQuestion.clear();
                        _textControllerCardUrl.clear();
                        _textControllerCardAnswer1.clear();
                        _textControllerCardAnswer2.clear();
                        _textControllerCardAnswer3.clear();
                        selectedCardTypeUpdate = null;
                        selectedCourseInCardUpdate = null;
                        selectedCardUpdate = null;
                        _textControllerCardAnswerCorrect.clear();
                      });
                    await databaseRefDivs
                        .doc(selectedDivisionInCardUpdate.division)
                        .collection('courses')
                        .get()
                        .then((value) {
                      setState(() {
                        _courses.clear();
                        value.docs.forEach((element) {
                          _courses.add(Courses(
                              division: element.id,
                              course: element.data()['title']));
                        });
                      });
                    });
                  },
                  items: _divisions.map((item) {
                    return DropdownMenuItem<Divisions>(
                        value: item, child: Text(item.title));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<Courses>(
                  hint: _courses.isEmpty
                      ? Text(AppLocalizations.of(context).emptyCoursesInDiv)
                      : Text(AppLocalizations.of(context).dropdownCourse),
                  value: selectedCourseInCardUpdate,
                  onChanged: (value) async {
                    setState(() {
                      selectedCourseInCardUpdate = value;
                    });

                    await databaseRefDivs
                        .doc(selectedDivisionInCardUpdate.division)
                        .collection('courses')
                        .doc(selectedCourseInCardUpdate.division)
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
                  onChanged: (value) async {
                    setState(() {
                      selectedCardUpdate = value;
                    });

                    await databaseRefDivs
                        .doc(selectedDivisionInCardUpdate.division)
                        .collection('courses')
                        .doc(selectedCourseInCardUpdate.division)
                        .collection('cards')
                        .doc(selectedCardUpdate)
                        .get()
                        .then((value) {
                      setState(() {
                        _textControllerCardName.text =
                            value.data()['card_title'];
                        _textControllerCardQuestion.text =
                            value.data()['card_question'];
                        selectedCardTypeUpdate = value.data()['card_type'];
                        _textControllerCardUrl.text = value.data()['card_url'];
                        _textControllerCardAnswer1.text =
                            value.data()['card_answers']['answer_1'];
                        _textControllerCardAnswer2.text =
                            value.data()['card_answers']['answer_2'];
                        _textControllerCardAnswer3.text =
                            value.data()['card_answers']['answer_3'];
                        _textControllerCardAnswerCorrect.text =
                            value.data()['card_answers']['correct_answer'];
                        _cardId = value.data()['id'];
                      });
                    });
                  },
                  items: _cards.map((item) {
                    return DropdownMenuItem<String>(
                        value: item, child: Text(item));
                  }).toList()),
              TextFormField(
                controller: _textControllerCardName,
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).cardNameError;
                  else
                    _cardNameUpdate = value;
                },
                onSaved: (value) => _cardNameUpdate = value,
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
                controller: _textControllerCardQuestion,
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).cardQuestionError;
                  else
                    _cardQuestionUpdate = value;
                },
                onSaved: (value) => _cardQuestionUpdate = value,
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
                controller: _textControllerCardUrl,
                onSaved: (value) => _cardContentUrlUpdate = value,
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

    cardFormDelete() {
      bool _cardValidate() {
        final _formCard = _keyAddCourseCardDelete.currentState;
        if (_formCard.validate()) {
          _formCard.save();
          return true;
        }
        return false;
      }

      void _onSavedCard() {
        if (_cardValidate()) {
          databaseRefDivs
              .doc(selectedDivisionInCardDelete.division)
              .collection('courses')
              .doc(selectedCourseInCardDelete.course)
              .collection('cards')
              .doc(selectedCardDelete)
              .delete();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Card $selectedCardDelete delete from course ${selectedCourseInCardDelete.course}"),
          ));
        } else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("false"),
          ));
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _keyAddCourseCardDelete,
          child: ListView(
            shrinkWrap: true,
            children: [
              DropdownButton<Divisions>(
                  hint: Text(AppLocalizations.of(context).dropdownDivisions),
                  value: selectedDivisionInCardDelete,
                  onChanged: (value) async {
                    setState(() {
                      selectedDivisionInCardDelete = value;
                    });

                    if (_cards.isNotEmpty)
                      setState(() {
                        _courses.clear();
                        _cards.clear();
                        selectedCardTypeDelete = null;
                        selectedCourseInCardDelete = null;
                        selectedCardDelete = null;
                      });

                    await databaseRefDivs
                        .doc(selectedDivisionInCardDelete.division)
                        .collection('courses')
                        .get()
                        .then((value) {
                      _courses.clear();
                      value.docs.forEach((element) {
                        setState(() {
                          _courses.add(Courses(
                              division: element.id,
                              course: element.data()['title']));
                        });
                        print(_cards);
                      });
                    });
                  },
                  items: _divisions.map((item) {
                    return DropdownMenuItem<Divisions>(
                        value: item, child: Text(item.title));
                  }).toList()),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<Courses>(
                  hint: _courses.isEmpty
                      ? Text(AppLocalizations.of(context).emptyCoursesInDiv)
                      : Text(AppLocalizations.of(context).dropdownCourse),
                  value: selectedCourseInCardDelete,
                  onChanged: (value) async {
                    setState(() {
                      _cards.clear();
                      selectedCourseInCardDelete = value;
                      selectedCardDelete = null;
                    });

                    await databaseRefDivs
                        .doc(selectedDivisionInCardDelete.division)
                        .collection('courses')
                        .doc(selectedCourseInCardDelete.division)
                        .collection('cards')
                        .get()
                        .then((value) {
                      _cards.clear();
                      value.docs.forEach((element) {
                        var _titleCard = element.data()['card_title'];
                        setState(() {
                          _cards.add(_titleCard);
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
                  value: selectedCardDelete,
                  onChanged: (value) {
                    setState(() {
                      selectedCardDelete = value;
                    });
                  },
                  items: _cards.map((item) {
                    return DropdownMenuItem<String>(
                        value: item, child: Text(item));
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
                  // _cardValidate();
                  _onSavedCard();
                  print("click!");
                },
                child: Text(
                  AppLocalizations.of(context).del,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 22.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _formColumnCreate() {
      return Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListCreate[0], 0))),
          _visibleDiv ? Expanded(flex: 10, child: divForm()) : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListCreate[1], 1))),
          _visibleMod ? Expanded(flex: 10, child: modForm()) : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListCreate[2], 2))),
          _visibleCourse
              ? Expanded(flex: 10, child: courseForm())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListCreate[3], 3))),
          _visibleCard ? Expanded(flex: 10, child: cardForm()) : Container(),
        ],
      );
    }

    Widget _formColumnUpdate() {
      return Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListUpdate[0], 0))),
          _visibleDiv
              ? Expanded(flex: 10, child: divFormUpdate())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListUpdate[1], 1))),
          _visibleMod
              ? Expanded(flex: 10, child: modFormUpdate())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListUpdate[2], 2))),
          _visibleCourse
              ? Expanded(flex: 10, child: courseFormUpdate())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListUpdate[3], 3))),
          _visibleCard
              ? Expanded(flex: 10, child: cardFormUpdate())
              : Container(),
        ],
      );
    }

    Widget _formColumnDelete() {
      return Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListDelete[0], 0))),
          _visibleDiv
              ? Expanded(flex: 10, child: divFormDelete())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListDelete[1], 1))),
          _visibleMod
              ? Expanded(flex: 10, child: modFormDelete())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListDelete[2], 2))),
          _visibleCourse
              ? Expanded(flex: 10, child: courseFormDelete())
              : Container(),
          Expanded(
              flex: 2,
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: materialButList(_butListDelete[3], 3))),
          _visibleCard
              ? Expanded(flex: 10, child: cardFormDelete())
              : Container(),
        ],
      );
    }

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          _title = AppLocalizations.of(context).adminBlock;
          _controller.animateToPage(0,
              duration: Duration(milliseconds: 800), curve: curve);
        } else if (_selectedIndex == 1) {
          _title = AppLocalizations.of(context).adminBlockUpdate;
          _controller.animateToPage(1,
              duration: Duration(milliseconds: 800), curve: curve);
        } else {
          _title = AppLocalizations.of(context).adminBlockDelete;
          _controller.animateToPage(2,
              duration: Duration(milliseconds: 800), curve: curve);
        }
      });
    }

    return userRole != 'admin'
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                _title,
                style: TextStyle(fontSize: 22.0),
              ),
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
                        child: Text(AppLocalizations.of(context).notAdmin),
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
                              child:
                                  Text(AppLocalizations.of(context).notAdmin),
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
              title: Text(
                _title,
                style: TextStyle(fontSize: 22.0),
              ),
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
                              _formColumnUpdate(),
                              _formColumnDelete(),
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
                        Expanded(
                          child: Column(children: [
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
                                      _formColumnUpdate(),
                                      _formColumnDelete(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )
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
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context).del,
                    icon: Icon(Icons.delete_forever),
                    tooltip: AppLocalizations.of(context).del),
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