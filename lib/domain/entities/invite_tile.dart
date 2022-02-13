class InviteTile {
  final String? id;
  final String? photoURL;
  final String? firstName;
  final String? lastName;
  final String? totalConnection;

  String get displayName{
    return "$firstName $lastName";
  }

  InviteTile({
    this.id,
    this.photoURL,
    this.firstName, 
    this.lastName, 
    this.totalConnection
  });

  InviteTile.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      photoURL = json['photo_url'],
      firstName = json['firstname'],
      lastName = json['lastname'],
      totalConnection = json['total_connection'];

  Map<String, dynamic> toJson() => {
    '_id': id,
    'photo_url': photoURL,
    'firstname': firstName,
    'lastname': lastName,
    'total_connection': totalConnection
  };
}