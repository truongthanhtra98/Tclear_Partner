import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/resources/home.dart';

enum PhoneAuthState {
  Started,
  CodeSent,
  CodeResent,
  Verified,
  Failed,
  Error,
  AutoRetrievalTimeOut
}

class FirebasePhoneAuth {
  static var _authCredential, actualCode, phone, status;
  static UserModel userCreate;
  static BuildContext context;
  static StreamController<String> statusStream =
  StreamController.broadcast();
  static StreamController<PhoneAuthState> phoneAuthState =
  StreamController.broadcast();
  static Stream stateStream = phoneAuthState.stream;

  static instantiate({String phoneNumber, UserModel userInput, BuildContext buildContext}) async {
    assert(phoneNumber != null);
    phone = phoneNumber;
    context = buildContext;
    userCreate = userInput;
    print(phone);
    startAuth();
  }

  static dispose() {
//    statusStream.close();
//    phoneAuthState.close();
  }

  static startAuth() {
    statusStream.stream
        .listen((String status) => print("PhoneAuth: " + status));
    addStatus('Phone auth started');
    auth
        .verifyPhoneNumber(
        phoneNumber: phone.toString(),
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      addStatus('Code sent');
    }).catchError((error) {
      addStatus(error.toString());
    });
  }

  static final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    addStatus("\nEnter the code sent to " + phone + " code : " + actualCode);
    addState(PhoneAuthState.CodeSent);
  };

  static final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    actualCode = verificationId;
    addStatus("\nAuto retrieval time out " + actualCode);
    addState(PhoneAuthState.AutoRetrievalTimeOut);
  };

  static final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {
    addStatus('${authException.message}');
    addState(PhoneAuthState.Error);
    if (authException.message.contains('not authorized'))
      addStatus('App not authroized');
    else if (authException.message.contains('Network'))
      addStatus('Please check your internet connection and try again');
    else
      addStatus('Something has gone wrong, please try later ' +
          authException.message);
  };

  static final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential authCredential) {
    addStatus('Auto retrieving verification code');

    auth.signInWithCredential(authCredential).then((AuthResult value) {
      if (value.user != null) {
        addStatus(status = 'Authentication successful');
        addState(PhoneAuthState.Verified);
        onAuthenticationSuccessful(value.user, context);
      } else {
        addState(PhoneAuthState.Failed);
        addStatus('Invalid code/invalid authentication');
      }
    }).catchError((error) {
      addState(PhoneAuthState.Error);
      addStatus('Something has gone wrong, please try later $error');
    });
  };

  static void signInWithPhoneNumber({String smsCode, BuildContext bContext}) async {
    _authCredential = PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);

    auth
        .signInWithCredential(_authCredential)
        .then((AuthResult result) async {
      addStatus('Authentication successful');
      addState(PhoneAuthState.Verified);
      onAuthenticationSuccessful(result.user, bContext);
    }).catchError((error) {
      addState(PhoneAuthState.Error);
      addStatus(
          'Something has gone wrong, please try later(signInWithPhoneNumber) $error');
    });
  }

  static onAuthenticationSuccessful(FirebaseUser user, BuildContext context) {
    if(userCreate != null){


      if(userCreate.password != null){
        print('signup');
        FirestoreGetInforUser.addUserNew(user.uid, userCreate);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user),
            ),
                (Route<dynamic> route) => false);
      }else{
        print('forgot password');
        Navigator.of(context).popAndPushNamed('/change_pass', arguments: user.uid);
        auth.signOut();
      }
    }else{
      print('login');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user),
          ),
              (Route<dynamic> route) => false);
    }

  }

  static addState(PhoneAuthState state) {

    print(state);
    phoneAuthState.sink.add(state);
  }

  static void addStatus(String s) {
    statusStream.sink.add(s);
    print(s);
  }
}