import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';

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
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
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

/*  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finalDate = order;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }*/

  final _formKey = GlobalKey<FormState>();
  String _name;
  String _location;
  DateTime _date;

  callAPI() {
    Event event = Event(
        name: '$_name', location: '$_location', date: '$_date');
    createEvent(event).then((response) {
      if (response.statusCode > 200)
        print(response.body);
      else
        print(response.statusCode);
    }).catchError((error) {
      print('error : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add 1 more event"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  new Text(
                    'Enter the Name of event:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  new TextFormField(validator: (value) {
                    if (value.isNotEmpty){
                      _name = value;
                    } else return 'Please, entry a name of event';
                  }),
                  new SizedBox(height: 20.0),
                  new Text(
                    'Entry location of event:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  new TextFormField(validator: (value) {
                    if (value.isNotEmpty){
                      _location = value;
                    } else return 'Please, entry location of event';
                  }),
                  new Text(
                    'Entry location of event:',
                    style: TextStyle(fontSize: 20.0),
                  ),
/*                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: DateTime(2019, 1, 1, 11, 33),
                  onDateTimeChanged: (DateTime newDateTime) {
                    if(){

                    }
                  },
                  use24hFormat: true,
                  minuteInterval: 15,
                ),*/
                  new Text(_finalDate == null ? "Picked date: ${DateTime.now().toString()}" : "Picked date: $_finalDate" ),
                  new RaisedButton(
                    onPressed: _pickDateDialog,
                    color: Colors.blueAccent,
                    child: new Text('Choose date',
                        style: TextStyle(color: Colors.white)),
                  ),

                  new SizedBox(height: 20.0),
                  new RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        callAPI();

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Success"),
                          backgroundColor: Colors.green,
                        ));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Something wrong"),
                          backgroundColor: Colors.red,
                        ));
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
}
