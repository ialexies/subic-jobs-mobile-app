import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register Account'),
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
      ke
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
