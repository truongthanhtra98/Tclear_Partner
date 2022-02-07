import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tclearpartner/src/bloc/forgot_password_bloc.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/resources/login_signup/otp_screen.dart';
import 'package:tclearpartner/src/utils/cover_phone.dart';
import 'package:tclearpartner/src/widgets/textfield_phone_number.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  var _textNumberPhoneController = TextEditingController();

  Widget _buildEnterPhoneTxt(){
    return Center(
      child: Text(
        'Nhập số điện thoại đã đăng ký để đặt mật khẩu của bạn',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIdeaPassBtn() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _textNumberPhoneController.value != null ? onClickSendPassword : null,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.green,
        child: Text(
          'Gửi mã OTP',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.0,
            fontSize: 17.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: ModalProgressHUD(
        opacity: 0.5,
        inAsyncCall: _isInAsyncCall,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 5.0,),
              _buildEnterPhoneTxt(),
              SizedBox(height: 20.0,),
              StreamBuilder(
                  stream: _forgotPasswordBloc.phoneForgotStream,
                  builder: (context, snapshot) {
                    return PhoneNumberTextField(phoneController: _textNumberPhoneController, snapshot: snapshot,);
                  }
              ),
              SizedBox(height: 15.0,),
              _buildIdeaPassBtn(),
            ],
          ),
        ),
      ),
    );
  }

  void onClickSendPassword(){

    String phoneCover = CoverPhone.coverPhone(_textNumberPhoneController.text.trim());
    String phoneNumber = '+84' + phoneCover;


      if(_forgotPasswordBloc.isValidInfoForgot(phoneCover)){
        setState(() {
          _isInAsyncCall = true;
        });
        Future.delayed(Duration(seconds: 1), (){
        FirestoreGetInforUser.checkPhone(phoneNumber).then((value){
          if(value){
            UserModel userModel = UserModel(phone: phoneNumber);
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (BuildContext context) => OTPScreen(mobileNumber: phoneNumber, user: userModel,)));
          }else{
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                content: Text('Số điện thoại không tồn tại'),
                actions: [
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('Đóng'))
                ],
              ),
            );
          }
          setState(() {
            _isInAsyncCall = false;
          });
        }); });
      }else{
        print('Not accept');
      }



  }

}
