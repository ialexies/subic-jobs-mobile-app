import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subicjobs/models/users.dart';

class RegisterUser extends StatefulWidget {
  String loginType;
  Map<String, String> userInfo;
  RegisterUser({this.userInfo});


  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  

  // _RegisterUserState(this.user);

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register Account"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: <Widget>[
                Form(
                    child: Column(
                  children: <Widget>[
                    // Text(widget.user.displayName.toUpperCase(),
                    //   style: Theme.of(context).textTheme.headline4,

                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: CircleAvatar(
                        // backgroundImage: CachedNetworkImageProvider(
                        //   widget.user.photoUrl
                        // ),
                                           
                      ),
                    ),
                    

        
                    TextFormField(
                      decoration: buildInputDecoration(hintText: "Username"),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      decoration: buildInputDecoration(hintText: "First Name"),
                    ),
                    Divider(),
                    TextFormField(
                      decoration: buildInputDecoration(hintText: "Last Name"),
                    )
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration({String hintText,}) {
    return InputDecoration(
      
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
