import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microlearning/components/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem extends StatelessWidget {
  _delPrefs() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            //имеет в себе заголовок
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .accentColor,
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context).drawerNav,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 33.0,),
                  ),
                  SizedBox(
                    height: 80,
                    child: SvgPicture.asset("assets/images/LoneWolf.svg"),
                  )
                ],
              )),
          ListTile(
            leading: Icon(Icons.home, color: Theme
                .of(context)
                .accentColor,),
            title: Text(AppLocalizations.of(context).drawerHome, style: TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor,)),
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', ModalRoute.withName('/list_events')),
          ),
          Divider(color: Theme.of(context).accentColor,),
          ListTile(
            //и остальное тело элементов, использовать листтайл, т.к обернуты в обычный список
            leading: Icon(Icons.wysiwyg, color: Theme
                .of(context)
                .accentColor,),
            title: Text(AppLocalizations.of(context).drawerToList, style: TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor,)),
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/list_events',
                    ModalRoute.withName('/list_events')),
          ),
          Divider(color: Theme.of(context).accentColor,),
          ListTile(
            leading: Icon(Icons.add, color: Theme
                .of(context)
                .accentColor,),
            title: Text(
                AppLocalizations.of(context).drawerAdd, style: TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor,)),
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/add', ModalRoute.withName('/list_events')),
          ),
          Divider(color: Theme.of(context).accentColor,),
          ListTile(
            leading: Icon(Icons.favorite, color: Theme
                .of(context)
                .accentColor,),
            title: Text(
                AppLocalizations.of(context).drawerFavorite, style: TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor,)),
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/favorite', ModalRoute.withName('/list_events')),
          ),
          Divider(color: Theme.of(context).accentColor,),
          ListTile(
            leading: Icon(Icons.info_outline, color: Theme
                .of(context)
                .accentColor,),
            title: Text(
                AppLocalizations.of(context).drawerAbout, style: TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor,)),
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/about', ModalRoute.withName('/list_events')),
          ),
          Divider(color: Theme.of(context).accentColor,),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Theme
                .of(context)
                .accentColor,),
            title: Text(
                AppLocalizations.of(context).drawerExit, style: TextStyle(fontSize: 20.0, color: Theme
                .of(context)
                .accentColor,)),
            onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/auth', (route) => false);
                savedUser = null;
                _delPrefs();
            }
          ),
        ],
      ),
    );
  }
}
