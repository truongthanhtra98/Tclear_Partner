import 'dart:async';

import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/valicators/validation.dart';

class CheckInforBloc{
  StreamController _nameController = new StreamController();
  StreamController _phoneController = new StreamController();
  StreamController _emailController = new StreamController();

  Stream get nameStream => _nameController.stream;

  Stream get phoneStream => _phoneController.stream;

  Stream get emailStream => _emailController.stream;

  bool isValidInfoSignUp(UserModel user){
    if(!Validation.isValidName(user.name)){
      _nameController.sink.addError('Bạn chưa nhập tên vào');
      return false;
    }
    _nameController.sink.add('ok');
    if(!Validation.isValidPhone(user.phone)){
      _phoneController.sink.addError('Số điện thoại không hợp lệ');
      return false;
    }
    _phoneController.sink.add('ok');
    if(!Validation.isValidEmail(user.email)){
      _emailController.sink.addError('Email không hợp lệ');
      return false;
    }
    _emailController.sink.add('ok');

    return true;
  }
}