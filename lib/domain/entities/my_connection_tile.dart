class MyConnectionTile {
  final String? id;
  final String? photoURL;
  final String? firstName;
  final String? lastName;
  final String? position;
  final String? dateModified;

  String get displayName{
    return "$firstName $lastName";
  }

  MyConnectionTile({
    this.id,
    this.photoURL,
    this.firstName, 
    this.lastName, 
    this.position,
    this.dateModified
  });

  MyConnectionTile.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      photoURL = json['photo_url'],
      firstName = json['firstname'],
      lastName = json['lastname'],
      position = json['position'],
      dateModified = json['date_modified'] ?? '';

  Map<String, dynamic> toJson() => {
    '_id': id,
    'photo_url': photoURL,
    'firstname': firstName,
    'lastname': lastName,
    'position': position,
    'date_modified': dateModified
  };
}