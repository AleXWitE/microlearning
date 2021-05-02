import 'package:flutter/material.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {

  _AboutScreenState createState() => _AboutScreenState();
}


class _AboutScreenState extends State<AboutScreen> {
  final String _url = "https://github.com/AleXWitE/microlearning";
  final String _urlVK = "https://vk.com/alex_wite";
  Future<void> _launched;

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  String developer_avatar = "https://picsum.photos/250?image=11";

  @override
  Widget build(BuildContext context) {
    Widget Content() {

      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(7.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 15,
                height: 100.0,
                // margin: EdgeInsets.all(7.0),
                child: Image.asset('assets/images/Logo_Polytech.png'),
              ),

              Container(
                width: MediaQuery.of(context).size.width - 15,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor), text: "LKJHidsahgfliadf haklvnhi0gsug\n haig nhslmfvhadk;vdflk\nahfvksjhgflsdgvhakljb ak; na;lfmadlgf kjfas;\nkhi lhfa h pa hipah al hafkjhfadk;\nngk; jghf lkj ha aaf\n"),
                  ]),
                ),
              ),
              Container(
                height: 170.0,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).accentColor,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 10,
                      spreadRadius: 3,
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width - 15,
                // padding: EdgeInsets.all(7.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Image.network(developer_avatar),
                      flex: 4,
                    ),
                    Expanded(
                        flex: 6,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text("Name\n", style: TextStyle(
                                  fontSize: 20.0,
                                  color: Theme.of(context).accentColor,
                                  fontFamily: 'Redressed',
                                ),),
                              ),
                          Container(
                            alignment: Alignment.centerLeft,
                              child: Text("LastName\n", style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).accentColor,
                                fontFamily: 'Redressed',
                              ),),
                          ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: MaterialButton(
                                  color: Theme.of(context).accentColor,
                                  minWidth: 200.0,
                                  height: 30.0,
                                  child: Text("VK profile", style: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: 'Redressed',
                                  ),),
                                  onPressed: () => _launched = _launchInWebViewOrVC(_urlVK)
                                ),
                              ),

                            ],
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                // padding: EdgeInsets.all(7.0),
                width: MediaQuery.of(context).size.width - 15,
                child: Column(
                  children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    MaterialButton(
                      height: 50.0,
                        minWidth: 250.0,
                        color: Theme.of(context).primaryColor,
                        onPressed:() => setState(() => _launched = _launchInWebViewOrVC(_url)),
                      child: Text("This project code on GitHub.com", style: TextStyle(color: Theme.of(context).accentColor),),
                    )

                  ],
                ),

              )
            ],
          ),
          // Navigator.pop(context),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("About app",
            style: TextStyle(
              fontSize: 25.0,
            )),
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: DrawerItem(),
            ), //боковая менюшка
      body: SafeArea(
          child: MediaQuery.of(context).size.width < 600
              ? Content()
              : Row(
                  children: [
                    Container(
                      width: 200,
                      child: DrawerItem(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 200,
                      height: MediaQuery.of(context).size.height,
                      child: Content(),
                    )
                  ],
                )),
    );
  }
}
