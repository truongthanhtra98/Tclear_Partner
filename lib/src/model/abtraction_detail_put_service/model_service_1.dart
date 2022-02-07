import 'package:flutter/material.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/apartment_model.dart';
import 'package:tclearpartner/src/model/items_dropdownlist.dart';
import 'package:tclearpartner/src/model/location.dart';
import 'package:tclearpartner/src/model/payment_method.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/utils/data_support.dart';

class ModelService1 extends DetailPutService{

  bool cooking;
  bool iron;
  bool mop;
  String pet;
  bool repeat;
  Map<String, dynamic> mapRepeat;

  ModelService1(){
    this.cooking = false;
    this.iron = false;
    this.mop = false;
    this.repeat = false;
    this.mapRepeat = {'CN' : false, 'T2': false, 'T3': false, 'T4': false, 'T5': false, 'T6': false, 'T7': false};
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> mapChild = {
      'id': 'DV01',
      'weightWork':{
        'thoigianlam': weightWork.thoiGian,
        'dientich': weightWork.dienTich,
        'sophong':weightWork.soPhong,
      },
      'cooking': cooking,
      'iron': iron,
      'mop': mop,
      'pet': pet,
      'repeat': repeat,
      'ngaylaplai': mapRepeat,
    };
    Map<String, dynamic> mapFinal = {};
    mapFinal.addAll(toMapAbstract());
    mapFinal.addAll(mapChild);
    return mapFinal;
  }

  @override
  DetailPutService fromAsyncSnapshot(AsyncSnapshot snapshot) {
    ModelService1 model = new ModelService1();
    model.idService = snapshot.data['id'];
    model.idDetail = snapshot.data.documentID;
    model.locationWork = new Location(formattedAddress:snapshot.data['location']['diachi'], lat: snapshot.data['location']['lat'], lng: snapshot.data['location']['lng']);
    model.apartment = new ApartmentModel(apartmentNumber:  snapshot.data['apartment']['sonha'], typeHome:snapshot.data['apartment']['loainha']);
    model.startTime = snapshot.data['thoigianbatdau'];
    model.putByTime = snapshot.data['thoigiandang'];
    model.note = snapshot.data['ghichu'];
    model.paymentMethod = PaymentMethod('0', snapshot.data['method'], money: double.parse(snapshot.data['money']));
    model.tip = snapshot.data['tip'];
    model.contactUser = UserModel(name: snapshot.data['thongtinlienhe']['name'], phone: snapshot.data['thongtinlienhe']['phone'], email: snapshot.data['thongtinlienhe']['email']);
    //model service1
    model.weightWork = Item(snapshot.data['weightWork']['thoigianlam'], dienTich: snapshot.data['weightWork']['dientich'], soPhong: snapshot.data['weightWork']['sophong'], soNguoiLam: snapshot.data['weightWork']['songuoilam']);
    model.cooking = snapshot.data['cooking'];
    model.mop = snapshot.data['mop'];
    model.iron = snapshot.data['iron'];
    model.pet = snapshot.data['pet'];
    model.mapRepeat = snapshot.data['ngaylaplai'];
    //model.repeat = snapshot.data['repeat'];
    return model;
  }

  @override
  DetailPutService fromMap(Map map) {
    ModelService1 model = new ModelService1();
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
    //model service1
    model.weightWork = Item(map['weightWork']['thoigianlam'], dienTich: map['weightWork']['dientich'], soPhong: map['weightWork']['sophong'], soNguoiLam: map['weightWork']['songuoilam']);
    model.cooking = map['cooking'];
    model.mop = map['mop'];
    model.iron = map['iron'];
    model.pet = map['pet'];
    model.mapRepeat = map['ngaylaplai'];
    //model.repeat = snapshot.data['repeat'];
    return model;
  }

}