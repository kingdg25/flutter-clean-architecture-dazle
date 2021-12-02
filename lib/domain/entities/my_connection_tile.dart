class MyConnectionTile {
  final String id;
  final String photoURL;
  final String firstName;
  final String lastName;
  final String position;
  final String dateConnected;

  String get displayName{
    return "$firstName $lastName";
  }

  MyConnectionTile(
    this.id,
    this.photoURL,
    this.firstName, 
    this.lastName, 
    this.position,
    this.dateConnected
  );

  MyConnectionTile.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      photoURL = json['photo_url'],
      firstName = json['firstname'],
      lastName = json['lastname'],
      position = json['position'],
      dateConnected = json['date_connected'] ?? 'asd';

  Map<String, dynamic> toJson() => {
    '_id': id,
    'photo_url': photoURL,
    'firstname': firstName,
    'lastname': lastName,
    'position': position,
    'date_connected': dateConnected
  };
}