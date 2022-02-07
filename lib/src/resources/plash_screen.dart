import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/utils/image.dart';

class PlashScreen extends StatefulWidget {
  @override
  _PlashScreenState createState() => _PlashScreenState();
}

class _PlashScreenState extends State<PlashScreen> {
  var _connectionStatus = 'Unknown';
  bool connected = true;
  bool loading = false;
  var connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    //checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    checkInternet();
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageLogo, color: Colors.white, width: 100, height: 100,),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(child: CircularProgressIndicator(backgroundColor: Colors.white,), height: 10, width: 10,),
                  SizedBox(width: 10,),
                  Text('Xin chào đến với TClear', style: TextStyle(color: Colors.white),),
                ],
              )
            ],
          ),
        ),
      ),
      bottomSheet: connected? SizedBox(): GestureDetector(
        onTap: (){
          setState(() {
            loading = true;
          });
          checkInternet();
        },
        child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black45,
            width: MediaQuery.of(context).size.width,
            child: loading ? Row(
              children: [
                Icon(Icons.autorenew, color: Colors.white,),
                SizedBox(width: 20,),
                Text('Đang tải lại', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
              ],
            ) : Row(
              children: [
                Icon(Icons.autorenew, color: Colors.green,),
                SizedBox(width: 20,),
                Text('Bấm để kết nối lại', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),),
              ],
            )),
      ),
    );
  }

  void checkInternet(){
    connectivity = new Connectivity();
    Future.delayed(Duration(seconds: 3), (){
      setState(() {
        subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
            connected = true;
            Future.delayed(Duration(seconds: 1), (){
              Navigator.of(context).pushNamedAndRemoveUntil('/app', (route) => false);
            });
          }else{
            connected = false;
          }
        });
      });
      setState(() {
        if(!connected){
          loading = false;
        }
      });
    });

  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

}
