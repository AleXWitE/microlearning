import 'package:shared_preferences/shared_preferences.dart';

class Users{
  String email;

  Users({this.email});
}

Users savedUser;

class Divisions{
  String division;

  Divisions({this.division});
}

class Courses{
  int id;
  String course;
  String division;
  bool favorite;

  Courses({this.id, this.course, this.division, this.favorite});

}


// final databaseRef = FirebaseFirestore.instance.collection('users');
// var fbUser = FirebaseAuth.instance.currentUser;

// var userRole = databaseRef.doc(fbUser.email).get().then((value) => value.data()['user_role']).toString();

// String userRole = 'admin';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

String userRole;
String userDivision;
String userName;


getUserRole() async{
  SharedPreferences prefs = await _prefs;
  userRole = prefs.getString('USER_ROLE') ?? '';
  userDivision = prefs.getString('USER_DIV') ?? '';
  userName = prefs.getString('USER_NAME') ?? '';
  print("User role $userRole");
}

// String userRole = '';
// String userRole = 'moderator';