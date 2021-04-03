class EventList {
  final List<Event> events;

  EventList({this.events});

  factory EventList.fromJson(List<dynamic> json) {
    List<Event> events = new List<Event>();
    events = json.map((i) => Event.fromJson(i)).toList();

    return new EventList(events: events);
  }
}

class Event {
  String id;
  String name;
  String location;
  String date;

  Event({this.id, this.name, this.location, this.date});

  factory Event.fromJson(Map<String, dynamic> json) {
    return new Event(
      id: json['id'].toString(),
      name: json['name'],
      location: json['location'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "date": date,
      };
}

class Answers {
  int id;
  String answer1;
  String answer2;
  String answer3;
  String title;
  String description;
  String url;

  Answers({this.id, this.answer1, this.answer2, this.answer3, this.title, this.description, this.url});

  factory Answers.fromJson(Map<String, dynamic> json) {
    return new Answers(
      id: json['id'],
      answer1: json['answer1'],
      answer2: json['answer2'],
      answer3: json['answer3'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}

/*
class Questions {
  int id;
  // String question;
  String title;
  String description;
  String url;

  Questions({this.id,*/
/* this.question,*//*
 this.title, this.description, this.url});

  factory Questions.fromJson(Map<String, dynamic> json) {
    return new Questions(
      id: json['id'],
      // question: json['question'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
*/
