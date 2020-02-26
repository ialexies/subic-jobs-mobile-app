import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:subicjobs/widgets/splashScreen.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';

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

  _handleSignInGoogle() async {
    AuthCredential credential;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return credential;
  }


    Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  _handleSignInFacebook() async {
    AuthCredential fbCredential;
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);
    final FacebookAccessToken accessToken = result.accessToken;
    fbCredential = FacebookAuthProvider.getCredential(accessToken: accessToken.token);

    return fbCredential;

    // //************getting user info**********
    // final graphResponse = await http.get(
    //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${accessToken.token}');
    // // final profile = JSON.decode(graphResponse.body);
    // final profile = json.decode(graphResponse.body);
    // print(profile.toString());

  }

  Future<FirebaseUser> _handleSignIn(String loginType) async {
    getCredential() async {
      if (loginType == "G") {
        return await _handleSignInGoogle();
        // return await _handleFBSignIn();
      }else if(loginType == "FB"){
        return await _handleSignInFacebook();
      }
    }

    final FirebaseUser user =
        (await _auth.signInWithCredential(await getCredential())).user;
    // print("signed in " + user.displayName);
    setState(() {
      isAuth = true;
    });
    return user;
  }


  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
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
    await facebookSignIn.logOut();
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
        description: "Please Login using \n your preffered account",
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 160,
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
                          onPressed: () {
                            _handleSignIn("FB")
                                .then((FirebaseUser user) => (print(user)))
                                .catchError((e) => print(e));
                          },
                          child: FaIcon(FontAwesomeIcons.facebookF),
                        )),
                        VerticalDivider(),
                        Expanded(
                            child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            _handleSignIn("G")
                                .then((FirebaseUser user) => (print(user)))
                                .catchError((e) => print(e));
                          },
                          child: FaIcon(FontAwesomeIcons.google),
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
