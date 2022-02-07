import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/resources/login_signup/login.dart';

class SignUpDialog extends StatelessWidget {
  final String description, buttonText1, buttonText2;

  SignUpDialog({
    @required this.description,
    @required this.buttonText1,
    @required this.buttonText2
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text(buttonText1),
                    ),

                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (BuildContext context) => LoginScreen()));// To close the dialog
                      },
                      child: Text(buttonText2, style: TextStyle(color: Colors.lightGreen),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}