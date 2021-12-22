class PhotoTile {
  final String photoURL;
  final String text;


  PhotoTile({
    this.photoURL,
    this.text,
  });

  PhotoTile.fromJson(Map<String, dynamic> json)
    : photoURL = json['photo_url'],
      text = json['text'];

  Map<String, dynamic> toJson() => {
    'photo_url': photoURL,
    'text': text
  };
}