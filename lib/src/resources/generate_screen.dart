import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
class GenerateScreen extends StatefulWidget {
  final String _idPartner;

  GenerateScreen(this._idPartner);

  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  GlobalKey globalKey = new GlobalKey();
  //String _dataString = "Hello from this QR";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10),
            child: Text("Đây là mã xác minh của bạn, hãy đưa cho khách hàng để xác nhận thông tin", textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child:  Center(
              child: GestureDetector(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: widget._idPartner,
                    size: 0.5 * bodyHeight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}