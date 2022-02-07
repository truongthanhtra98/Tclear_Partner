import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_1.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_2.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_3.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_4.dart';
import 'package:tclearpartner/src/model/service_model.dart';
import 'package:tclearpartner/src/resources/detail_accept.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/data_support.dart';

class AcceptJob extends StatefulWidget {
  final String idDetail;
  final String idPartner;
  AcceptJob(this.idPartner, this.idDetail);

  @override
  _AcceptJobState createState() => _AcceptJobState();
}

class _AcceptJobState extends State<AcceptJob>
    with AutomaticKeepAliveClientMixin {
  DetailPutService detail;

  @override
  Widget build(BuildContext context) {
    var storeDetail = store
        .collection('chitietcongviec')
        .document(this.widget.idDetail)
        .snapshots();
    return StreamBuilder(
        stream: storeDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String id = snapshot.data['id'];
            if (id == 'DV01') {
              detail = ModelService1().fromAsyncSnapshot(snapshot);
            } else if (id == 'DV02') {
              detail = ModelService2().fromAsyncSnapshot(snapshot);
            } else if (id == 'DV03') {
              detail = ModelService3().fromAsyncSnapshot(snapshot);
            } else if (id == 'DV04') {
              detail = ModelService4().fromAsyncSnapshot(snapshot);
            }
            return snapshot.data == null
                ? SizedBox()
                : _cardFormDetail(context);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _cardFormDetail(BuildContext context) {
    ServiceModel serviceModel;
    if (detail.idService == 'DV01') {
      serviceModel = ServiceModel.s1();
    } else if (detail.idService == 'DV02') {
      serviceModel = ServiceModel.s2();
    }else if (detail.idService == 'DV03') {
      serviceModel = ServiceModel.s3();
    }

    return Center(
      child: Card(
        color: Colors.white,
        child: FlatButton(
          padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DetailAccept(
                    serviceModel: serviceModel,
                    detailPutService: detail,
                    idPartner: widget.idPartner,
                  )));
            },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: white,
                        child: Image.asset(
                          serviceModel.imageService,
                          color: green,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    Expanded(child: Text('${serviceModel.nameService.toUpperCase()}', style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 14),)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Bắt đầu lúc: ',
                      style: TextStyle(color: black),
                      children: [
                        TextSpan(
                            text: '${detail.startTime}',
                            style: TextStyle(
                                color: green, fontWeight: FontWeight.bold))
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: grey),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: detail is ModelService3 ? _widgetForService3(detail) : Column(
                            children: <Widget>[
                              Text('Làm trong:', style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${detail.weightWork.thoiGian}h',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: green),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                      children: [
                                        detail.weightWork.soNguoiLam != null && detail.weightWork.soNguoiLam != 1
                                            ? TextSpan(
                                            text:
                                            '${detail.weightWork.soNguoiLam} người làm ')
                                            : TextSpan(),
                                        detail.weightWork.soPhong != null
                                            ? TextSpan(
                                            text:
                                            '${detail.weightWork.soPhong} hoặc ')
                                            : TextSpan(),
                                        detail.weightWork.dienTich != null
                                            ? TextSpan(
                                            text: '${detail.weightWork.dienTich}')
                                            : TextSpan(),
                                      ])),
                            ],
                          )),
                      VerticalDivider(),
                      Expanded(
                          child: Column(
                            children: <Widget>[
                              Text('Số tiền (VND): ', style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 5,
                              ),
                              Text('${oCcy.format(detail.paymentMethod.money)}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: green)),
                              SizedBox(
                                height: 5,
                              ),
                              detail.tip != null
                                  ? Text('Tip: ${oCcy.format(detail.tip)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: black))
                                  : SizedBox(),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Tại: ',
                      style: TextStyle(color: black),
                      children: [
                        TextSpan(
                            text: '${detail.locationWork.formattedAddress}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                ),
                SizedBox(
                  height: 5,
                ),

                Align(alignment: Alignment.centerRight,
                  child: RaisedButton(
                      child: Text(
                        'Xem chi tiết',
                        style: TextStyle(color: white),
                      ),
                      color: green,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => DetailAccept(
                              serviceModel: serviceModel,
                              detailPutService: detail,
                              idPartner: widget.idPartner,
                            )));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetForService3(ModelService3 modelService3){
    return Container(
      child: Column(
        children: <Widget>[
          Text('Nấu gồm:', style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 5,
          ),
          Text(
            '${modelService3.numberFood} món',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: green),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Cho ${modelService3.numberPersonEat} người ăn', style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: black)),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
