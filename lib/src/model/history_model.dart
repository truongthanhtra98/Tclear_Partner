
import 'package:tclearpartner/src/utils/data_support.dart';

class HistoryModel{
  String idUser;
  String idService;
  String idDV;
  String money;
  String reason;
  String status;
  String timeStart;
  String timeCancel;

  HistoryModel({this.idUser, this.idService, this.reason, this.status, this.timeCancel, this.timeStart, this.idDV, this.money});

  Map<String, dynamic> toMap(){
    return {
        'idDetail': idService,
        'idDV': idDV,
        'money': money,
        'reason': reason,
        'status': status,
        'timeStart': timeStart,
        'timecancel': formatterHasHour.format(DateTime.now()).toString(),
    };
  }

  HistoryModel.fromHistory(Map<dynamic, dynamic> map):
      idService = map['idDetail'],
      money = map['money'],
      idDV = map['idDV'],
      reason = map['reason'],
      status = map['status'],
      timeCancel = map['timecancel'],
      timeStart = map['timeStart']
  ;

}