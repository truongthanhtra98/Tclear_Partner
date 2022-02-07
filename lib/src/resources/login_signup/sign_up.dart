import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:tclearpartner/src/bloc/bloc_signin.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/resources/login_signup/dialog_signup.dart';
import 'package:tclearpartner/src/resources/login_signup/otp_screen.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/cover_phone.dart';
import 'package:tclearpartner/src/widgets/cmnd_textfield.dart';
import 'package:tclearpartner/src/widgets/password_textfield.dart';
import 'package:tclearpartner/src/widgets/textfield_phone_number.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  BlocSignIn _blocSignIn = BlocSignIn();
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _cmndController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký tài khoản'),
      ),
      body: ModalProgressHUD(
        opacity: 0.5,
        inAsyncCall: _isInAsyncCall,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          color: Colors.white,
          child: Column(
            //alignment: Alignment.bottomCenter,
            children: <Widget>[
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Các công việc hấp dẫn đang chờ bạn mỗi ngày.',
                        style: TextStyle(color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      StreamBuilder(
                        stream: _blocSignIn.nameStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Tên bạn',
                              errorText: snapshot.hasError? snapshot.error : null
                            ),
                          );
                        }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: _blocSignIn.emailStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                                errorText: snapshot.hasError? snapshot.error : null
                            ),
                          );
                        }
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.flag,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Việt Nam',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: _blocSignIn.phoneStream,
                        builder: (context, snapshot) {
                          return PhoneNumberTextField(phoneController: _phoneController, snapshot: snapshot,);
                        }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: _blocSignIn.paswordStream,
                        builder: (context, snapshot) {
                          return PasswordTextField(passController: _passController, snapshot: snapshot,);
                        }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                          stream: _blocSignIn.cmndStream,
                          builder: (context, snapshot) {
                            return CMNDTextField(cmndController: _cmndController, snapshot: snapshot,);
                          }
                      ),
                      SizedBox(
                        height: 10,
                      ),
//                      StreamBuilder(
//                          stream: _blocSignIn.cmndStream,
//                          builder: (context, snapshot) {
//                            return CMNDTextField(cmndController: _cmndController, snapshot: snapshot,);
//                          }
//                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15,0, 15, 15),
                child: RaisedButton(
                    color: green,
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                        child: Text('Đăng ký', style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 16))),
                    onPressed: onClickSignUp,
              )
              )],
          ),
        ),
      )
    );
  }

  void onClickSignUp(){

    String name = _nameController.text.trim();
    String cmnd = _cmndController.text.trim();
    String email = _emailController.text.trim();
    String phoneCover = CoverPhone.coverPhone(_phoneController.text.trim());
    String password = _passController.text.trim();
    String phone = '+84' + phoneCover;
    UserModel user = new UserModel(name: name, email: email, phone: phone, password: password, cmnd: cmnd);

      if(_blocSignIn.isValidInfoSignUp(user)){
        setState(() {
          _isInAsyncCall = true;
        });
        String phone = user.phone;
        Future.delayed(Duration(seconds: 2), (){
        FirestoreGetInforUser.checkPhone(phone).then((value){
          print(value);
          if(value){
            print('Phone number exist');
            showDialog(
              context: context,
              builder: (BuildContext context) => SignUpDialog(
                description:
                "Số điện thoại đã được sử dụng, bạn có muốn đăng nhập với số này?",
                buttonText1: "Đóng",
                buttonText2: "Đồng ý",
              ),
            );
          }else{
            FirestoreGetInforUser.checkCMNDExist(cmnd).then((value){
              if(value){
                print('CMND exist');
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text('Số CMND này đã tồn tại'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text('Đóng'),
                      ),
                    ],
                  ),
                );
              }else{
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) => OTPScreen(mobileNumber: phone, user: user,)));
              }
            });
          }
          setState(() {
            _isInAsyncCall = false;
          });
        }); });
      }else{
        print('Not accept');
      }

  }

  @override
  void dispose() {
    super.dispose();
    _passController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cmndController.dispose();
    _blocSignIn.dispose();
  }
}
