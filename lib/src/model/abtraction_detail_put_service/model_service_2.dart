import 'package:flutter/material.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/apartment_model.dart';
import 'package:tclearpartner/src/model/items_dropdownlist.dart';
import 'package:tclearpartner/src/model/location.dart';
import 'package:tclearpartner/src/model/payment_method.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/utils/data_support.dart';
class ModelService2 extends DetailPutService{


  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapChild = {
      'id': 'DV02',
      'weightWork':{
        'thoigianlam': weightWork.thoiGian,
        'dientich': weightWork.dienTich,
        'sophong':weightWork.soPhong,
      },
    };
    Map<String, dynamic> mapFinal = {};
    mapFinal.addAll(toMapAbstract());
    mapFinal.addAll(mapChild);
    return mapFinal;
  }


  @override
  DetailPutService fromAsyncSnapshot(AsyncSnapshot snapshot) {
    ModelService2 model = new ModelService2();
    model.idService = snapshot.data['id'];
    model.idDetail = snapshot.data.documentID;
    model.locationWork = new Location(formattedAddress: snapshot.data['location']['diachi'], lat: snapshot.data['location']['lat'], lng: snapshot.data['location']['lng']);
    model.apartment = new ApartmentModel(apartmentNumber:  snapshot.data['apartment']['sonha'], typeHome:snapshot.data['apartment']['loainha']);
    model.weightWork = Item(snapshot.data['weightWork']['thoigianlam'], dienTich: snapshot.data['weightWork']['dientich'], soNguoiLam: snapshot.data['weightWork']['songuoilam']);
    model.startTime = snapshot.data['thoigianbatdau'];
    model.note = snapshot.data['ghichu'];
    model.paymentMethod = PaymentMethod('0', snapshot.data['method'], money: double.parse(snapshot.data['money']));
    model.tip = snapshot.data['tip'];
    model.contactUser = UserModel(name: snapshot.data['thongtinlienhe']['name'], phone: snapshot.data['thongtinlienhe']['phone'], email: snapshot.data['thongtinlienhe']['email']);
    return model;
  }

  @override
  DetailPutService fromMap(Map map) {
    ModelService2 model = new ModelService2();
    model.idService = map['id'];
    //model.idDetail = map.documentID;
    model.locationWork = new Location(formattedAddress: map['location']['diachi'], lat: map['location']['lat'], lng: map['location']['lng']);
    model.apartment = new ApartmentModel(apartmentNumber:  map['apartment']['sonha'], typeHome: map['apartment']['loainha']);
    model.startTime = map['thoigianbatdau'];
    model.putByTime = map['thoigiandang'];
    model.note = map['ghichu'];
    model.paymentMethod = PaymentMethod('0', map['method'], money: double.parse(map['money']));
    model.tip = map['tip'];
    model.contactUser = UserModel(name: map['thongtinlienhe']['name'], phone: map['thongtinlienhe']['phone'], email: map['thongtinlienhe']['email']);
    return model;
  }

}