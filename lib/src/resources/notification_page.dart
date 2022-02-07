import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/notification_model.dart';
import 'package:tclearpartner/src/utils/colors.dart';


class NotificationPage extends StatelessWidget {
  final String idUser;

  NotificationPage(this.idUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông báo'),),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _content(),
      ),
    );
  }

  Widget _content(){
    return StreamBuilder(
        stream: store.collection('thongbaopartner').document(idUser).snapshots(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              DocumentSnapshot documentSnapshot = snapshot.data;
              if(documentSnapshot.data != null && snapshot.data['list_notification'] != null){
                List<dynamic> list = snapshot.data['list_notification'];
                return Container(
                  child: list.length != 0? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index){
                        NotificationModel notificationModel = NotificationModel.fromMap(list[(list.length-1) - index]);
                        return ListTile(
                          title: _notification(notificationModel),
                          trailing: IconButton(icon: Icon(Icons.clear, color: Colors.grey,), alignment: Alignment.topRight, onPressed: (){
                            NotificationStore.deleteNotification(idUser, list[(list.length-1) - index]);
                          },),
                          contentPadding: EdgeInsets.all(0),
                        );
                      }) : Center(child: Text('Không có thông báo', style: TextStyle(color: black),),),
                );
              }else{
                return Center(child: Text('Không có thông báo', style: TextStyle(color: black),),);
              }
          }
        }
    );
  }

  Widget _notification(NotificationModel notificationModel){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //chủ đề(có người nhân việc, công việc hoàn thành)
        Text('${notificationModel.topic}', style: TextStyle(fontWeight: FontWeight.bold),),
        //time
        Text('${notificationModel.time}', style: TextStyle(fontSize: 10),),
        // nội dung(NG Van A dã nhan viẹc) (dánh giá người giúp việc.)
        Text('${notificationModel.content}',),
        Divider(),
      ],
    );
  }
}
