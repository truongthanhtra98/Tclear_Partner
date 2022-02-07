import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_1.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_2.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_3.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_4.dart';
import 'package:tclearpartner/src/model/service_model.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/resources/detail_job.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/data_support.dart';
import 'package:tclearpartner/src/valicators/distance.dart';

class NewJob extends StatefulWidget {
  final String idCustomer;
  final String idDetail;
  final UserModel partner;
  Position currentPosition;
  NewJob(this.idCustomer, this.partner, this.idDetail, this.currentPosition);

  @override
  _NewJobState createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> with AutomaticKeepAliveClientMixin {
  DetailPutService detail;

  @override
  Widget build(BuildContext context) {
    var storeDetail = store
        .collection('chitietcongviec')
        .document(this.widget.idDetail)
        .snapshots();
    return StreamBuilder(
        stream: storeDetail,
        builder: (context, snapshotDetail) {
          if (snapshotDetail.hasData) {
            String id = snapshotDetail.data['id'];
            String startTime = snapshotDetail.data['thoigianbatdau'];
            var timeStart = formatterHasHour.parse(startTime);

            if (id == 'DV01') {
              detail = ModelService1().fromAsyncSnapshot(snapshotDetail);
            } else if (id == 'DV02') {
              detail = ModelService2().fromAsyncSnapshot(snapshotDetail);
            } else if (id == 'DV03') {
              detail = ModelService3().fromAsyncSnapshot(snapshotDetail);
            } else if (id == 'DV04') {
              detail = ModelService4().fromAsyncSnapshot(snapshotDetail);
            }
            return snapshotDetail.data == null ||
                    timeStart.isBefore(DateTime.now())
                ? SizedBox()
                : FutureBuilder<bool>(
                    future: Distance.nearDistance(
                        widget.currentPosition, detail.locationWork),
                    builder: (context, nearDistance) {
                      switch (nearDistance.connectionState) {
                        case ConnectionState.waiting:
                          return SizedBox();
                        case ConnectionState.done:
                          return nearDistance.data
                              ? FutureBuilder(
                                  future: GetStore.getListIdPartnerOfJob(
                                      detail.idDetail),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return SizedBox();
                                      case ConnectionState.done:
                                        return _cardFormDetail(
                                            snapshot.data, context);
                                      default:
                                        return SizedBox();
                                    }
                                  })
                              : SizedBox();
                        default:
                          return SizedBox();
                      }
                    });
          } else {
            return SizedBox();
          }
        });
  }

  Widget _cardFormDetail(List listPartner, BuildContext context) {
    ServiceModel serviceModel;

    if (detail.idService == 'DV01') {
      serviceModel = ServiceModel.s1();
      if (listPartner.length < 1) {
        return _content(serviceModel, context);
      } else {
        return SizedBox();
      }
    } else if (detail.idService == 'DV02') {
      serviceModel = ServiceModel.s2();
      if (listPartner.length < detail.weightWork.soNguoiLam) {
        return FutureBuilder(
            future: CheckStore.checkWork(widget.partner.id, detail.idDetail),
            builder: (context, exist) {
              switch (exist.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox();
                default:
                  if (!exist.data) {
                    return _content(serviceModel, context);
                  } else {
                    return SizedBox();
                  }
              }
            });
      } else {
        return SizedBox();
      }
    } else if (detail.idService == 'DV03') {
      serviceModel = ServiceModel.s3();
      if (listPartner.length < 1) {
        return _content(serviceModel, context);
      } else {
        return SizedBox();
      }
    }
    return SizedBox();
  }

  bool click = false;
  Widget _content(ServiceModel serviceModel, BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        child: FlatButton(
          highlightColor: Colors.white30,
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DetailJob(
                      widget.idCustomer,
                      serviceModel: serviceModel,
                      detailPutService: detail,
                      partner: widget.partner,
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
                    Expanded(
                        child: Text(
                      '${serviceModel.nameService.toUpperCase()}',
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )),
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
                          child: detail is ModelService3
                              ? _widgetForService3(detail)
                              : Column(
                                  children: <Widget>[
                                    Text('Làm trong:',
                                        style: TextStyle(fontSize: 14)),
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
                                          detail.weightWork.soNguoiLam !=
                                                      null &&
                                                  detail.weightWork
                                                          .soNguoiLam !=
                                                      1
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
                                                  text:
                                                      '${detail.weightWork.dienTich}')
                                              : TextSpan(),
                                        ])),
                                  ],
                                )),
                      VerticalDivider(
                        width: 1,
                        color: green,
                      ),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text('Số tiền (VND): ',
                              style: TextStyle(fontSize: 14)),
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
                            builder: (_) => DetailJob(
                                  widget.idCustomer,
                                  serviceModel: serviceModel,
                                  detailPutService: detail,
                                  partner: widget.partner,
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

  Widget _widgetForService3(ModelService3 modelService3) {
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
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Cho ${modelService3.numberPersonEat} người ăn',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
