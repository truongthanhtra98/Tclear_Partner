import 'package:flutter/material.dart';
import 'package:tclearpartner/src/model/abtraction_detail_put_service/detail_put_service.dart';
import 'package:tclearpartner/src/model/history_model.dart';
import 'package:tclearpartner/src/model/service_model.dart';
import 'package:tclearpartner/src/utils/colors.dart';

class FormHistory extends StatefulWidget {
  final DetailPutService detailPutService;
  final HistoryModel historyModel;

  FormHistory(this.detailPutService, this.historyModel);
  @override
  _FormHistoryState createState() => _FormHistoryState();
}

class _FormHistoryState extends State<FormHistory> {

  ServiceModel serviceModel;

  @override
  void initState() {
    super.initState();
    if(widget.detailPutService.idService == 'DV01'){
      serviceModel = ServiceModel.s1();
    }else if(widget.detailPutService.idService == 'DV02'){
      serviceModel = ServiceModel.s2();
    }else if(widget.detailPutService.idService == 'DV03') {
      serviceModel = ServiceModel.s3();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFF929292), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: _widgetNameService(),
          ),
          Container(height: 1.0, color: Colors.black26, margin: EdgeInsets.only(bottom: 5.0, top: 2.0),),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            //height: MediaQuery.of(context).size.height,
            child:_lineDetail(),
          ),
        ],
      ),
    );
  }

  Widget _widgetNameService(){
    return Row(
      children: <Widget>[

        Expanded(child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
         mainAxisSize: MainAxisSize.min,
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
            Expanded(child: Text(serviceModel.nameService, style: TextStyle(fontSize: 16.0),)),
          ],
        ),),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${widget.historyModel.status}', style: TextStyle(color: Colors.red, fontSize: 14.0),)
          ],
        ),
      ],
    );
  }

  Widget   _lineDetail(){
    return Column(
      children: <Widget>[
        //dia chi
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("ĐỊA CHỈ", style: TextStyle(color: Color(0xFFBDBDBD),),), flex: 1,),SizedBox(width: 10,),
              Expanded(child: Text('${widget.detailPutService.locationWork.formattedAddress}', style: TextStyle(fontSize: 16),), flex: 2,),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("GIÁ TIỀN", style: TextStyle(color: Color(0xFFBDBDBD),),), flex: 1,),SizedBox(width: 10,),
              Expanded(child: Text('${widget.detailPutService.paymentMethod.money}', style: TextStyle(fontSize: 16),), flex: 2,),
            ],
          ),
        ),
        //so nha
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("VÀO LÚC ", style: TextStyle(color: Color(0xFFBDBDBD),),), flex: 1,),SizedBox(width: 10,),
              Expanded(child: Text('${widget.historyModel.timeCancel.toString()}', style: TextStyle(fontSize: 16)), flex: 2,),
            ],
          ),
        ),
        //loai nha
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("LÝ DO ", style: TextStyle(color: Color(0xFFBDBDBD),),), flex: 1,),SizedBox(width: 10,),
              Expanded(child: Text('${widget.historyModel.reason}', style: TextStyle(fontSize: 16)), flex: 2,),
            ],
          ),
        ),

      ],
    );
  }

}
