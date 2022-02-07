import 'package:tclearpartner/src/utils/data_support.dart';

class CheckDayRepeat{
  // repeat. Update ngay gio,
  static String dayRepeatNext(DateTime timeStart, Map<String, dynamic> mapRepeat){
    int weekDayNow = timeStart.weekday;
    List<int> listRepeat = [];
    mapRepeat.forEach((key, value){
      if(value == true){
        String number = key.substring(key.length -1, key.length);
        if(number == 'N'){
          listRepeat.add(7);
        }else{
          int parseNumber = int.parse(number) -1;
          listRepeat.add(parseNumber);
        }
      }
    });
    listRepeat.sort();
    return formatterHasHour.format(setDayRepeat(weekDayNow, listRepeat, timeStart));
  }

  static DateTime setDayRepeat(int weekDayNow, List<int> listRepeat, DateTime timeStart) {
    int numberDayNext = 0;
    if(weekDayNow >= listRepeat[listRepeat.length -1]){
      numberDayNext = (7 -weekDayNow + listRepeat[0]);
    }else{
      for(int i =0; i < listRepeat.length; i++){
        if(weekDayNow < listRepeat[i]){
          numberDayNext = listRepeat[i] - weekDayNow;
          break;
        }
      }
    }
    return (timeStart.add(Duration(days: numberDayNext)));
  }
}