import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:microlearning/screens/auth_screen.dart';


class GoogleSignInMethod extends StatefulWidget {
  GoogleSignInState createState() => GoogleSignInState();
}

class GoogleSignInState extends State<GoogleSignInMethod> {
  bool _isSigningIn = false;

  bool isSignIn = false;
  bool google = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            signInWithGoogle().then((auth.User user) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/list_events', (route) => false);
            }).catchError((e) => print(e));
            setState(() {
              _isSigningIn = true;
            });

            setState(() {
              _isSigningIn = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SvgPicture.asset("assets/icons/google_icon.svg"),
                  height: 35.0,
                ),
                   Text(
                    AppLocalizations.of(context).googleSignInInfo,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

              ],
            ),
          )),
    );
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    String _errMsg;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') _errMsg = AppLocalizations.of(context).errorSignInCredentials;
           else if (e.code == 'invalid-credential') _errMsg = AppLocalizations.of(context).errorSignInErrCredentials;
            ScaffoldMessenger.of(context).showSnackBar(
              AuthScreen().createState().customSnackBar(_errMsg),
            );
        } catch (e) {
          _errMsg = AppLocalizations.of(context).errorGoogleSignInCredentials;
          ScaffoldMessenger.of(context).showSnackBar(
              AuthScreen().createState().customSnackBar(_errMsg),
          );
        }
      }
    }
    return user;
  }
  static Future<void> signOut({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    String _errMsg = AppLocalizations.of(context).errorSignOut;
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(AuthScreen().createState().customSnackBar(_errMsg),
      );
    }
  }
}
