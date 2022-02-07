import 'dart:async';

import 'package:tclearpartner/src/valicators/validation.dart';


class LoginBloc{
  StreamController _phoneLoginController = new StreamController();
  StreamController _passwordLoginContoller = new StreamController();

  Stream get phoneLoginStream => _phoneLoginController.stream;

  Stream get paswordLoginStream => _passwordLoginContoller.stream;

  bool isValidInfoLogin(String phone, String password){

    if(!Validation.isValidPhone(phone)){
      _phoneLoginController.sink.addError('Số điện thoại không hợp lệ');
      return false;
    }
    _phoneLoginController.sink.add('ok');

    if(!Validation.isValidPassword(password)){
      _passwordLoginContoller.sink.addError('Password không hợp lệ');
      return false;
    }
    _passwordLoginContoller.sink.add('ok');
    return true;
  }

  void dispose(){
    _phoneLoginController.close();
    _passwordLoginContoller.close();
  }
}