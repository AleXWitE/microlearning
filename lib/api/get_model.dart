import 'dart:convert';

import 'package:microlearning/components/event.dart';

Event eventFromJson(String str) {
  final jsonData = jsonDecode(str);
  return Event.fromJson(jsonData);
}

String eventToJson(Event data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

List<Event> allEventsFromJson(String str) {
  final List jsonData = jsonDecode(str);
  return new List<Event>.from(jsonData.map((i) => Event.fromJson(i)));
}

// String allEventsToJson(List<Event> data) {
//   final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
//   return json.encode(dyn);
// }