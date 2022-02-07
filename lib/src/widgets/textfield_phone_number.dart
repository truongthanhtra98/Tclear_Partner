import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatefulWidget {
  final TextEditingController phoneController;
  final AsyncSnapshot snapshot;

  PhoneNumberTextField({this.phoneController, this.snapshot});

  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {

  @override
  Widget build(BuildContext context) {
   return Container(
     child: TextField(
       keyboardType: TextInputType.phone,
       controller: widget.phoneController,
       style: TextStyle(fontSize: 18, color: Colors.black),
       decoration: InputDecoration(
         labelText: 'Số điện thoại',
         contentPadding: EdgeInsets.symmetric(vertical: 0.0),
         filled: true,
           errorText: widget.snapshot.hasError? widget.snapshot.error : null
       ),
     ),
   );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
