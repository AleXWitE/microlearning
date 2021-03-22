import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:microlearning/api/get_model.dart';
import 'package:microlearning/components/event.dart';

String url = 'http://autoinvitro.std-271.ist.mospolytech.ru/api/event/';

Future<List<Event>> getAllEvents() async {
  final response = await http.get('$url');
  // print(response.body);
  return allEventsFromJson(response.body);
}

Future<Event> getEvent(String i) async {
  final response = await http.get('$url/$i');
  return eventFromJson(response.body);
}

Future<http.Response> createEvent(Event event) async{
  final response = await http.post('$url',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader : ''
      },
      body: eventToJson(event)
  );
  return response;
}