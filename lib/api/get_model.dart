import 'dart:convert';

import 'package:microlearning/components/event.dart';
import 'package:microlearning/db/moor_db.dart';

Event eventFromJson(String str) { //возвращаем элемент джсона элементом списка
  final jsonData = jsonDecode(str);
  return Event.fromJson(jsonData);
}

String eventToJson(Event data) { //добавляем элемент списка в элемент джсона
  final dyn = data.toJson();
  return json.encode(dyn);
}

List<Event> allEventsFromJson(String str) {//возвращаем элементы джсона с помощью карты в элементы списка
  final List jsonData = jsonDecode(str);
  return new List<Event>.from(jsonData.map((i) => Event.fromJson(i)));
}

List<Answers> allQuestionsFromJsonByEvent(String str) {
  final List jsonData = jsonDecode(str);
  return new List<Answers>.from(jsonData.map((i) => Answers.fromJson(i)));
}

// String allEventsToJson(List<Event> data) {
//   final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
//   return json.encode(dyn);
// }