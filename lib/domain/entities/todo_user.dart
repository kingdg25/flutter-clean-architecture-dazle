class TodoUser {
  final bool newUser;
  final String firstName;
  final String lastName;
  final String email;
  final String id;

  String get displayName{
    return "$firstName $lastName";
  }

  TodoUser(
    this.newUser,
    this.firstName, 
    this.lastName, 
    this.email, 
    this.id
  );

  TodoUser.fromJson(Map<String, dynamic> json)
    : newUser = json['new_user'],
      firstName = json['firstname'],
      lastName = json['lastname'],
      email = json['email'],
      id = json['id'];

  Map<String, dynamic> toJson() => {
    'new_user': newUser,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    'id': id
  };
}