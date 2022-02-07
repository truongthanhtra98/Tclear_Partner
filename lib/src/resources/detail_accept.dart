import 'package:flutter/material.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_1.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_3.dart';
import 'package:tclearpartner/src/model/calendar_model.dart';
import 'package:tclearpartner/src/model/history_model.dart';
import 'package:tclearpartner/src/model/service_model.dart';
import 'package:tclearpartner/src/resources/viewing_distance.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/data_support.dart';
import 'package:tclearpartner/src/utils/get_image_storage.dart';
import 'package:tclearpartner/src/utils/image.dart';
import 'package:tclearpartner/src/utils/strings.dart';

class DetailAccept extends StatefulWidget {
  final DetailPutService detailPutService;
  final ServiceModel serviceModel;
  final String idPartner;

  DetailAccept({this.serviceModel, this.detailPutService, this.idPartner});

  @override
  _DetailAcceptState createState() => _DetailAcceptState();
}

class _DetailAcceptState extends State<DetailAccept> {
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chiTietCongviec),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: white,
                          child: Image.asset(
                            widget.serviceModel.imageService,
                            color: green,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                            '${widget.serviceModel.nameService.toUpperCase()}',
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Bắt đầu lúc: ',
                        style: TextStyle(color: black),
                        children: [
                          TextSpan(
                              text: '${widget.detailPutService.startTime}',
                              style: TextStyle(
                                  color: green,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                  SizedBox(
                    height: 5,
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
                            child: widget.detailPutService is ModelService3 ? _widgetForService3(widget.detailPutService) :Column(
                              children: <Widget>[
                                Text('Làm trong:', style: TextStyle(fontSize: 14)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${widget.detailPutService.weightWork.thoiGian}h',
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
                                          widget.detailPutService.weightWork.soNguoiLam !=
                                              null &&
                                              widget.detailPutService.weightWork
                                                  .soNguoiLam !=
                                                  1
                                              ? TextSpan(
                                              text:
                                              '${widget.detailPutService.weightWork.soNguoiLam} người làm ')
                                              : TextSpan(),
                                          widget.detailPutService.weightWork.soPhong != null
                                              ? TextSpan(
                                              text:
                                              '${widget.detailPutService.weightWork.soPhong} hoặc ')
                                              : TextSpan(),
                                          widget.detailPutService.weightWork.dienTich != null
                                              ? TextSpan(
                                              text:
                                              '${widget.detailPutService.weightWork.dienTich}')
                                              : TextSpan(),
                                        ])),
                              ],
                            )),
                        VerticalDivider(),
                        Expanded(
                            child: Column(
                              children: <Widget>[
                                Text('Số tiền (VND):',
                                    style: TextStyle(fontSize: 14)),SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${oCcy.format(widget.detailPutService.paymentMethod.money)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: green)),SizedBox(
                                  height: 5,
                                ),
                                widget.detailPutService.tip != null ?Text(
                                    'Tip: ${oCcy.format(widget.detailPutService.tip)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: black)) : SizedBox(),
                              ],
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '- Hình thức thanh toán: ',
                        style: TextStyle(color: black),
                        children: [
                          TextSpan(
                              text:
                              '${widget.detailPutService.paymentMethod.method}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                  ),

                  widget.detailPutService is ModelService1 ?
                  _themDichVu(widget.detailPutService)
                      : SizedBox(),
                  widget.detailPutService is ModelService3 ?
                  _widgetAddForService3(widget.detailPutService)
                      : SizedBox(),

                  SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '- Tại: ',
                        style: TextStyle(color: black),
                        children: [
                          TextSpan(
                              text:
                              '${widget.detailPutService.locationWork.formattedAddress}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '- Số nhà/Căn hộ: ',
                        style: TextStyle(color: black),
                        children: [
                          TextSpan(
                              text:
                              '${widget.detailPutService.apartment.apartmentNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                  ),
                  SizedBox(height: 15,),
                  RichText(
                    text: TextSpan(
                        text: '- Loại nhà: ',
                        style: TextStyle(color: black),
                        children: [
                          TextSpan(
                              text:
                              '${widget.detailPutService.apartment.typeHome}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  widget.detailPutService is ModelService1
                      ? _dongvat(widget.detailPutService)
                      : SizedBox(),
                  //widget set note
                  widget.detailPutService.note != null ?
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.edit, color: green, size: 15,),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Ghi chú: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Expanded(
                        child: Text(
                            '${widget.detailPutService.note}'),
                      ),
                    ],
                  ) : SizedBox(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                        elevation: 10,
                        child: Text(
                          'Xem khoảng cách',
                          style: TextStyle(color: white),
                        ),
                        color: green,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ViewDistance(
                                  widget.detailPutService.locationWork)));
                        }),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Thông tin khách hàng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.account_circle, color: green, size: 20,),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(flex: 2,
                          child: Text('Tên liên hệ ', style: TextStyle(fontWeight: FontWeight.bold),)),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                            '${widget.detailPutService.contactUser.name}'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.email, color: green, size: 20,),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(flex: 2,
                          child: Text('Email ', style: TextStyle(fontWeight: FontWeight.bold),)),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                            '${widget.detailPutService.contactUser.email}'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.phone_android, color: green, size: 20,),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(flex: 2,
                          child: Text('Số điện thoại ', style: TextStyle(fontWeight: FontWeight.bold),)),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                            '${widget.detailPutService.contactUser.phone}'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _widgetPersonJob()
                ],
              ),
            ),
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                          color: grey,
                          child: FlatButton(
                            onPressed: onClickHuyCongViec,
                            child: Center(
                              child: Text(
                                    'HỦY CÔNG VIỆC',
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ))),
                  Expanded(
                      child: Container(
                          color: green,
                          child: FlatButton(
                            onPressed: onClickHoanThanh,
                            child: Center(
                              child: Text(
                                    'ĐÃ HOÀN THÀNH',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _themDichVu(ModelService1 modelService1) {
    return (modelService1.cooking || modelService1.iron || modelService1.mop) ?
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
              text: '- Dịch vụ thêm: ',
              style: TextStyle(color: black),
              children: [
                TextSpan(
                    text: modelService1.cooking ? 'Nấu ăn, ' : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: modelService1.iron ? 'Ủi đồ, ' : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: modelService1.mop ? 'Mang dụng cụ ' : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ))
              ]),
        ),
      ],
    ) : SizedBox();
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
              color: Colors.black)),
        ],
      ),
    );
  }

  Widget _widgetAddForService3(ModelService3 modelService3) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text('- Khẩu vị: '),
              Expanded(
                child: Text(
                  'Miền ${modelService3.taste}', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          RichText(
              text: TextSpan(
                  text: '- Trái cây: ',
                  style: TextStyle(color: black),
                  children: [
                    TextSpan(
                      text: modelService3.hasFruit ? 'Có' : 'Không',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ])),
          SizedBox(
            height: 15,
          ),
          RichText(
              text: TextSpan(
                  text: '- Đi chợ: ',
                  style: TextStyle(color: black),
                  children: [
                    TextSpan(
                      text: modelService3.goMarket ? 'Có' : 'Không', style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ])),
        ],
      ),
    );
  }

  Widget _widgetPersonJob(){
    // tuwf cais id detail lay ds idPartner ra, rooif moiws locj ra vay aw
    return FutureBuilder(
      future: GetStore.getListIdPartnerOfJob(widget.detailPutService.idDetail),
        builder: (context, dataIdPartner){
        switch (dataIdPartner.connectionState){
          case ConnectionState.waiting:
            return SizedBox();
          default:
            List listIdPartner = dataIdPartner.data;
            listIdPartner.remove(widget.idPartner);
            return _getPerson(listIdPartner);
        }
    });
  }

  Widget _dongvat(ModelService1 modelService1){
    return modelService1.pet != null ? Column(
      children: [
        Row(
          children: [
            Text('- Động vật: '),
            Expanded(
              child: Text(
                '${modelService1.pet}', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),

        SizedBox(height: 15,)
      ],
    ) : SizedBox();
  }

  Widget _getPerson(List listIdPartner){
    if(listIdPartner.length != 0){
      return Column(children: [
        Text('Người cùng bạn thực hiện công việc này', style: TextStyle(color: black, fontWeight: FontWeight.bold),),
        Row(
          children: listIdPartner.map((idPartner){
            return Expanded(
              child: StreamBuilder(
                  stream: store
                      .collection('userpartners')
                      .document(idPartner)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return Container(
                          height: 120,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Expanded(
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: snapshot.data['image'] != null ? GetImageAvtStorage(snapshot.data['image']) : Image.asset(imageAvatar, fit: BoxFit.fill,),
                                      ),
                                    ),
                                    radius: 40,
                                  ),),
                              SizedBox(height: 5,),
                              Text('${snapshot.data['name']}', overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              Text('(SDT: ${snapshot.data['phone']})', overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        );
                    }
                  }),
            );
          }).toList(),
        ),
      ],);
    }else{
      return SizedBox();
    }
  }

  void onClickHuyCongViec(){
    var startTime = formatterHasHour.parse(
        widget.detailPutService.startTime);
    if(!startTime.add(Duration(hours: widget.detailPutService.weightWork.thoiGian)).isBefore(DateTime.now())
    && !startTime.isAfter(DateTime.now())){
      showDialog(context: context,
        child: AlertDialog(
          content: Text('Bạn đang trong thời gian làm, hãy báo cho khách hàng để hủy công việc này'),
          actions: [
            FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Đóng', style: TextStyle(color: black),)),
          ],
        ),
      );
    }else{
      showDialog(context: context, child: AlertDialog(
        content: Text('Bạn thật sự muốn hủy công việc này'),
        actions: [
          FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Đóng', style: TextStyle(color: black),)),
          FlatButton(onPressed: () {

            Calendar.removeCalendar(CalendarModel(
                idPartner: widget.idPartner,
                idDetail:
                widget.detailPutService.idDetail,
                dayWork: formatterYYMMdd.format(startTime)));
            //remove nhan viec
            RemoveStore.removeNhanViec(widget.idPartner,
                widget.detailPutService.idDetail);
            //add history
            AddStore.addHistory(HistoryModel(
                idUser: widget.idPartner,
                idService:
                widget.detailPutService.idDetail,
                idDV: widget.detailPutService.idService,
                money: widget.detailPutService.paymentMethod.money.toString(),
                timeStart: widget.detailPutService.startTime,
                status: 'ĐÃ HỦY',
                reason: 'Không làm nữa'));
            // send notification
            Navigator.of(context).pushNamedAndRemoveUntil('/app', (route) => false);
          }, child: Text('Hủy việc'))
        ],
      ));
      //NotificationStore.sendNotification(, notificationModel)
    }

  }

  void onClickHoanThanh(){
    var startTime = formatterHasHour.parse(
        widget.detailPutService.startTime);
    if(!startTime.add(Duration(hours: widget.detailPutService.weightWork.thoiGian)).isAfter(DateTime.now())){
      //add evalute
      GetStore.getListIdPartnerOfJob(widget.detailPutService.idDetail).then((listIdPartner){
        print('list evaluate ${listIdPartner}');
        AddStore.addEvaluate((widget.detailPutService.idDetail + startTime.toString()), listIdPartner);
        RemoveStore.removeNhanViecWhenFinish(widget.idPartner,
            widget.detailPutService.idDetail, startTime, widget.detailPutService);
      });
      //remove

      showDialog(context: context, child: AlertDialog(
        content: Text('Bạn đã hoàn thành xong công việc.'),
        actions: [
          FlatButton(onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/app', (route) => false), child: Text('Đóng'))
        ],
      ));
      // Navigator.of(context).pop();
    }else{

      showDialog(context: context,
          barrierDismissible: false,
          child: AlertDialog(
            content: Text('Thời gian làm việc hiện tại chưa hết'),
            actions: [
              FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Đóng'))
            ],
          ));
    }

  }
}
