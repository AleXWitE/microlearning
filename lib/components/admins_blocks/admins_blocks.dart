import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminBlock extends StatefulWidget {
  final List<String> items;
  int i;

  AdminBlock({Key key, this.items, this.i}) : super(key: key);

  @override
  _AdminBlockState createState() => _AdminBlockState();
}

class _AdminBlockState extends State<AdminBlock> with TickerProviderStateMixin {
  final _keyDivision = GlobalKey<FormState>();
  final _keyAddModerator = GlobalKey<FormState>();
  final _keyAddCourse = GlobalKey<FormState>();
  final _keyAddCourseCard = GlobalKey<FormState>();

  Curve curve = Curves.ease;

  bool _visibleDiv = false;
  bool _visibleMod = false;
  bool _visibleCourse = false;
  bool _visibleCard = false;

  Widget formBlock = Container();

  int answerCount = 0;
  int cardCount = 0;

  String _divName;
  String _divModName;

  String _modName;
  String _modDivName;

  String _courseName;
  String _courseDiv;

  visDivision() {
    _visibleDiv = true;
    _visibleMod = false;
    _visibleCourse = false;
    _visibleCard = false;
    formBlock = divForm();
  }

  visModerator() {
    _visibleDiv = false;
    _visibleMod = true;
    _visibleCourse = false;
    _visibleCard = false;
    formBlock = modForm();
  }

  visCourse() {
    _visibleDiv = false;
    _visibleMod = false;
    _visibleCourse = true;
    _visibleCard = false;
    formBlock = courseForm();
  }

  visCard() {
    _visibleDiv = false;
    _visibleMod = false;
    _visibleCourse = false;
    _visibleCard = true;
    formBlock = cardForm();
  }

  divForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: _keyDivision,
          child: Column(
            children: [
              TextFormField(
                // validator: (value) {
                //   if (value.isEmpty)
                //     return AppLocalizations.of(context).emailErr;
                // },
                onSaved: (value) => _divName = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).division,
                  focusColor: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
            ],
          )),
    );
  }

  modForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: _keyAddModerator,
          child: Column(
            children: [],
          )),
    );
  }

  cardForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: _keyAddCourseCard,
          child: ListView(
            children: [
              TextFormField(
                // validator: (value) {
                //   if (value.isEmpty)
                //     return AppLocalizations.of(context).emailErr;
                // },
                onSaved: (value) => _divName = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).division,
                  focusColor: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              MaterialButton(onPressed: () {
                setState(() {
                  answerCount++;
                });
              }),
              SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                itemCount: answerCount,
                itemBuilder: (_, index) => Text('item $index'),
              )
            ],
          )),
    );
  }

  courseForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: _keyAddCourse,
          child: Column(
            children: [],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        child: ListTile(
          title: Text(
            widget.items[widget.i],
          ),
          onTap: () {
            setState(() {
              switch (widget.i) {
                case 1:
                  visDivision();
                  break;
                case 2:
                  visModerator();
                  break;
                case 3:
                  visCourse();
                  break;
                case 4:
                  visCard();
                  break;
              }
            });
          },
        ),
      ),
      widget.i == 4
          ? null
          : Divider(
              thickness: 3.0,
              height: 3.0,
            ),
      AnimatedSize(
          curve: curve,
          duration: Duration(milliseconds: 800),
          vsync: this,
          child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: formBlock)),
    ]);
  }
}
