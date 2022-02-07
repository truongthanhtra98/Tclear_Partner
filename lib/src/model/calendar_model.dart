import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';

class CalendarModel{
  String idPartner;
  String dayWork;
  String idDetail;

  CalendarModel({this.idDetail, this.idPartner, this.dayWork});

  Map<String, dynamic> toMap(){
    return {

    };
  }

}