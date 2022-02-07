import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/resources/home.dart';
import 'package:tclearpartner/src/resources/login_signup/login.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }


  @override
  void dispose() {
    super.dispose();
  }


  void getCurrentUser() async {
    FirebaseUser _user = await auth.currentUser();
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    GetStore.getListNewJob();
    return Scaffold(
      body: user != null ? HomeScreen(user) : LoginScreen(),
    );
  }
}
