import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:subicjobs/models/users.dart';
import 'package:subicjobs/widgets/splashScreen.dart';
import 'package:subicjobs/screens/registerUser.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
User currentUser;
final usersRef = Firestore.instance.collection('users');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

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

    _googleSignIn.signOut(); //just a test, delete later
  }

  @override
  void dispose() {
    super.dispose();
    // pageController.dispose();
    // isAuth=false;
  }




  _createUserInFirestore(
      {GoogleSignInAccount googleUserAccount, fbUserAcount}) async {
    if (googleUserAccount != null) {
      print('Theres a google account ${googleUserAccount.toString()}');
      DocumentSnapshot doc = await usersRef
          .document(googleUserAccount.email)
          .get(); //check if the google user is existed in  users list of firestore
      // print(googleUserAccount.toString());

      if (doc.exists) {
        setState(() {
          currentUser = User.fromGoogle(doc);
        });

      } else {
        print('register for an account');
        final userName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>RegisterUser(),
          ),
        );
      }
    }

    if (fbUserAcount != null) {
      final String useremail = fbUserAcount["email"].toString();

      DocumentSnapshot doc = await usersRef
          .document(useremail)
          .get(); //check if the google user is existed in  users list of firestore
      // print( await );

      if (doc != null) {
        setState(() {
          currentUser = User.fromFb(doc);
        });
        print(currentUser.email.toString());
      } else {
        print('register for an account');
        // registerAccount(currentUser);
      }
    }
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

    // set currentUser data
    final GoogleSignInAccount user = _googleSignIn.currentUser;
    await _createUserInFirestore(
        googleUserAccount: user); //call this to deserialize the user document

    return credential;
  }

  _handleSignInFacebook() async {
    AuthCredential fbCredential;
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);
    final FacebookAccessToken accessToken = result.accessToken;
    fbCredential =
        FacebookAuthProvider.getCredential(accessToken: accessToken.token);

    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${accessToken.token}');

    final user = json.decode(graphResponse.body);

    await _createUserInFirestore(fbUserAcount: user);

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
      } else if (loginType == "FB") {
        return await _handleSignInFacebook();
      }
    }

    final FirebaseUser user =
        (await _auth.signInWithCredential(await getCredential()).then((val) {
      setState(() {
        isAuth = true;
      });
    }).catchError((err) {
      print('*****error in firbase handlesignin $err');
    }));

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
      body: Text(currentUser.email),
      floatingActionButton: FloatingActionButton(onPressed: _signOut),
    );
  }

  void _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await facebookSignIn.logOut();
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
                              heroTag: "btnFacebook",
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
                              heroTag: "btnGoogle",
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
