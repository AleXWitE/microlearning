import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/db/moor_db.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'event.dart';

class EventCard extends StatefulWidget {
  //здесь мы получаем элемент списка чтобы нарисовать карточку для конкретнного элемента
  final List<Courses> courses;
  final List<Favor> favs;
  final int i;

  EventCard({Key key, this.courses, this.i, this.favs}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  void initState() {
    super.initState();
    print("${widget.courses.length}\n"); //вывод в консоли количество элементов
    print("${widget.favs.length}"); //вывод в консоли количество элементов
  }

  bool _isEnabled = true;
  bool _isFavorite;

  String _course;

  @override
  Widget build(BuildContext context) {
    final _dao = Provider.of<FavorDao>(context);

    bool _fav;

    var element;
    var elId;
    if (widget.courses.isEmpty && widget.favs.isNotEmpty) {
      element = widget.favs[widget.i];
      elId = element.courseId.toString();
      _fav = true;
    } else {
      element = widget.courses[widget.i];
      elId = element.id.toString();
      _fav = false;
    }

    Stream<List<Favor>> eventFav = _dao.watchAllFavorites();

    eventFav.listen((event) {
      setState(() {
        for (int i = 0; i < event.length - 1; i++) {
          favorItem.add(FavorItem(courseId: event[i].courseId, favorite: true));
        }
      });
    });

    var _favItem = favorItem.where((item) =>
        item.courseId == element.id ||
        item.id == elId ||
        element.favorite == true);

    setState(() {
      switch (_favItem.isEmpty) {
        case true:
          _isFavorite = false;
          break;
        case false:
          _isFavorite = true;
          break;
        default:
          _isFavorite = false;
      }
    });

    insertData(Courses courses /*Answers answ*/) {
      _dao.insertNewFavorite(Favor(
          courseId: courses.id,
          title: courses.course,
          /*cardCourseId: answ.courseId,
          cardTitle: answ.title,
          cardQuestion: answ.description,
          cardType: answ.type,
          cardAnswer1: answ.answer1,
          cardAnswer2: answ.answer2,
          cardAnswer3: answ.answer3,
          cardAnswerCorrect: answ.answerCorrect,
          cardUrl: answ.url,*/
          favorite: true));
      favorItem.add(FavorItem(courseId: element.id, favorite: true));
      _isFavorite = true;
    }

    deleteData(int _id) async {
      Favor checkFavorite = await _dao.getFavorite(_id);
      if (checkFavorite != null) _dao.deleteFavorite(checkFavorite);
      favorItem
          .removeAt(favorItem.indexWhere((el) => el.courseId == element.id));
    }


    _Card() {
      if (widget.courses.isEmpty)
        _course = element.title;
      else
        _course = element.course;

      String _courseId;

      _getCourseId() async {
        await FirebaseFirestore.instance
            .collection('divisions')
            .doc(userDivision)
            .collection('courses')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            if (element.data()['title'] == _course)
              setState(() {
                _courseId = element.id;
              });
            // print(_courseId);
          });
        });
      }

      _getAnswers(String _courseName) async {
        print(_courseName);
        await FirebaseFirestore.instance
            .collection('divisions')
            .doc(userDivision)
            .collection('courses')
            .doc(_courseName)
            .collection('cards')
            .orderBy('id')
            .get()
            .then((value) => value.docs.forEach((element) {
              // print(element.id);
              setState(() {
                answers.add(Answers(
                  title: element.data()['card_title'],
                  description: element.data()['card_question'],
                  type: element.data()['card_type'],
                  answer1: element.data()['card_answers']['answer_1'],
                  answer2: element.data()['card_answers']['answer_2'],
                  answer3: element.data()['card_answers']['answer_3'],
                  answerCorrect: element.data()['card_answers']
                  ['correct_answer'],
                  url: element.data()['card_url'],
                ));
              });
        }));
      }

      return Card(
        elevation: 15.0,
        margin: EdgeInsets.symmetric(vertical: 20),
        child: ListTile(
          onTap: () async {
            await _getCourseId();
            print(_courseId);
            await _getAnswers(_courseId);
            if (answers.isNotEmpty)
              Navigator.pushNamed(
                context,
                '/courses/$_course',
              );
            else ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context).emptyCourse),
            ));
          },
          // generate route for item card
          enabled: _isEnabled,
          title: Text(
            _fav ? element.title : element.course,
            // element.course,
            style: TextStyle(fontSize: 20),
          ),
          leading: IconButton(
            icon:
                _isEnabled ? Icon(Icons.lock_outlined) : Icon(Icons.lock_open),
            onPressed: () => setState(
              () => _isEnabled = !_isEnabled,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              //задаем смену сердечек от параметра _isFavorite
              size: 40,
              // color: Colors.indigo,
            ),
            onPressed: () {
              setState(() {
                _isFavorite ? deleteData(int.parse(elId)) : insertData(element);
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ),
      );
    }

    return /*_fav
        ? Dismissible(
            child: _Card(),
            key: ValueKey<int>(elId),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (DismissDirection direction) {
              setState(() {
                deleteData(elId);
              });
            },
          )
        : */
        _Card();
  }
}
