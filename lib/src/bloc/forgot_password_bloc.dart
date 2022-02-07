import 'dart:async';
import 'package:tclearpartner/src/valicators/validation.dart';

class ForgotPasswordBloc{
  StreamController _phoneForgotController = new StreamController();
  StreamController _passForgotController = new StreamController();
  StreamController _rePassForgotController = new StreamController();

  Stream get phoneForgotStream => _phoneForgotController.stream;
  Stream get passForgotStream => _passForgotController.stream;
  Stream get rePassStream => _rePassForgotController.stream;

  bool isValidInfoForgot(String phone){

    if(!Validation.isValidPhone(phone)){
      _phoneForgotController.sink.addError('Số điện thoại không hợp lệ');
      return false;
    }
    _phoneForgotController.sink.add('ok');

    return true;
  }

  void dispose(){
    _phoneForgotController.close();
    _passForgotController.close();
    _rePassForgotController.close();
  }

  bool isValidPassForgot(String pass, String rePass){
    if(!Validation.isValidPassword(pass)){
      _passForgotController.sink.addError('Password không hợp lệ');
      return false;
    }
    _passForgotController.sink.add('ok');

    if(!Validation.isValidPassword(rePass)){
      _rePassForgotController.sink.addError('Password không hợp lệ');
      return false;
    }
    _rePassForgotController.sink.add('ok');

    if(rePass != pass){
      _rePassForgotController.sink.addError('Không khớp');
      return false;
    } _rePassForgotController.sink.add('ok');

    return true;

  }
}