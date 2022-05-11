class Connections {
  final String? id;
  final String? displayName;
  final String? photoURL;
  final String? aboutMe;

  String get connectionsFullName {
    return "$displayName";
  }

  String get connectionsAboutMe {
    return aboutMe ?? ' ';
  }

  Connections(this.id, this.displayName, this.photoURL, this.aboutMe);

  Connections.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        displayName = json['displayName'],
        photoURL = json['photo_url'],
        aboutMe = json['about_me'];
}
