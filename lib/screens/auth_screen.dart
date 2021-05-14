import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String appBarTitle = "Login screen";
  int _selectedIndex = 0;
  int _initPage = 0;
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyAuth = GlobalKey<FormState>();

  Curve curve = Curves.ease;

  String _loginName;

  LoginWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKeyLogin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your login:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextFormField(
              validator: (value) {
                if (value.isNotEmpty) {
                  //проверка текстинпута на пустую строку, если не пустая - присваиваем имя, если пустая - ошибка
                  return _loginName = value;
                } else
                  return 'Please, entry a login';
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter your password:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextFormField(
              validator: (value) {
                if (value.isNotEmpty) {
                  //проверка текстинпута на пустую строку, если не пустая - присваиваем имя, если пустая - ошибка
                  return _loginName = value;
                } else
                  return 'Please, entry a password';
              },
              keyboardType: TextInputType.visiblePassword,
            ),
          ],
        ),
      ),
    );
  }

  AuthWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKeyAuth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your login:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextFormField(
              validator: (value) {
                if (value.isNotEmpty) {
                  //проверка текстинпута на пустую строку, если не пустая - присваиваем имя, если пустая - ошибка
                  return _loginName = value;
                } else
                  return 'Please, entry login';
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter your password:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextFormField(
              validator: (value) {
                if (value.isNotEmpty) {
                  //проверка текстинпута на пустую строку, если не пустая - присваиваем имя, если пустая - ошибка
                  return _loginName = value;
                } else
                  return 'Please, entry your password';
              },
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20.0),
            Text(
              'Repeat your password:',
              style: TextStyle(fontSize: 20.0),
            ),
            TextFormField(
              validator: (value) {
                if (value.isNotEmpty) {
                  //проверка текстинпута на пустую строку, если не пустая - присваиваем имя, если пустая - ошибка
                  return _loginName = value;
                } else
                  return 'Please, repeat your password';
              },
              keyboardType: TextInputType.visiblePassword,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: _initPage);

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (_selectedIndex == 0) {
          appBarTitle = "Login screen";
          controller.animateToPage(0, duration: Duration(milliseconds: 800), curve: curve);
        } else {
          appBarTitle = "Auth screen";
          controller.animateToPage(1, duration: Duration(milliseconds: 800), curve: curve);
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            MediaQuery.of(context).size.width > 600
                ? "Enter in app"
                : appBarTitle,
            style: TextStyle(
              fontSize: 25.0,
            )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 600
            ? Container(
                child: Row(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: LoginWidget(),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: AuthWidget(),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                child: PageView(
                  controller: controller,
                  onPageChanged: _onItemTapped,
                  children: [
                    LoginWidget(),
                    AuthWidget(),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 600
          ? null
          : BottomNavigationBar(
              selectedIconTheme: IconThemeData(
                  color: Theme.of(context).accentColor, opacity: 1.0, size: 45),
              unselectedIconTheme: IconThemeData(
                  color: Colors.grey[500], opacity: 0.5, size: 25),
              items: [
                BottomNavigationBarItem(
                    label: "Sign in",
                    icon: Icon(Icons.account_circle),
                    tooltip: "Sign in"),
                BottomNavigationBarItem(
                    label: "Sign up",
                    icon: Icon(Icons.person_add),
                    tooltip: "Sign up"),
              ],
              currentIndex: _selectedIndex,
              backgroundColor: Theme.of(context).primaryColor,
              selectedItemColor: Theme.of(context).accentColor,
              unselectedItemColor: Colors.grey[500],
              onTap: _onItemTapped,
            ),
    );
  }
}
