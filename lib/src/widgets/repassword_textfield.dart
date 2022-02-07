import 'package:flutter/material.dart';

class RePasswordTextField extends StatefulWidget {
  final TextEditingController passController;
  final AsyncSnapshot snapshot;

  RePasswordTextField({this.passController, this.snapshot, });
  @override
  _RePasswordTextFieldState createState() => _RePasswordTextFieldState();
}

class _RePasswordTextFieldState extends State<RePasswordTextField> {
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: TextField(
        controller: widget.passController,
        style: TextStyle(fontSize: 18, color: Colors.black),
        obscureText: showPass ? false : true,
        decoration: InputDecoration(
          labelText: 'Nhập lại mật khẩu',
          errorText: widget.snapshot.hasError? widget.snapshot.error : null,
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              showPass ? Icons.visibility :
              Icons.visibility_off,
              size: 18,
              color: Colors.black,
            ),
            onPressed: (){
              setState(() {
                showPass = !showPass;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
