import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/models/drawer_item.dart';

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> with WidgetsBindingObserver {
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future getAllEventsState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      getAllEventsState = getAllEvents();
    });
    return null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        getAllEventsState = getAllEvents();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (getAllEventsState == null) {
      getAllEventsState = getAllEvents();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("List Title cards"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      drawer: DrawerItem(),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshList();
          },
          child: FutureBuilder<List<Event>>(
            future: getAllEventsState,
            builder: (context, snapshot) {
              // AppLifecycleState state;
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return ListView.builder(
                    physics: PageScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) =>
                        EventCard(events: snapshot.data, i: index));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Text("Add"),
        backgroundColor: Colors.grey[900],
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
      ),
    );
  }
}
