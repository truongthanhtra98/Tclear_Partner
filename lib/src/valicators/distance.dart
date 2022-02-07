import 'package:geolocator/geolocator.dart';
import 'package:tclearpartner/src/model/location.dart';

class Distance{

  static Future<bool> nearDistance(Position fromLocation, Location toLocation) async{
    double m = 0;
    bool near = false;
    try{
          await Geolocator().distanceBetween(fromLocation.latitude, fromLocation.longitude, toLocation.lat, toLocation.lng).then((value){
            m = (value/1000).roundToDouble();
            if(m < 60){
              near = true;
            }else{
              near = false;
            }
          });
          print('mmmmmmmmmmm ==== ${m}');
      return near;
    }catch(e){
      print(e);
      return false;
    }
  }
}