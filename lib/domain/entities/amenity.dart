class Amenity {
  final String? text;
  bool? added;

  Amenity({
    this.text,
    this.added = false
  });

  Amenity.fromJson(Map<String, dynamic> json)
    : text = json['text'],
      added = json['added'];

  Map<String, dynamic> toJson() => {
    'text': text,
    'added': added
  };
}