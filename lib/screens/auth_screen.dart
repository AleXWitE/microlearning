import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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

  final controller = PageController(initialPage: 0);

  Curve curve = Curves.ease;

  String _loginEmail;
  String _loginPass;
  String _authEmail;
  String _authPass;
  String _authRepeat;

  bool _authValidate() {
    final formAuth = _formKeyAuth.currentState;
    if (formAuth.validate()) {
      formAuth.save();
      return true;
    }
    return false;
  }

  String _errMsg;

  void _authButton() async {
    if (_authValidate() && _authPass == _authRepeat) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _authEmail, password: _authPass);
        controller.animateToPage(0,
            duration: Duration(milliseconds: 800), curve: curve);
        _errMsg = "Now you need sign in!";
      } catch (e) {
        print('Error: $e');
        _errMsg = e;
      }
    } else {
      setState(() {
        _authRepeat = "";
        _authPass = "";
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          _errMsg,
          style:
          TextStyle(fontSize: 25.0, color: Theme.of(context).accentColor),
        )));  }

  bool _loginValidate() {
    final form = _formKeyLogin.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _loginButton() async {
    if (_loginValidate()) {
      try {
        auth.UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _loginEmail, password: _loginPass);
        print("User: ${user.user.uid}");
        Navigator.pushNamedAndRemoveUntil(
            context, '/list_events', (route) => false);
      } catch (e) {
        print("Error: $e");
        switch ("$e") {
          case "[ERROR:flutter/lib/ui/ui_dart_state.cc(199)] Unhandled Exception: 'package:flutter/src/widgets/text.dart': Failed assertion: line 378 pos 10: 'data != null': A non-null String must be provided to a Text widget.":
            _errMsg = "Invalid email type";
            break;
          case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
            _errMsg = "Wrong password!";
            break;
          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
            _errMsg = "User not found!";
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          _errMsg,
          style:
              TextStyle(fontSize: 25.0, color: Theme.of(context).accentColor),
        )));
      }
    }
    // setState(() {});
  }

  LoginWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKeyLogin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return 'Please, entry a login';
              },
              onSaved: (value) => _loginEmail = value,
              decoration: InputDecoration(
                labelText: "Login",
                focusColor: Theme.of(context).primaryColor,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return 'Please, entry a password';
              },
              onSaved: (value) => _loginPass = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                focusColor: Theme.of(context).primaryColor,
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              onPressed: () => _loginButton(),
              child: Text(
                "Sign in",
                style: TextStyle(
                    fontSize: 25.0, color: Theme.of(context).accentColor),
              ),
              padding: EdgeInsets.all(15.0),
              color: Theme.of(context).primaryColor,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return 'Please, entry login';
              },
              onSaved: (value) => _authEmail = value,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Login",
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return 'Please, entry your password';
              },
              onSaved: (value) => _authPass = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value.isEmpty && value == _authPass)
                  return 'Please, repeat your password';
              },
              onSaved: (value) => _authRepeat = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Repeat password",
                focusColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              onPressed: () => _authButton(),
              child: Text(
                "Create account",
                style: TextStyle(
                    fontSize: 25.0, color: Theme.of(context).accentColor),
              ),
              padding: EdgeInsets.all(15.0),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        _initPage = index;
        if (_selectedIndex == 0) {
          appBarTitle = "Login screen";
          controller.animateToPage(0,
              duration: Duration(milliseconds: 800), curve: curve);
        } else {
          appBarTitle = "Auth screen";
          controller.animateToPage(1,
              duration: Duration(milliseconds: 800), curve: curve);
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
