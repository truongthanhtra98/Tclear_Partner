import 'package:flutter/material.dart';
import 'package:tclearpartner/src/model/apartment_model.dart';
import 'package:tclearpartner/src/model/items_dropdownlist.dart';
import 'package:tclearpartner/src/model/location.dart';
import 'package:tclearpartner/src/model/payment_method.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/utils/data_support.dart';

abstract class DetailPutService{
  String idService;
  String idDetail;
  Location locationWork;
  ApartmentModel apartment;
  DateTime day;
  String startTime;
  String putByTime;
  String hour;
  String note;
  Item weightWork;
  //double money;
  PaymentMethod paymentMethod;
  UserModel contactUser;
  int tip;
  Map<String, dynamic> toMap();

  Map<String, dynamic> toMapAbstract(){
    return {
      'location':{
        'diachi': locationWork.formattedAddress,
        'lat' : locationWork.lat,
        'lng': locationWork.lng,
      },
      'thoigianbatdau': '${hour}, ${formatter.format(day).toString()}',
      //'ngaylam': formatter.format(day).toString(),
      //'giolam': hour,
      'apartment': {
        'loainha': apartment.typeHome,
        'sonha': apartment.apartmentNumber,
      },
      'ghichu': note,
      'thoigiandang': formatterHasHour.format(DateTime.now()).toString(),
      'money': paymentMethod.money.toString(),
      'method': paymentMethod.method,
      'thongtinlienhe': contactUser.toMapContact()
    };
  }

  DetailPutService fromAsyncSnapshot(AsyncSnapshot snapshot);

  DetailPutService fromMap(Map map);

}