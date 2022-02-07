import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_1.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_2.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_3.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_4.dart';
import 'package:tclearpartner/src/model/history_model.dart';
import 'package:tclearpartner/src/resources/form_history.dart';

class HistoryPage extends StatelessWidget {
  final String idPartner;
  HistoryPage(this.idPartner);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử công việc'),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    var storeHistory = store.collection('lichsunhanviec').document(idPartner).snapshots();
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
      color: Colors.grey[300],
      child: StreamBuilder(
          stream: storeHistory,
          builder: (context, snapshot){
            List<dynamic> listHistory = [];
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(),);
              case ConnectionState.none:
                return Center(child: Text('Không có lịch sử'),);
              default:
                DocumentSnapshot documentSnapshot = snapshot.data;
                if(documentSnapshot.data != null){
                  listHistory.clear();
                  listHistory = snapshot.data['list_history'];
                  return listHistory != null ?
                  ListView.builder(
                      itemCount: listHistory.length,
                      itemBuilder: (context, index){
                        return showHistory(listHistory[(listHistory.length -1) - index]);
                      })
                      : Center(child: Text('Không có lịch sử'),);}else{
                  return Center(child: Text('Không có lịch sử'));
                }
            }
          }),
    );
  }

  Widget showHistory(Map<dynamic, dynamic> map) {
    String idDetail = map['idDetail'];
    HistoryModel historyModel = HistoryModel.fromHistory(map);
    DetailPutService detail;
    var storeDetail = store.collection('chitietcongviec').document(idDetail).snapshots();
    return StreamBuilder(
        stream: storeDetail,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              String idDV = snapshot.data['id'];
              if (idDV == 'DV01') {
                detail = ModelService1().fromAsyncSnapshot(snapshot);
              } else if (idDV == 'DV02') {
                detail = ModelService2().fromAsyncSnapshot(snapshot);
              } else if (idDV == 'DV03') {
                detail = ModelService3().fromAsyncSnapshot(snapshot);
              } else if (idDV == 'DV04') {
                detail = ModelService4().fromAsyncSnapshot(snapshot);
              }
              return FormHistory(detail, historyModel);
          }
        });

  }
}
