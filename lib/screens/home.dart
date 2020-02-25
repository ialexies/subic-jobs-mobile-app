import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:subicjobs/widgets/splashScreen.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/fa_icon.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      print('theres a change firebase user in user $firebaseUser');
      if (firebaseUser == null) {
        setState(() {
          isAuth = false;
        });
      }
    }).onError((err) {
      print('Error firabase signin $err');
    });
  }

  @override
  void dispose() {
    super.dispose();
    // pageController.dispose();
    // isAuth=false;
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    // print("signed in " + user.displayName);
    setState(() {
      isAuth = true;
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return isAuth == false ? unAuthScreen() : authScreen();
  }

  authScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _signOut),
    );
  }

  void _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  login() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _googleSignIn.signIn();
      }
    } on SocketException catch (_) {
      // print('not connected');
      // _showSnackBar();
    }
  }

  unAuthScreen() {
    return Scaffold(
      body: SplashScreen(
        title: "Please Login",
        description: "Please Login using your \ngoogle account",
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 250,
            child: Column(
              children: <Widget>[
                Container(
                  // width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: FloatingActionButton(
                          onPressed: null,
                          child: FaIcon(FontAwesomeIcons.facebookF),
                        )),
                        VerticalDivider(),
                        Expanded(
                            child: FloatingActionButton(
                              backgroundColor: Colors.red,
                          onPressed: () {
                            _handleSignIn()
                                .then((FirebaseUser user) => (print(user)))
                                .catchError((e) => print(e));
                          },
                          child: FaIcon(FontAwesomeIcons.google),
                        )),
                        VerticalDivider(),
                        Expanded(
                            child: FloatingActionButton(
                          onPressed: null,
                          child: FaIcon(FontAwesomeIcons.phone),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        image: Container(
          child: Column(
            children: <Widget>[
              SvgPicture.asset('assets/images/sign_in.svg', height: 160.0),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
