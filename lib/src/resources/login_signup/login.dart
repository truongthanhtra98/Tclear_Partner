import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tclearpartner/src/bloc/login_bloc.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/resources/login_signup/dialog_login.dart';
import 'package:tclearpartner/src/resources/login_signup/forgot_password_page.dart';
import 'package:tclearpartner/src/resources/login_signup/otp_screen.dart';
import 'package:tclearpartner/src/resources/login_signup/sign_up.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/cover_phone.dart';
import 'package:tclearpartner/src/utils/image.dart';
import 'package:tclearpartner/src/widgets/password_textfield.dart';
import 'package:tclearpartner/src/widgets/textfield_phone_number.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc = LoginBloc();
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0.5,
        inAsyncCall: _isInAsyncCall,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
          color: white,
          child: ListView(
            children: <Widget>[
              _logo(),
              _textDownLogo(),
              StreamBuilder(
                  stream: _loginBloc.phoneLoginStream,
                  builder: (context, snapshot) {
                    return PhoneNumberTextField(phoneController: _phoneController, snapshot: snapshot,);
                  }
              ),
              StreamBuilder(
                  stream: _loginBloc.paswordLoginStream,
                  builder: (context, snapshot) {
                    return PasswordTextField(passController: _passController, snapshot: snapshot,);
                  }
              ),
              _buildLoginBtn(),
              _buildLineText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo(){
    return Center(
      child: Image.asset(imageLogo, color: green, height: 100, width: 100,),
    );
  }

  Widget _textDownLogo(){
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 40),
      child: Text(
        'Dành cho cộng tác viên của TClear',
        style: TextStyle(
            color: black, fontSize: 18, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){

          String phoneCover = CoverPhone.coverPhone(_phoneController.text.trim());
          String phoneNumber = '+84' + phoneCover;
          String password = _passController.text.trim();

            if(_loginBloc.isValidInfoLogin(phoneCover, password)){
              setState(() {
                _isInAsyncCall = true;
              });
              Future.delayed(Duration(seconds: 2), (){
              FirestoreGetInforUser.checkExist(phoneNumber, password).then((value){
                if(value){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OTPScreen(
                              mobileNumber: phoneNumber, user: null,
                            ),
                      ));
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => LoginDialog(
                      description:
                      "Số điện thoại hoặc mật khẩu không đúng",
                      buttonText: "Đóng",
                    ),
                  );
                }
              });
              setState(() {
                _isInAsyncCall = false;
              });
              });
            }else{
              print('Not accept');
            }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: green,
        child: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.0,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLineText(){
    return Row(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
            child: Text('Đăng ký', style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),)),
        Spacer(),
        FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ForgotPassword()));
            },
            child: Text('Bạn quên mật khẩu?', style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),))
      ],
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loginBloc.dispose();
  }
}
