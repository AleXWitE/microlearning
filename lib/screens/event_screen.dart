import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/models/drawer_item.dart';

class EventScreen extends StatelessWidget {
  String _id;

  EventScreen({String id}) : _id = id; //здесь мы получаем отправленный нам id элемента из списка, в следствии с ним и работаем при обращении к апи

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter event card №$_id"),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.indigo),
        backgroundColor: Colors.grey[500],
      ),
      drawer: DrawerItem(),
      body: Stack(children: [
        FutureBuilder<Event>( //при работе с джсон мы получаем класс элементов Future, т.е будут когда в будущем, асинхронный метод, который требует отложенного билда
          future: getEvent(_id), // что мы должны получить в будущем
          builder: (context, snapshot) { //получаем контекст и элемент джсона
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
