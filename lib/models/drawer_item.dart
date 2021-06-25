import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microlearning/api/services/google_sign_in.dart';
import 'package:microlearning/components/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem extends StatelessWidget {
  _delPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }

  _getRole() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    userRole = _prefs.getString('USER_ROLE') ?? null;
  }

  @override
  Widget build(BuildContext context) {
    _getRole();
    Locale myLocale = Localizations.localeOf(context);

    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              //имеет в себе заголовок
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    // child: SvgPicture.asset("assets/images/LoneWolf.svg"),
                    child: myLocale.languageCode == 'ru'
                        ? Image.asset('assets/images/polytech_logo_main_ru.png')
                        : Image.asset(
                            'assets/images/polytech_logo_main_en.png'),
                  ),
                  Text(
                    AppLocalizations.of(context).drawerNav,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 33.0,
                    ),
                  ),
                ],
              )),
          userRole == '-'
              ? Container()
              : Column(
                  children: [
                    userRole == 'admin'
                        ? ListTile(
                            leading: Icon(
                              Icons.library_add_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                            title: Text(AppLocalizations.of(context).adminForm,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Theme.of(context).accentColor,
                                )),
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/admin_form',
                                ModalRoute.withName('/list_events')),
                          )
                        : userRole == 'moderator'
                            ? ListTile(
                                leading: Icon(
                                  Icons.library_add_outlined,
                                  color: Theme.of(context).accentColor,
                                ),
                                title: Text(
                                    AppLocalizations.of(context).moderatorForm,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Theme.of(context).accentColor,
                                    )),
                                onTap: () => Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/moderator_form',
                                    ModalRoute.withName('/list_events')),
                              )
                            : Container(),
                    userRole == 'admin' || userRole == 'moderator' ? Divider(
                      height: 3.0,
                      color: Theme.of(context).accentColor,
                    )
                    : Container(),
                  ],
                ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).drawerHome,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                )),
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/courses', ModalRoute.withName('/courses')),
          ),
          Divider(
            height: 3.0,
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).drawerFavorite,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                )),
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/favorite', ModalRoute.withName('/courses')),
          ),
          Divider(
            height: 3.0,
            color: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).drawerAbout,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                )),
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/about', ModalRoute.withName('/courses')),
          ),
          Divider(
            height: 3.0,
            color: Theme.of(context).accentColor,
          ),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).accentColor,
              ),
              title: Text(AppLocalizations.of(context).drawerExit,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).accentColor,
                  )),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/auth', (route) => false);
                // savedUser = null;
                _delPrefs();
                GoogleSignInState.signOut(context: context);
              }),
        ],
      ),
    );
  }
}
