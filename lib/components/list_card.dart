
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/screens/list_screen.dart';

import 'event.dart';

class EventCard extends StatefulWidget { //здесь мы получаем элемент списка чтобы нарисовать карточку для конкретнного элемента
  final List<Event> events;
  final int i;

  EventCard({Key key, this.events, this.i}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}


class _EventCardState extends State<EventCard> {

  @override
  void initState() {
    super.initState();
    print("${widget.events.length}"); //вывод в консоли количество элементов
  }

  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    var event = widget.events[widget.i]; //определение элемента по id

    return Card(
      color: Colors.indigo[200],
      elevation: 10,
      shadowColor: Colors.indigo,
      margin: EdgeInsets.symmetric(vertical: 20),

      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/event/${event.id}',
          );
        },
        // generate route for item card
        enabled: _isEnabled,
        title: Text(
          // widget.events.events,
          event.name,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
            "${event.location} \n${event.date.toString()}"),
        leading: IconButton(
          icon: _isEnabled ? Icon(Icons.lock_outlined) : Icon(Icons.lock_open),
          onPressed: () => setState(
                () => _isEnabled = !_isEnabled,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever,
          size: 40,
          color: Colors.indigo,),
          /*onPressed: () {
            onDelete(widget.events[widget.i].id);
            setState(() {
              getEventsBuilderState().getAllEventsState = getAllEvents();
            });
          },*/
        ),
      ),
    );
  }
}