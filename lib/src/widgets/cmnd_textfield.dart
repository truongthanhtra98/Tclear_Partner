import 'package:flutter/material.dart';
import 'package:tclearpartner/src/utils/colors.dart';

class CMNDTextField extends StatefulWidget {
  final TextEditingController cmndController;
  final AsyncSnapshot snapshot;

  CMNDTextField({this.cmndController, this.snapshot, });
  @override
  _CMNDTextFieldState createState() => _CMNDTextFieldState();
}

class _CMNDTextFieldState extends State<CMNDTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: widget.cmndController,
        style: TextStyle(fontSize: 18, color: black),
        decoration: InputDecoration(
          labelText: 'Số CMND',
          errorText: widget.snapshot.hasError? widget.snapshot.error : null,
          contentPadding: EdgeInsets.symmetric(vertical: 0.0),
          filled: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
