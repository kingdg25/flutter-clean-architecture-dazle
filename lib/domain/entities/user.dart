class User {
  final String position;
  final String brokerLicenseNumber;
  final String mobileNumber;
  final bool isNewUser;
  final String firstName;
  final String lastName;
  final String email;
  final String id;

  String get displayName{
    return "$firstName $lastName";
  }

  User({
    this.position,
    this.brokerLicenseNumber,
    this.mobileNumber,
    this.isNewUser,
    this.firstName, 
    this.lastName, 
    this.email, 
    this.id
  });

  User.fromJson(Map<String, dynamic> json)
    : mobileNumber = json['mobile_number'],
      brokerLicenseNumber = json['broker_license_number'],
      position = json['position'],
      isNewUser = json['is_new_user'],
      firstName = json['firstname'],
      lastName = json['lastname'],
      email = json['email'],
      id = json['_id'];

  Map<String, dynamic> toJson() => {
    'broker_license_number': brokerLicenseNumber,
    'position': position,
    'mobile_number': mobileNumber,
    'is_new_user': isNewUser,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    '_id': id
  };
}