import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter tutorial $count taps"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/1.png"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 20, 60, 30),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    width: 3,
                    color: Colors.indigo[300],
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      // offset: Offset(3, 3)
                    ),
                  ],
                ),
                // alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: SvgPicture.asset("assets/images/LoneWolf.svg"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: "Redressed",
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "Hello "),
                              TextSpan(
                                style: TextStyle(color: Colors.red),
                                children: <TextSpan>[
                                  TextSpan(text: "Brave "),
                                  TextSpan(text: "new "),
                                  TextSpan(
                                      text: "World",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline))
                                ],
                              ),
                              TextSpan(text: "!")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                  // height: 25,
                  ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: Colors.indigo[100],
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent[100]],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 5,
                    color: Colors.teal[100],
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber,
                      blurRadius: 10,
                      spreadRadius: 5,
                      // offset: Offset(3, 3)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RichText(
                              text: TextSpan(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            text: "Answer 1",
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          // height: 15,
                          ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RichText(
                              text: TextSpan(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            text: "More longer answer 2",
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          // height: 15,
                          ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RichText(
                              text: TextSpan(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            text: "Answer 3, which need",
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                  // height: 40,
                  ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.blue,
                    // height: 30,
                    // width: 150,
                    // alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    onPressed: () => print("tap back"),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: 20.0), text: "Back"),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    // height: 30,
                    // width: 150,
                    // alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/list_events'),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: 20.0), text: "Next"),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                  // height: 40,
                  ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          size: 40.0,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
        onPressed: () {
          print("tap");
          setState(() => count++);
        },
      ),

      // bottomNavigationBar: BottomNavigationBar(),
    );
  }
}
