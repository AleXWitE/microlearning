import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/models/drawer_item.dart';

class AboutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("About app"),

      ),
      drawer: DrawerItem(),
      body: Container(
        // Navigator.pop(context),
      ),
    );
  }
}