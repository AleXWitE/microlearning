class EventList { //модель данных для списка всех событий, состоит из элементов вложенного списка
  final List<Event> events;

  EventList({this.events});

  factory EventList.fromJson(List<dynamic> json) { //при работе с джсон, без фабрики не будет срабатывать подстановка полученных элементов карты с апи
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
  bool favorite = false;

  Event({this.id, this.name, this.location, this.date, this.favorite});

  factory Event.fromJson(Map<String, dynamic> json) { // расшифровка и распределение полученных элементов джсона в элемент списка
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
  String answerCorrect;
  String title;
  String description;
  String url;
  String type;

  Answers({this.id, this.answer1, this.answer2, this.answer3, this.answerCorrect, this.title, this.description, this.url, this.type});

  // factory Answers.fromJson(Map<String, dynamic> json) {
  //   return new Answers(
  //     id: json['id'],
  //     answer1: json['answer1'],
  //     answer2: json['answer2'],
  //     answer3: json['answer3'],
  //     title: json['title'],
  //     description: json['description'],
  //     url: json['url'],
  //     type: json['type'],
  //   );
  // }
}

List<Answers> answers = [ //тестовое добавление вопросов локально, без интернета
  // Answers(
  //     answer1: "answer10",
  //     answer2: "answer11",
  //     answer3: "answer12",
  //     title: "Title 45",
  //     description: "Short description 4",
  //     url: "F4Q6lEhmwCY",
  //     type: "video"),
  // Answers(
  //     answer1: "answer1",
  //     answer2: "answer2",
  //     answer3: "answer3",
  //     title: "Title 1",
  //     description: "Short description 1",
  //     url: "https://picsum.photos/250?image=10",
  //     type: "radio"),
  // Answers(
  //     answer1: "answer4",
  //     answer2: "answer5",
  //     answer3: "answer6",
  //     title: "Title 2",
  //     description: "Short description 2",
  //     url: "https://picsum.photos/250?image=11",
  //     type: "checkbox"),
  // Answers(
  //     answer1: "answer7",
  //     answer2: "answer8",
  //     answer3: "answer9",
  //     title: "Title 3",
  //     description: "Short description 3",
  //     url: "https://picsum.photos/250?image=12",
  //     type: "lecture"),
  // Answers(
  //     answer1: "answer10",
  //     answer2: "answer11",
  //     answer3: "answer12",
  //     title: "Title 4",
  //     description: "Short description 4",
  //     url: "TmDetBtk5rw",
  //     type: "video"),
];

List<Event> favorites = [];

List<FavorItem> favorItem = [];

class FavorItem{
  int id;
  String eventId;
  bool favorite;

  FavorItem({ this.id, this.eventId, this.favorite });
  }
