class Users{
  String name;

  Users({this.name});
}

List<Users> users = [
  Users(name: 'user1'),
  Users(name: 'user2'),
  Users(name: 'user3'),
];

Users user = users.first;