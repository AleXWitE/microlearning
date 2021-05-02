import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/models/drawer_item.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  void initState() {
    super.initState();
  }

  var _finalDate;

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2030)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        return;
      }
      setState(() {
        //for rebuilding the ui
        _finalDate = pickedDate;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  String _name;
  String _location;

  callAPI() {
    //функция вызова работы с апи, в данном варианте - добавление элемента в джсон
    if (_finalDate == null) _finalDate = DateTime.now().toString();
    Event event = Event(
        //определение элемента
        name: '$_name',
        location: '$_location',
        date: '$_finalDate');
    createEvent(event).then((response) {
      //сборка элемента, по готовности отправка запроса
      if (response.statusCode > 200)
        print(response.body);
      else
        print(response.statusCode);
    }).catchError((error) {
      print('error : $error');
    });
  }

  Widget FormChild() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Enter the Name of event:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(validator: (value) {
                    if (value.isNotEmpty) {
                      //проверка текстинпута на пустую строку, если не пустая - присваиваем имя, если пустая - ошибка
                      _name = value;
                    } else
                      return 'Please, entry a name of event';
                  }),
                  SizedBox(height: 20.0),
                  Text(
                    'Entry location of event:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(validator: (value) {
                    if (value.isNotEmpty) {
                      _location = value;
                    } else
                      return 'Please, entry location of event';
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Entry date of event:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(_finalDate == null
                      ? "Picked date: not assigned"
                      : "Picked date: $_finalDate"),
                  RaisedButton(
                    onPressed: _pickDateDialog,
                    color: Colors.blueAccent,
                    child: Text('Choose date',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //если валидация прошла - вызываем апи, и отправляемся в весь список
                        callAPI();
                        Navigator.pushNamed(context, '/list_events');
                      }
                    },
                    child: Text('Send'),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add 1 more event",
            style: TextStyle(
              fontSize: 25.0,
            )),
        centerTitle: true,
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: DrawerItem(),
            ), //боковая менюшка
      body: SafeArea(
          child: MediaQuery.of(context).size.width < 600
              ? FormChild()
              : Row(
                  children: [
                    Container(
                      width: 200,
                      child: DrawerItem(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 200,
                      child: FormChild(),
                    )
                  ],
                )),
    );
  }
}
