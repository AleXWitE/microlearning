import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BreadDots extends StatefulWidget {
  final String title;

  BreadDots({Key key, this.title}) : super(key: key);

  @override
  _BreadDotsState createState() => _BreadDotsState();
}

class _BreadDotsState extends State<BreadDots> {
  @override
  Widget build(BuildContext context) {
    String _title = widget.title;
    return Container(
      color: Theme.of(context).accentColor,
      width: MediaQuery.of(context).size.width - 50.0,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: 50.0,
      child: Row(
        children: [
          Icon(
            Icons.home,
            size: 40.0,
            color: Colors.black38,
          ),
          SizedBox(
            width: 10.0,
          ),
          _title == "Card" || _title == "Карточка" 
              ? Text("/ ", style: TextStyle(fontSize: 20.0, color: Colors.black38),)
              : Container(),
          _title == "Card" || _title == "Карточка"
              ? MouseRegion(
            cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    child: Text(
                      "${AppLocalizations.of(context).breadDotsCourses}",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontSize: 20.0),
                    ),
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/courses', ModalRoute.withName('/courses')),
                  ),
              )
              : Container(),
          _title == "Card" || _title == "Карточка"
              ? SizedBox(
                  width: 10.0,
                )
              : Container(),
          Text(
            "/ $_title",
            style: TextStyle(fontSize: 20.0, color: Colors.black38),
          )
        ],
      ),
    );
  }
}
