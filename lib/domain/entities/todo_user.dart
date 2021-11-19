class TodoUser {
  final bool isNewUser;
  final String firstName;
  final String lastName;
  final String email;
  final String id;

  String get displayName{
    return "$firstName $lastName";
  }

  TodoUser(
    this.isNewUser,
    this.firstName, 
    this.lastName, 
    this.email, 
    this.id
  );

  TodoUser.fromJson(Map<String, dynamic> json)
    : isNewUser = json['is_new_user'],
      firstName = json['firstname'],
      lastName = json['lastname'],
      email = json['email'],
      id = json['id'];

  Map<String, dynamic> toJson() => {
    'is_new_user': isNewUser,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    'id': id
  };
}