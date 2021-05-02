import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/models/drawer_item.dart';

class AboutScreen extends StatelessWidget{

  Widget Content() {
    return Container(
      // Navigator.pop(context),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("About app", style: TextStyle(fontSize: 25.0,)),
      ),
      drawer: MediaQuery.of(context).size.width > 600 ? null : Drawer(child: DrawerItem(),), //боковая менюшка
      body: SafeArea(
        child: MediaQuery.of(context).size.width < 600 ? Content() : Row(children: [Container(width: 200, child: DrawerItem(),), Container(width: MediaQuery.of(context).size.width - 200, child: Content(),)],)

      ),
    );
  }
}