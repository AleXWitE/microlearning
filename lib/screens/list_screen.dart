import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';

class ListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("List Title 14 cards"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: FutureBuilder<List<Event>>(
        future: getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return ListView.builder(
                physics: PageScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 40),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) => EventCard(events: snapshot.data, i: index));
        }
          else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Add"),
        backgroundColor: Colors.grey[900],
        onPressed: () => Navigator.pushNamed(context, '/add'),
      ),
    );
  }
}