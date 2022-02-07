import 'package:tclearpartner/src/utils/data_support.dart';

class NotificationModel{
  String topic;
  String content;
  String time;

  NotificationModel(this.topic, this.content, {this.time});

  Map<String, dynamic> toMap(){
    return {
        'topic': topic,
      'content': content,
      'time': formatterHasHour.format(DateTime.now()).toString(),
    };
  }

  NotificationModel.fromMap(Map map):
      topic = map['topic'],
      content = map['content'],
      time = map['time']
      ;
}