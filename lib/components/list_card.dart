
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'event.dart';

class EventCard extends StatefulWidget {
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
    print("${widget.events.length}");
  }

  int id = EventCard().i;

  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.indigo[200],
      elevation: 10,
      shadowColor: Colors.indigo,
      margin: EdgeInsets.symmetric(vertical: 20),

      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/event/${widget.events[widget.i].id}',
          );
        },
        // generate route for item card
        enabled: _isEnabled,
        title: Text(
          // widget.events.events,
          widget.events[widget.i].name,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
            "${widget.events[widget.i].location} \n${widget.events[widget.i].date.toString()}"),
        leading: Icon(
          Icons.ac_unit_sharp,
          size: 40,
          color: Colors.indigo,
        ),
        trailing: IconButton(
          icon: _isEnabled ? Icon(Icons.lock_outlined) : Icon(Icons.lock_open),
          onPressed: () => setState(
            () => _isEnabled = !_isEnabled,
          ),
        ),
      ),
    );
  }
}
// shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
/*child: Column(children: [
        Text(
          "${events[index].name}",
          style: TextStyle(fontSize: 30.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${events[index].location}",
              // style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 20,),
            Text(
              "${events[index].date.toString()}",
              // style: TextStyle(fontSize: 20),
            )
          ],
        )
      ]),*/