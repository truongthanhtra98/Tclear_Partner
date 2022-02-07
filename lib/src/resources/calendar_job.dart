import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/data_support.dart';

class CalendarJob extends StatefulWidget {
  final String idPartner;
  CalendarJob(this.idPartner);
  @override
  _CalendarJobState createState() => _CalendarJobState();
}

class _CalendarJobState extends State<CalendarJob> {
  @override
  Widget build(BuildContext context) {
    var storeCalendar = store
        .collection('lichlamviec')
        .document(widget.idPartner)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch làm việc'),
      ),
      body: StreamBuilder(
          stream: storeCalendar,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                DocumentSnapshot documentSnapshot = snapshot.data;
                var sortedMap = Map.fromEntries(
                    documentSnapshot.data.entries.toList()
                      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

                return documentSnapshot.data != null && documentSnapshot.data.length != 0
                    ? DefaultTabController(
                  length: documentSnapshot.data.length,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.maxFinite,
                        color: white,
                        padding: EdgeInsets.all(3.0),
                        child: TabBar(
                          isScrollable: true,
                          labelColor: white,
                          labelPadding: EdgeInsets.symmetric(vertical: 5),
                          unselectedLabelColor: green,
                          //indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding: EdgeInsets.only(
                            left: 30,
                            right: 30,
                          ),
                          indicator: ShapeDecoration(
                            color: green,
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: green,
                              ),
                            ),
                          ),
                          tabs: sortedMap.keys.map((key) {
                            if(documentSnapshot.data[key].length == 0){
                              store.collection('lichlamviec').document(widget.idPartner).updateData({
                                '$key': FieldValue.delete()
                              });
                            }
                            return Tab(
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints.expand(
                                  width: 100,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Center(
                                          child: Text(
                                            "${formatterDay.format(formatterYYMMdd.parse(key))}",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        )),Expanded(
                                        child: Center(
                                          child: Text(
                                            "${documentSnapshot.data[key].length} cv",
                                            style: TextStyle(fontSize: 14, color: Colors.pink),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.grey[300],
                          child: TabBarView(
                            children: sortedMap.values
                                .map((listCalendar) {
                              return ListView(
                                padding: EdgeInsets.all(10.0),
                                children: <Widget>[
                                  Session(listCalendar),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Center(
                  child: Text('Không có lịch làm việc'),
                );
            }
          }),
    );
  }
}

class Session extends StatelessWidget {
  final List<dynamic> listCalendar;
  Session(this.listCalendar);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              children: listCalendar.map((idDetail) {
                return Calendar(idDetail);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  final String idDetail;
  Calendar(this.idDetail);



  @override
  Widget build(BuildContext context) {
    var storeDetail = store.collection('chitietcongviec').document(idDetail).snapshots();
    return StreamBuilder(
        stream: storeDetail,
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              var timeStart = formatterHasHour.parse(snapshot.data['thoigianbatdau']);
              return Container(
                margin: EdgeInsets.all(3),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${formatterHour.format(timeStart)} - ${formatterHour.format(timeStart.add(Duration(hours: snapshot.data['weightWork']['thoigianlam'])))}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                          stream: store.collection('dichvu').document(snapshot.data['id']).snapshots(),
                          builder: (context, snapDV) {
                            switch (snapDV.connectionState){
                              case ConnectionState.waiting:
                                return Text('Loading...');
                              default:
                                return Text(
                                  '${snapDV.data['nameservice']}',
                                  style: TextStyle(
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                );
                            }

                          }
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Địa chỉ nhà: ',
                            style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(text: '${snapshot.data['location']['diachi']}', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.normal),)
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }

        }
    );
  }
}
