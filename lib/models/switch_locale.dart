import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:microlearning/models/flutter_app.dart';

class SwitchLocale extends StatefulWidget {
  @override
  _SwithcLocaleState createState() => _SwithcLocaleState();
}

enum _locales { russia, english }

class _SwithcLocaleState extends State<SwitchLocale> {
  final _ruLocale = "ru";
  final _engLocale = "en";

  int count = 0;

  bool _locale;


  @override
  Widget build(BuildContext context) {

    Locale changedLocale;

    Locale myLocale = Localizations.localeOf(context);

    if (myLocale.languageCode == 'ru')
        _locale = true;
    else
        _locale = false;

    changeLocale(bool locale) {
      setState(() {
      switch(locale){
        case true:
          changedLocale = AppLocalizations.supportedLocales.last;
          AppLocalizations.delegate.load(changedLocale);
          break;
        case false:
          changedLocale = AppLocalizations.supportedLocales.first;
            AppLocalizations.delegate.load(changedLocale);
          break;
      }
      // print(locale);
      // print(myLocale);
      print(AppLocalizations.of(context).localeName);
      });
    }

    return Row(children: [
        Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
          child: AnimatedOpacity(
            opacity: _locale ? 0.4 : 1.0,
            duration: Duration(milliseconds: 300),
            child: SvgPicture.asset(
              "assets/icons/english_icon.svg",
              width: 30.0,
            ),
          ),
        ),
        Container(
          width: 50.0,
          child: Switch(
              value: _locale,
              onChanged: (value) {
                setState(() {
                  _locale = value;
                  if(value) AppLocalizations.delegate.load(Locale('ru'));
                  else AppLocalizations.delegate.load(Locale('en'));
                });
                  // changeLocale(_locale);
                print(_locale);
              }),
        ),
        Container(
          margin: EdgeInsets.all(10.0),
          child: AnimatedOpacity(
            opacity: _locale ? 1.0 : 0.4,
            duration: Duration(milliseconds: 300),
            child: SvgPicture.asset(
              "assets/icons/russia_icon.svg",
              width: 30,
            ),
          ),
        )
      ]);


    // changeLocale(String locale) {
    //   setState(() {
    //   switch (locale) {
    //     case 'ru':
    //       AppLocalizations.delegate.load(Locale('ru'));
    //       break;
    //     case 'en':
    //       AppLocalizations.delegate.load(Locale('en'));
    //       break;
    //   }
    //   // print(locale);
    //   print(myLocale);
    //   print(AppLocalizations.of(context).localeName);
    //   });
    // }
    //
    // return PopupMenuButton<_locales>(
    //
    //   initialValue: _locales.english,
    //   itemBuilder: (BuildContext context) => [
    //     PopupMenuItem<_locales>(
    //       value: _locales.russia,
    //       // enabled: myLocale == "en_US" ? false : true,
    //       child: ListTile(
    //           title: Text("Русский язык"),
    //           trailing: SvgPicture.asset(
    //             'assets/icons/russia_icon.svg',
    //             height: 20.0,
    //           ),
    //           onTap: () => changeLocale(_ruLocale)
    //           // setState(() =>*/ AppLocalizations.delegate
    //           //     .load(Locale('ru'))),
    //           ),
    //     ),
    //     PopupMenuItem<_locales>(
    //       value: _locales.english,
    //       // enabled: myLocale == 'en_US' ? false : false,
    //       child: ListTile(
    //           title: Text("English language"),
    //           trailing: SvgPicture.asset(
    //             'assets/icons/english_icon.svg',
    //             height: 20.0,
    //           ),
    //           onTap: () => changeLocale(
    //               _engLocale) /*
    //             setState(() => */ //AppLocalizations.delegate.load(Locale('en')))
    //
    //           ),
    //     )
    //   ],
    // );
  }
}
