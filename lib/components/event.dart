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



// var e = Event(name: "name", location: "l1", date: DateTime.now());
