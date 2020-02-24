import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subicjobs/widgets/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SubicJobs(),
      theme: ThemeData(),
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
      body: SplashScreen(
        title: "Please Login",
        description: "Please Login using your \ngoogle account",
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            label: Text(
              'Google Login',
              style: TextStyle(color: Colors.white70),
            ),
            icon: Icon(
              Icons.email,
              color: Colors.white,
            ),
            onPressed: () => print('fdfdf'),
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
