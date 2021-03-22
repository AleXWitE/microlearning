import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';

class EventScreen extends StatelessWidget {
  String _id;

  EventScreen({String id}) : _id = id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter event card №$_id"),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.indigo),
        backgroundColor: Colors.grey[500],
      ),
      body: Stack(children: [
        FutureBuilder<Event>(
          future: getEvent(_id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("The name of event: ${snapshot.data.name}"),
                  Text("It will happen there: ${snapshot.data.location}"),
                  Text("In this moment: ${snapshot.data.date}"),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Positioned(
          bottom: 15,
          left: 20,
          child: RaisedButton(
              onPressed: () {
                 Navigator.pop(context);
               },
              child: Text('Назад')
          ),
        )
    ]),
    );
  }
}
