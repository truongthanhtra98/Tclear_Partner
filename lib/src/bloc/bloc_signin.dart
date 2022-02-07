import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/resources/login_signup/dialog_signup.dart';
import 'package:tclearpartner/src/resources/login_signup/otp_screen.dart';
import 'package:tclearpartner/src/valicators/validation.dart';

class BlocSignIn{

  // kiểm tra hợp lệ ấy mà
  StreamController _nameController = new StreamController();
  StreamController _phoneController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _passwordContoller = new StreamController();
  StreamController _cmndContoller = new StreamController();

  Stream get nameStream => _nameController.stream;

  Stream get phoneStream => _phoneController.stream;

  Stream get emailStream => _emailController.stream;

  Stream get paswordStream => _passwordContoller.stream;

  Stream get cmndStream => _cmndContoller.stream;

  bool isValidInfoSignUp(UserModel user){
    if(!Validation.isValidName(user.name)){
      _nameController.sink.addError('Bạn chưa nhập tên vào');
      return false;
    }
    _nameController.sink.add('ok');

    if(!Validation.isValidEmail(user.email)){
      _emailController.sink.addError('Email không hợp lệ');
      return false;
    }
    _emailController.sink.add('ok');

    if(!Validation.isValidPhone(user.phone)){
      _phoneController.sink.addError('Số điện thoại không hợp lệ');
      return false;
    }
    _phoneController.sink.add('ok');

    if(!Validation.isValidPassword(user.password)){
      _passwordContoller.sink.addError('Password không hợp lệ');
      return false;
    }
    _passwordContoller.sink.add('ok');
    if(!Validation.isValidCMND(user.cmnd)){
      _cmndContoller.sink.addError('Bạn hãy kiểm tra lại số CMND');
      return false;
    }
    _cmndContoller.sink.add('ok');

    return true;
  }



  void dispose(){
    _nameController.close();
    _phoneController.close();
    _emailController.close();
    _passwordContoller.close();
    _cmndContoller.close();
  }


}