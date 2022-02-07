import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password/password.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/model_service_1.dart';
import 'package:tclearpartner/src/model/calendar_model.dart';
import 'package:tclearpartner/src/model/history_model.dart';
import 'package:tclearpartner/src/model/notification_model.dart';
import 'package:tclearpartner/src/model/user_model.dart';
import 'package:tclearpartner/src/utils/data_support.dart';
import 'package:tclearpartner/src/valicators/check_day_repeat.dart';

//get, add remove, check, inforuser, calendar, notifi

class GetStore {
  static void getJob() {
    List<Map> list = [];
    store.collection('dangvieclam').getDocuments().then((value) {
      List listJob = value.documents;
      listJob.forEach((data) {
        String idCustomer = data.documentID;
        List listdv = data.data['list_work'];
        listdv.forEach((value) {
          if (value['idPartner'] == null) {
            list.add({'$idCustomer': value['idDetail']});
          }
        });
      });
    });
  }

  static Future<List<String>> getListIdPartnerOfJob(String idDetail) async {
    List<String> listId = [];
    try {
      await store
          .collection('nhanviec')
          .where('list_work', arrayContains: idDetail)
          .getDocuments()
          .then((data) {
        List listData = data.documents;
        listData.forEach((document) {
          DocumentSnapshot documentSnapshot = document;
          listId.add(documentSnapshot.documentID);
        });
      });
      return listId;
    } catch (e) {
      return [];
    }
  }

  static Stream<List> getListNewJob(){
    //get het dang viec lam
    return store.collection('dangvieclam').snapshots().map((event){
      print('abc  ${event.documents.length}');
      List<DocumentSnapshot> list = event.documents;
      List<Map> listIdAll = [];
      list.forEach((document) {
        String idCustomer = document.documentID;
        List listId = document['list_work'];
        if(listId != null && listId != []){
          listId.forEach((idDetail){
            DetailPutService detailPutService;
            store.collection('chitietcongviec')
                .document(idDetail).get().then((value){
              //print('a ${value.data} ');
              listIdAll.add({idCustomer : detailPutService});
            });
            //print(listIdAll);
          });
        }
      });
      print('mm ${listIdAll}');
      return listIdAll.map((mapValue){

        return store.collection('chitietcongviec')
            .document(mapValue.values.single.toString())
            .snapshots().toString();

      }).toList();
    });
    // loc ra (
  }

}

class AddStore {
  static void takeJob(String idCustomer, String idPartner, String idDetail) {
    store.collection('nhanviec').document(idPartner).setData({
      'list_work': FieldValue.arrayUnion([idDetail])
    }, merge: true).then((_) {
      print('Add nhanviec success');
    }).catchError((err) {
      print(err);
    });
  }

  static void addHistory(HistoryModel historyModel) {
    store.collection('lichsunhanviec').document(historyModel.idUser).setData({
      'list_history': FieldValue.arrayUnion([historyModel.toMap()])
    }, merge: true).then((_) {
      print('Sucess history model');
    }).catchError((err) {
      print(err);
    });
  }

  static Future<double> avgStar(String idPartner) async {
    double countStar = 0;
    try {
      await store
          .collection('danhgia')
          .where('idPartner', arrayContains: idPartner)
          .getDocuments()
          .then((value) {
        value.documents.forEach((result) {
          countStar += result.data['star'];
        });
        countStar = countStar / (value.documents.length);
      });
      return countStar;
    } catch (e) {
      return 0;
    }
  }

  static void addHistoryDangViec(HistoryModel historyModel) {
    store.collection('lichsudangviec').document(historyModel.idUser).setData({
      'list_history': FieldValue.arrayUnion([historyModel.toMap()])
    }, merge: true).then((_) {
      print('Sucess history model');
    }).catchError((err) {
      print(err);
    });
  }

  static void addEvaluate(String idDetail, List listIdPartner){
    store.collection('danhgia').document(idDetail).setData({
      'idPartner' : FieldValue.arrayUnion(listIdPartner),
      'star': 0,
    }).then((value) => print('Add Evaluate success'));
  }
}

class RemoveStore {
  static void removeNhanViec(String idPartner, String idDetail) {
    store.collection('nhanviec').document(idPartner).updateData({
      'list_work': FieldValue.arrayRemove([idDetail]),
    }).then((value) {
      print('Remove success');
      UpdateStore.updateTableDangViecAfterRemove(idPartner, idDetail);
    });
  }

  static void removeNhanViecWhenFinish(String idPartner, String idDetail, DateTime startTime, DetailPutService detailPutService) async{
    await store.collection('nhanviec').document(idPartner).updateData({
      'list_work': FieldValue.arrayRemove([idDetail]),
    }).then((value) {
      print('Remove success');
      removeTableDangViecAfterFinish(idPartner, idDetail, detailPutService, startTime);
      //remove calendar
      Calendar.removeCalendar(CalendarModel(
          idPartner: idPartner,
          idDetail: idDetail,
          dayWork: formatterYYMMdd.format(startTime)));

      // add lisu
      AddStore.addHistory(HistoryModel(
          idUser: idPartner,
          idDV: detailPutService.idService,
          money: detailPutService.paymentMethod.money.toString(),
          idService: idDetail,
          timeStart: detailPutService.startTime,
          status: 'ĐÃ HOÀN THÀNH',
          reason: 'Bạn đã làm xong công việc này'));
    });
  }

  static void removeTableDangViec(String idCustomer, String idDetail) {
    store.collection('dangvieclam').document(idCustomer).updateData({
      'list_work': FieldValue.arrayRemove([idDetail]),
    }).then((value) {
      print('Remove Dang viec finish success');
    });
  }

  static void removeTableDangViecAfterFinish(
      String idPartner, String idDetail, DetailPutService detailPutService, DateTime timeStart) async{
    await store
        .collection('dangvieclam')
        .where('list_work', arrayContains: idDetail)
        .getDocuments()
        .then((snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.documents.first;
      String idCustomer = documentSnapshot.documentID;
      //remove dang viec
      //add lich su dang viec
      CheckStore.addLichSuDangViec(idCustomer, idDetail, detailPutService.startTime, detailPutService.idService, detailPutService.paymentMethod.money.toString());
      //send Notification
      NotificationStore.sendNotification(
          idCustomer,
          NotificationModel('Người làm đã hoàn thành công việc',
              'Công việc đã hoàn thành bạn có thể vào lịch sử để đánh giá người làm'));
      //repeat
      CheckStore.checkRepeat(idCustomer, idDetail).then((value){
        print('have repeat $value $idDetail');
        if(value){
          if(detailPutService is ModelService1){
            ModelService1 modelService1 = detailPutService;
            UpdateStore.updateDetailForRepeat(idDetail, CheckDayRepeat.dayRepeatNext(timeStart, modelService1.mapRepeat));
          }
        }else{
          //remove dang viec
          print('ok remove dang viec');
          RemoveStore.removeTableDangViec(idCustomer, idDetail);
        }
      });
    });
  }
}

class UpdateStore {

  static void updateDetailForRepeat(String idDetail, String dayRepeat){
    print('day repeat  jjj $dayRepeat');
    store.collection('chitietcongviec').document(idDetail).updateData({'thoigianbatdau': dayRepeat}).then((value){
      print('Update repeat success');
    }).catchError((err){
      print(err);
    });
  }

  static void updateTableDangViecAfterRemove(
      String idPartner, String idDetail) {
    store
        .collection('dangvieclam')
        .where('list_work', arrayContains: idDetail)
        .getDocuments()
        .then((snapshot) {
      DocumentSnapshot documentSnapshot = snapshot.documents.first;
      String idCustomer = documentSnapshot.documentID;
      //send Notification
      NotificationStore.sendNotification(
          idCustomer,
          NotificationModel('Người làm hủy công việc',
              'Công Việc đã bị người làm hủy, bạn sẽ nhận đươc người làm khác'));
    });
  }
}

class CheckStore {
  static void addLichSuDangViec(String idCustomer, String idDetail, String timeStart, String idDV, String money) {
    HistoryModel historyModel = HistoryModel(idDV: idDV, money: money,
        idUser: idCustomer, idService: idDetail, status: 'ĐÃ XONG', timeStart: timeStart);
    AddStore.addHistoryDangViec(historyModel);
  }

  static Future<bool> checkWork(String idPartner, String idDetail) async{
    bool exist = false;
    try{
      await store.collection('nhanviec').document(idPartner).get().then((document){
        List list = document.data['list_work'];
        if(list.contains(idDetail)){
          exist = true;
        }else{
          exist = false;
        }
      });
      print(exist);
      return exist;
    }catch(e){
      return false;
    }
  }
  static Future<bool> checkRepeat(String idCustomer, String idDetail) async {
    bool repeat = false;
    try {
      await store.collection('dangvieclam').document(idCustomer).get().then((data) {
        List listRepeat = data.data['list_repeat'];
        print('list repeat   ${listRepeat}');
        if (listRepeat.contains(idDetail)) {
          repeat = true;
        } else {
          repeat = false;
          ;
        }
      });
      return repeat;
    } catch (e) {
      return false;
    }
  }
}

class FirestoreGetInforUser {
  static void addUserNew(String idUser, UserModel user) {
    store
        .collection('userpartners')
        .document(idUser)
        .setData(user.toMap())
        .whenComplete(() {
      print('Document Added');
    }).catchError((e) {
      print(e);
    });
  }

  // check user đã tồn tại chưa
  static Future<bool> checkExist(String phoneNumber, String password) async {
    bool exists = false;
    try {
      await store
          .collection('userpartners')
          .where('phone', isEqualTo: phoneNumber)
          .where('password', isEqualTo: Password.hash(password, algorithm))
          .getDocuments()
          .then((value) {
        if (value.documents.length != 0)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkPhone(String phoneNumber) async {
    bool exists = false;
    try {
      await store
          .collection('userpartners')
          .where("phone", isEqualTo: phoneNumber)
          .getDocuments()
          .then((doc) {
        if (doc.documents.length != 0)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkCMNDExist(String cmnd) async {
    bool exists = false;
    try {
      await store
          .collection('userpartners')
          .where("cmnd", isEqualTo: cmnd)
          .getDocuments()
          .then((doc) {
        if (doc.documents.length != 0)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel> getUserModel() async {
    FirebaseUser user = await auth.currentUser();

    UserModel userModel = new UserModel();
    try {
      await store
          .collection('userpartners')
          .document(user.uid)
          .get()
          .then((value) {
        if (value.exists)
          userModel = UserModel.fromMap(value.data, user.uid);
        else
          userModel = null;
      });
      return userModel;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updatePassword(String idUser, String password) async {
    bool updateDone = false;
    try {
      await store
          .collection('userpartners')
          .document(idUser)
          .updateData({'password': Password.hash(password, algorithm)}).then((value) {
        print('Forgot success');
        updateDone = true;
      });
      return updateDone;
    } catch (e) {
      return false;
    }
  }

  static void updateImageUser(String idUser, String image, String email, String name){
    store.collection('userpartners').document(idUser).updateData({
      'image' : image,
      'email': email,
      'name' : name
    }).then((value) => print('Update avt success')).catchError((err) => print(err));
  }
}

class Calendar {
  static void addCalendar(CalendarModel calendarModel) {
    store.collection('lichlamviec').document(calendarModel.idPartner).setData({
      '${calendarModel.dayWork}':
      FieldValue.arrayUnion([calendarModel.idDetail])
    }, merge: true).then((value) {
      print("Add calendar access");
    }).catchError((err) => print(err));
  }

  static void removeCalendar(CalendarModel calendarModel) {
    store
        .collection('lichlamviec')
        .document(calendarModel.idPartner)
        .updateData({
      '${calendarModel.dayWork}':
      FieldValue.arrayRemove([calendarModel.idDetail]),
    }).then((value) {
      print('Remove Calendar success');
    });
  }

  static Future<bool> checkTime(List listIdDetail, DateTime timeStartCheck, DateTime timeEndCheck) async{
    bool timeSame = false;
    for(var idDetail in listIdDetail){
      try{
        await store.collection('chitietcongviec').document(idDetail).get().then((value){
          //DocumentSnapshot documentSnapshot = value;
          String timeStart = value.data['thoigianbatdau'];
          var startTime = formatterHasHour.parse(timeStart);
          var endTime = startTime.add(Duration(hours: value.data['weightWork']['thoigianlam']));
          //check time
          if((timeStartCheck.isAfter(startTime) && timeStartCheck.isBefore(endTime))
              ||(timeEndCheck.isAfter(startTime) && timeEndCheck.isBefore(endTime))){
            timeSame = true;
          }else{
            timeSame = false;
          }
          print('time1111111 ${timeSame}');
        });
        print('time111111122222 ${timeSame}');
        //time same true
        if(timeSame){
          break;
        }
      }catch(err){
        return false;
      }
    }// end

    return timeSame;
  }

  static Future<List> getListCalendarOfDay(String idPartner, String dayWork,) async{
    List listIdDetail = [];
    try{
      await store.collection('lichlamviec').document(idPartner).get().then((value){
        if(value.data[dayWork] != null){
          listIdDetail = value.data[dayWork];
        }else{
          listIdDetail = [];
        }

      });
      return listIdDetail;
    }catch(err){
      return [];
    }
  }

  static Future<bool> checkCalendar(String idPartner, String dayWork, DateTime timeStartCheck, DateTime timeEndCheck) async{
    bool timeSame = false;
    try{
      await store.collection('lichlamviec').document(idPartner).get().then((value){
        List listIdDetail = value.data[dayWork];
        //start for list
        for(var idDetail in listIdDetail){
          store.collection('chitietcongviec').document(idDetail).get().then((value){
            //DocumentSnapshot documentSnapshot = value;
            String timeStart = value.data['thoigianbatdau'];
            var startTime = formatterHasHour.parse(timeStart);
            var endTime = startTime.add(Duration(hours: value.data['weightWork']['thoigianlam']));
            //check time
            if((timeStartCheck.isAfter(startTime) && timeStartCheck.isBefore(endTime))
                ||(timeEndCheck.isAfter(startTime) && timeEndCheck.isBefore(endTime))){
              timeSame = true;
            }else{
              timeSame = false;
            }
          });
          //time same true
          if(timeSame){
            break;
          }
        }// end for
      });
      return timeSame;
    }catch(err){
      return false;
    }
  }
}

class NotificationStore {
  static void sendNotification(
      String idCustomer, NotificationModel notificationModel) {
    store.collection('thongbao').document(idCustomer).setData({
      'list_notification': FieldValue.arrayUnion([notificationModel.toMap()])
    }, merge: true).then((value) {
      print("Add notification access");
    }).catchError((err) => print(err));
  }

  static void deleteNotification(String idUser, Map mapNotification){
    store.collection('thongbaopartner').document(idUser).updateData({
      'list_notification' : FieldValue.arrayRemove([mapNotification])
    }).then((value) {
      print('Remove notification success');
    }).catchError((err){
      print(err);
    });
  }
}
