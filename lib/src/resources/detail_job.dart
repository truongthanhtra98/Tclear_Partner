import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_1.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_3.dart';
import 'package:tclearpartner/src/model/calendar_model.dart';
import 'package:tclearpartner/src/model/notification_model.dart';
import 'package:tclearpartner/src/model/service_model.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/resources/viewing_distance.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/data_support.dart';
import 'package:tclearpartner/src/utils/strings.dart';

class DetailJob extends StatefulWidget {
  final DetailPutService detailPutService;
  final ServiceModel serviceModel;
  final UserModel partner;
  final String idCustomer;

  DetailJob(this.idCustomer,
      {this.serviceModel, this.detailPutService, this.partner});

  @override
  _DetailJobState createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
  bool checkedValue = false;
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.5,
      inAsyncCall: _isInAsyncCall,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(chiTietCongviec),
        ),
        body: Container(
          color: white,
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
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Bắt đầu lúc: ',
                          style: TextStyle(color: black),
                          children: [
                            TextSpan(
                                text: '${widget.detailPutService.startTime}',
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
                              child: widget.detailPutService is ModelService3
                                  ? _widgetForService3(widget.detailPutService)
                                  : Column(
                                      children: <Widget>[
                                        Text('Làm trong:',
                                            style: TextStyle(fontSize: 14)),
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
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${oCcy.format(widget.detailPutService.paymentMethod.money)}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: green)),
                              SizedBox(
                                height: 5,
                              ),
                              widget.detailPutService.tip != null
                                  ? Text(
                                      'Tip: ${oCcy.format(widget.detailPutService.tip)}',
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


                    widget.detailPutService is ModelService1
                        ? _themDichVu(widget.detailPutService)
                        : SizedBox(),

                    widget.detailPutService is ModelService3
                        ? _widgetAddForService3(widget.detailPutService)
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
                                    '${widget.detailPutService.locationWork.formattedAddress}.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
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
                    SizedBox(
                      height: 15,
                    ),
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
                                )),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    widget.detailPutService is ModelService1
                        ? _dongvat(widget.detailPutService)
                        : SizedBox(),

                    //widget set note
                    (widget.detailPutService.note != null &&
                            widget.detailPutService.note != '')
                        ? Row(
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
                        )
                        : SizedBox(),
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
                      height: 15,
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
                      height: 15,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: GestureDetector(
                            child: checkedValue
                                ? Icon(
                                    Icons.check_box,
                                    color: green,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: black,
                                  ),
                            //alignment: Alignment.center,
                            //padding: EdgeInsets.all(0),
                            onTap: () {
                              setState(() {
                                checkedValue = !checkedValue;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Bạn đã đọc kỹ thông tin và muốn nhận việc?",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
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
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Text(
                                  'BỎ QUA',
                                  style: TextStyle(
                                      color: white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))),
                    Expanded(
                        child: Container(
                            color: checkedValue ? green : Colors.black12,
                            child: FlatButton(
                              onPressed: !checkedValue
                                  ? null
                                  : () {
                                setState(() {
                                  _isInAsyncCall = true;
                                });
                                      bool checkJob = false;
                                      //check xem có người nhận việc chưa nè
                                      GetStore.getListIdPartnerOfJob(
                                              widget.detailPutService.idDetail)
                                          .then((valueListIdPartner) {
                                        List listIdPartner = valueListIdPartner;
                                        //kiểm tra theo dịch vụ
                                        if (widget.detailPutService.weightWork !=
                                                null &&
                                            widget.detailPutService.weightWork
                                                    .soNguoiLam !=
                                                null) {
                                          if (listIdPartner.length <
                                              widget.detailPutService.weightWork
                                                  .soNguoiLam) {
                                            checkJob = true;
                                          } else {
                                            checkJob = false;
                                          }
                                        } else {
                                          if (listIdPartner.length < 1) {
                                            checkJob = true;
                                          } else {
                                            checkJob = false;
                                          }
                                        } // end check theo dich vụ
                                        //kiem tra true false
                                        if (checkJob) {
                                          //cover time
                                          var startTime = formatterHasHour.parse(
                                              widget.detailPutService.startTime);

                                          //check test
                                          Calendar.getListCalendarOfDay(
                                                  widget.partner.id,
                                                  formatterYYMMdd.format(startTime))
                                              .then((value) {
                                            List listIdDetail = value;
                                            Calendar.checkTime(
                                                    listIdDetail,
                                                    startTime,
                                                    startTime.add(Duration(
                                                        hours: widget
                                                            .detailPutService
                                                            .weightWork
                                                            .thoiGian)))
                                                .then((value) {
                                              if (value) {
                                                Future.delayed(Duration(seconds: 2), (){
                                                  setState(() {
                                                    _isInAsyncCall = false;
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      child: AlertDialog(
                                                        content: Text(
                                                            'Công việc này trùng lịch với công việc khác'),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                    context)
                                                                    .popAndPushNamed(
                                                                    '/app');
                                                              },
                                                              child:
                                                              Text('Việc khác'))
                                                        ],
                                                      ));
                                                });
                                              } else {
                                                AddStore.takeJob(
                                                    widget.idCustomer,
                                                    widget.partner.id,
                                                    widget.detailPutService
                                                        .idDetail);
                                                //add calendar
                                                Calendar.addCalendar(
                                                    CalendarModel(
                                                        idPartner:
                                                            widget.partner.id,
                                                        idDetail: widget
                                                            .detailPutService
                                                            .idDetail,
                                                        dayWork: formatterYYMMdd
                                                            .format(startTime)));
                                                //send notification for customer
                                                NotificationStore.sendNotification(
                                                    widget.idCustomer,
                                                    NotificationModel(
                                                        'Đã có người nhận việc',
                                                        '${widget.serviceModel.nameService} - ${widget.partner.name} đã nhận công việc này'));
                                                // end store
                                                Future.delayed(Duration(seconds: 2), (){
                                                  setState(() {
                                                    _isInAsyncCall = false;
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      child: AlertDialog(
                                                        content: Text(
                                                            'Bạn nhận công việc thành công'),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                    context)
                                                                    .pushNamedAndRemoveUntil(
                                                                    '/app',
                                                                        (route) =>
                                                                    false);
                                                              },
                                                              child:
                                                              Text('Tiếp tục'))
                                                        ],
                                                      ));
                                                });

                                              }
                                            });
                                          });
                                          //end check test

                                        } else {
                                          Future.delayed(Duration(seconds: 2), (){
                                            setState(() {
                                              _isInAsyncCall = false;
                                            });
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                child: AlertDialog(
                                                  content: Text(
                                                      'Công việc đã đủ người, bạn hãy chọn công việc khác'),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .popAndPushNamed(
                                                              '/app');
                                                        },
                                                        child: Text('Tiếp tục'))
                                                  ],
                                                ));
                                          });
                                        }
                                      });
                                    },
                              child: Center(
                                child: Text(
                                  'NHẬN VIỆC',
                                  style: TextStyle(
                                      color: checkedValue
                                          ? white
                                          : Colors.black26,
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
      ),
    );
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
                fontSize: 18, fontWeight: FontWeight.bold, color: green),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Cho ${modelService3.numberPersonEat} người ăn',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: black)),
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
}
