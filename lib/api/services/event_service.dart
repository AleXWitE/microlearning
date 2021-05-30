import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:microlearning/api/get_model.dart';
import 'package:microlearning/components/event.dart';

String url = "http://autoinvitro.std-271.ist.mospolytech.ru/api/event/";
String urlQue = "http://autoinvitro.std-271.ist.mospolytech.ru/api/question";

Future<List<Event>> getAllEvents() async { //функция вызова всех элементов джсона
  final response = await http.get(Uri.parse(url),
  headers: {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "GET, HEAD, POST, PUT, UPDATE"
  });
  // print(response.body);
  return allEventsFromJson(response.body);
}

Future<List<Answers>> getAlQuestionsByEvent(String i) async {
  final response = await http.get(Uri.parse('$urlQue/$i'));
  // print(response.body);
  return allQuestionsFromJsonByEvent(response.body);
}

Future<Event> getEvent(String i) async { //вызов определенного элемента джсона по id
  final response = await http.get(Uri.parse('$url$i'));
  return eventFromJson(response.body);
}

Future<http.Response> createEvent(Event event) async{ //добавление элемента в джсон, без хэдеров не заработает, и внимательно следить за урлом, без / не заработает
  final response = await http.post(Uri.parse('$url'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: '',
      },
      body: eventToJson(event)
  );
  return response;
}

Future<http.Response> onDelete(String i) async{ // в теории должен удалять элемент из джсона, но так и не заработал
  final response = await http.delete(Uri.parse('$url$i'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      }
  );
  print(response);
  return response;
}