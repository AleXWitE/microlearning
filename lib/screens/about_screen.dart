import 'package:flutter/material.dart';
import 'package:microlearning/components/bread_dots.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String developer_avatar =
      "https://sun9-5.userapi.com/impf/c841428/v841428940/297d1/r5qztY5XwSI.jpg?size=604x604&quality=96&sign=3cf8d663ef233c727b73c909c9ea86f3&type=album";

  loadImage(String _url) async {
    return await Image.network(_url);
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    Widget Content() {
      return Column(children: [
        Expanded(flex: 1, child: BreadDots(title: AppLocalizations.of(context).breadDotsAbout,)),
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(7.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 200,
                    // height: 100.0,
                    child: MediaQuery.of(context).size.width > 600
                        ? Container()
                        : myLocale.languageCode == 'ru'
                            ? Image.asset(
                                'assets/images/polytech_logo_main_ru.png')
                            : Image.asset(
                                'assets/images/polytech_logo_main_en.png'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 15,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor),
                            text: "${AppLocalizations.of(context).aboutApp1}\n\n"
                                "${AppLocalizations.of(context).aboutApp2}\n"
                                "${AppLocalizations.of(context).aboutApp3}\n"
                                "${AppLocalizations.of(context).aboutApp4}\n"
                                "${AppLocalizations.of(context).aboutApp5}\n"
                                "${AppLocalizations.of(context).aboutApp6}\n"
                                "${AppLocalizations.of(context).aboutApp7}\n\n"),
                      ]),
                    ),
                  ),
                  Container(
                    height: 300.0,
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
                    child: Column(children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${AppLocalizations.of(context).developer1}\n${AppLocalizations.of(context).developer2}",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 1,
                          )),
                      Expanded(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment,
                            children: [
                              Expanded(
                                // child: loadImage(developer_avatar),
                                child: Image.network(developer_avatar),
                                // flex: 4,
                              ),
                              Expanded(
                                // flex: 6,
                                // child: Container(
                                // alignment: Alignment.topLeft,
                                // margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Sasha\n",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context).accentColor,
                                          // fontFamily: 'Redressed',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Watt\n",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context).accentColor,
                                          // fontFamily: 'Redressed',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: MaterialButton(
                                          color: Theme.of(context).accentColor,
                                          minWidth: 200.0,
                                          height: 30.0,
                                          child: Text(
                                            AppLocalizations.of(context).aboutVk,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color:
                                                  Theme.of(context).primaryColor,
                                              // fontFamily: 'Redressed',
                                            ),
                                          ),
                                          onPressed: () => _launched =
                                              _launchInWebViewOrVC(_urlVK)),
                                    ),
                                  ],
                                  // ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 1.0,
                          )),
                      Expanded(
                        flex: 1,
                        child: MaterialButton(
                          // height: 45.0,
                          minWidth: MediaQuery.of(context).size.width - 100,
                          color: Theme.of(context).accentColor,
                          onPressed: () => setState(
                              () => _launched = _launchInWebViewOrVC(_url)),
                          child: Text(
                            "${AppLocalizations.of(context).aboutGithub} GitHub.com",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              // Navigator.pop(context),
            ),
          ),
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).drawerAbout,
            style: TextStyle(
              fontSize: 22.0,
            )),
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: DrawerItem(),
            ), //?????????????? ??????????????
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
