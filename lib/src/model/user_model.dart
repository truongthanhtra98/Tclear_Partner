
import 'package:password/password.dart';
import 'package:tclearpartner/src/utils/data_support.dart';

class UserModel {
  String id;
  String name;
  String email;
  String phone;
  String password;
  String image;
  String cmnd;

  UserModel({this.id, this.name, this.email, this.phone, this.password, this.image, this.cmnd});

  UserModel.fromMap(Map<String, dynamic> data, String id):
      name = data['name'],
      email = data['email'],
      phone = data['phone'],
      password = data['password'],
      image = data['image'],
      cmnd = data['cmnd'],
      id = id;

  Map<String, dynamic> toMap(){
    return {
      'cmnd': cmnd,
      'name': name,
      'email': email,
      'phone': phone,
      'password': Password.hash(password, algorithm),
    };
  }

  Map<String, dynamic> toMapContact(){
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

}