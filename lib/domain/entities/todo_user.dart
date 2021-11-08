class TodoUser {
  final String firstName;
  final String lastName;
  final String email;
  final String id;

  String get displayName{
    return "$firstName $lastName";
  }

  TodoUser(
    this.firstName, 
    this.lastName, 
    this.email, 
    this.id
  );

  TodoUser.fromJson(Map<String, dynamic> json)
    : firstName = json['firstname'],
      lastName = json['lastname'],
      email = json['email'],
      id = json['id'];

  Map<String, dynamic> toJson() => {
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    'id': id
  };
}