class User {
  int? id;
  String firstName;
  String lastName;
  String email;
  String username;

  User({required this.firstName, required this.lastName, required this.email, required this.username, this.id});
}