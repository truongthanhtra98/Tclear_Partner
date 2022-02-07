import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/firebase_phone_auth.dart';
import 'package:tclearpartner/src/model/user_model.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final UserModel user;

  OTPScreen({
    Key key,
    @required this.mobileNumber,
    this.user
  })  : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin{

  AnimationController controller;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    FirebasePhoneAuth.instantiate(phoneNumber: widget.mobileNumber, userInput: widget.user, buildContext: context );
    //run count time
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);
  }

  Widget _buildEnterCodeTxt(){
    return Center(
      child: Text(
        'Nhập mã kích hoạt đã được tới số điện thoại ${widget.mobileNumber}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildResendCodeTxt(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child){
              return GestureDetector(
                onTap: timerString == '0' ?(){
                  FirebasePhoneAuth.instantiate(phoneNumber: widget.mobileNumber, userInput: widget.user, buildContext: context );
                } : null,
                child: Text(timerString == '0' ? 'Gửi lại mã...($timerString)' : 'Gửi lại mã',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget _buildCancelTxt(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.of(context).popAndPushNamed('/signup');
            //Navigator.of(context).pushNamedAndRemoveUntil('/signup', ModalRoute.withName('/splash'));
          },
          child: Text('Hủy bỏ và tạo tài khoản mới',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationThickness: 2.0,
              decorationStyle: TextDecorationStyle.solid,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color:  Color(0xFFFF8F00),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeTF(){
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.black12, width: 1.5)
        ),
        child:
        TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (String value){
            if(value.length == 6){
              FirebasePhoneAuth.signInWithPhoneNumber(smsCode: value, bContext: context);
            }
          },
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0,  bottom: 0.0),
            border: InputBorder.none,
            hintText: '000000',
            hoverColor: Colors.amberAccent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Nhập mã OTP'),),
        body: _getContent());
  }

  Widget _getContent(){
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 5.0,),
          _buildEnterCodeTxt(),
          _buildCodeTF(),
          _buildResendCodeTxt(),
          SizedBox(height: 20.0,),
          _buildCancelTxt(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

