import "package:flutter/material.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SubicJobs(),
    );
  }
}

class SubicJobs extends StatefulWidget {
  @override
  _SubicJobsState createState() => _SubicJobsState();
}

class _SubicJobsState extends State<SubicJobs> {
  bool authStat = false;

  @override
  Widget build(BuildContext context) {
    return authStat == false ? unAuthScreen() : authScreen();
  }

  authScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('dsdsd'),
      ),
    );
  }

  unAuthScreen() {
    return Scaffold(
      body: splashScreen(
        title: "Please Login",
        description: "Please Login using your \ngoogle account",
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            label: Text('Google Login', style: TextStyle(color: Colors.white70),),
            icon: Icon(Icons.email, color: Colors.white,),
            onPressed: ()=>print('fdfdf'),
          ),
        ),
      ),
    );
  }

  Widget splashScreen({String title, String description, Widget content}) {
    return SafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(title.toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 15,
                ),
                Text(description.toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 30,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                    )),
                content != null ? content : Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
