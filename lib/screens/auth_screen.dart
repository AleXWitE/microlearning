import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microlearning/api/services/google_sign_in.dart';
import 'package:microlearning/components/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String appBarTitle = "";
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

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _userEmail;
  Future<String> _userPass;

  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/list_events', (route) => false);
    }
  }

  customSnackBar(String _errorMsg){
    return SnackBar(
        duration: Duration(seconds: 5),
        elevation: 5.0,
        backgroundColor: Theme.of(context).primaryColor,
        width: 400.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Text(
          _errorMsg,
          style:
          TextStyle(fontSize: 25.0, color: Theme.of(context).accentColor),
        ));
  }

  Future<void> _prefUser(String loginUser, String passUser) async {
    final SharedPreferences prefs = await _prefs;
    final String userEmail = loginUser;
    final String userPass = passUser;

    setState(() {
      _userEmail =
          prefs.setString("userEmailPref", userEmail).then((bool success) {
        return userEmail;
      });
      _userPass =
          prefs.setString("userPassPref", userPass).then((bool success) {
        return userPass;
      });
    });
  }

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
        _errMsg = AppLocalizations.of(context).infoAfterReg;
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
    ScaffoldMessenger.of(context).showSnackBar(customSnackBar(_errMsg));
  }

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
        savedUser = Users(uid: user.user.uid, email: user.user.email);
        print("User: ${user.user.uid}");
        Navigator.pushNamedAndRemoveUntil(
            context, '/list_events', (route) => false);
        _prefUser(_loginEmail, _loginPass);
      } catch (e) {
        print("Error: $e");
        // print("$_loginEmail | $_loginPass");
        switch ("$e") {
          case "[firebase_auth/argument-error] signInWithEmailAndPassword failed: First argument \"email\" must be a valid string.":
            _errMsg = "Invalid email type";
            break;
          case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
            _errMsg = "Wrong password!";
            break;
          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
            _errMsg = "User not found!";
            break;
          default:
            _errMsg = "Something wrong!";
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(_errMsg));
      }
    }
    // setState(() {});
  }

  OrWidget() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(15.0),
            child: Divider(
              thickness: 3.0,
              height: 2.0,
            )),
        Text(
          AppLocalizations.of(context).or,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28.0),
        ),
        Padding(
            padding: EdgeInsets.all(15.0),
            child: Divider(
              thickness: 3.0,
              height: 2.0,
            )),
        GoogleSignInMethod(),
      ],
    );
  }

  LoginWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKeyLogin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).emailErr;
                },
                onSaved: (value) => _loginEmail = value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).email,
                  focusColor: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).passwordErr;
                },
                onSaved: (value) => _loginPass = value,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).password,
                  focusColor: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                onPressed: () => _loginButton(),
                child: Text(
                  AppLocalizations.of(context).signIn,
                  style: TextStyle(
                      fontSize: 25.0, color: Theme.of(context).accentColor),
                ),
                padding: EdgeInsets.all(15.0),
                color: Theme.of(context).primaryColor,
              ),
              MediaQuery.of(context).size.width > 600
                  ? Container()
                  : OrWidget(),
            ],
          ),
        ),
      ),
    );
  }

  AuthWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKeyAuth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).emailErr;
                },
                onSaved: (value) => _authEmail = value,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).email,
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return AppLocalizations.of(context).passwordErr;
                },
                onSaved: (value) => _authPass = value,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).password,
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty && value == _authPass)
                    return AppLocalizations.of(context).passwordRepeatErr;
                },
                onSaved: (value) => _authRepeat = value,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).passwordRepeat,
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                onPressed: () => _authButton(),
                child: Text(
                  AppLocalizations.of(context).createAcc,
                  style: TextStyle(
                      fontSize: 25.0, color: Theme.of(context).accentColor),
                ),
                padding: EdgeInsets.all(15.0),
                color: Theme.of(context).primaryColor,
              ),
              MediaQuery.of(context).size.width > 600
                  ? Container()
                  : OrWidget(),
            ],
          ),
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
          appBarTitle = AppLocalizations.of(context).loginApp;
          controller.animateToPage(0,
              duration: Duration(milliseconds: 800), curve: curve);
        } else {
          appBarTitle = AppLocalizations.of(context).registerApp;
          controller.animateToPage(1,
              duration: Duration(milliseconds: 800), curve: curve);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            MediaQuery.of(context).size.width > 600
                ? AppLocalizations.of(context).startApp
                : appBarTitle == ""
                    ? AppLocalizations.of(context).loginApp
                    : appBarTitle,
            style: TextStyle(
              fontSize: 25.0,
            )),
        // actions: [SwitchLocale()],
        centerTitle: true,
      ),
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 600
            ? SingleChildScrollView(
              child: Column(children: [
                  Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 3,
                          child: LoginWidget(),
                        ),
                        VerticalDivider(
                          width: 3.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 3,
                          child: AuthWidget(),
                        ),
                      ],
                    ),
          OrWidget(),
                ]),
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
                    label: AppLocalizations.of(context).signIn,
                    icon: Icon(Icons.account_circle),
                    tooltip: AppLocalizations.of(context).signIn),
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context).signUp,
                    icon: Icon(Icons.person_add),
                    tooltip: AppLocalizations.of(context).signUp),
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
