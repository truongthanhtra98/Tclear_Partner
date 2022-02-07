import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tclearpartner/src/bloc/forgot_password_bloc.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/widgets/password_textfield.dart';
import 'package:tclearpartner/src/widgets/repassword_textfield.dart';

class ChangePassword extends StatefulWidget {
  final String idUser;

  ChangePassword(this.idUser);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ForgotPasswordBloc bloc = new ForgotPasswordBloc();
  bool _showPass = false;
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  TextEditingController _passController = new TextEditingController();
  TextEditingController _rePassController = new TextEditingController();

  Widget _buildChangePass() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: onClickChange,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.green,
        child: Text(
          'Thay đổi password',
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
      appBar: AppBar(title: Text('Thay đổi mật khẩu'),),
      body: ModalProgressHUD(
        opacity: 0.5,
        inAsyncCall: _isInAsyncCall,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Text('Nhập lại mật khẩu mới', textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                  stream: bloc.passForgotStream,
                  builder: (context, snapshot) {
                    return PasswordTextField(passController: _passController, snapshot: snapshot,);
                  }
              ),
              SizedBox(
                height: 5.0,
              ),
              StreamBuilder(
                  stream: bloc.rePassStream,
                  builder: (context, snapshot) {
                    return RePasswordTextField(passController: _rePassController, snapshot: snapshot,);
                  }
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildChangePass(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  void onClickShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void onClickChange() {
    setState(() {
      _isInAsyncCall = true;
    });
    String pass = _passController.text.trim();
    String rePass = _rePassController.text.trim();
    Future.delayed(Duration(seconds: 3), (){
      if (bloc.isValidPassForgot(pass, rePass)) {
        FirestoreGetInforUser.updatePassword(widget.idUser, pass).then((value) {
          if (value) {
            showDialog(
                context: context,
                child: AlertDialog(
                  content: Text(
                    'Thành công',
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                      },
                      child: Text('Tiếp tục', style: TextStyle(color: Colors.green),),
                    )
                  ],
                ));
          } else {
            showDialog(
                context: context,
                child: AlertDialog(
                  content: Text('Thay đổi password không thành công'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Đóng'))
                  ],
                ));
          }
        });
      } else {
        print('Not accept');
      }

      setState(() {
        _isInAsyncCall = false;
      });
    });

  }

}
