class User {
  final String? aboutMe;
  final String? accountStatus;
  final String? position;
  final String? brokerLicenseNumber;
  final String? mobileNumber;
  final bool? isNewUser;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool? emailVerified;
  final String? id;
  String? profilePicture;

  String get displayName {
    return "$firstName $lastName";
  }

  User(
      {this.aboutMe,
      this.accountStatus,
      this.position,
      this.brokerLicenseNumber,
      this.mobileNumber,
      this.isNewUser,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerified,
      this.id,
      this.profilePicture});

  User.fromJson(Map<String, dynamic> json)
      : aboutMe = json['about_me'],
        accountStatus = json['account_status'],
        mobileNumber = json['mobile_number'],
        brokerLicenseNumber = json['broker_license_number'],
        position = json['position'],
        isNewUser = json['is_new_user'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        email = json['email'],
        emailVerified = json['email_verified'],
        id = json['_id'],
        profilePicture = json['profile_picture'];

  Map<String, dynamic> toJson() => {
        'about_me': aboutMe,
        'account_status': accountStatus,
        'broker_license_number': brokerLicenseNumber,
        'position': position,
        'mobile_number': mobileNumber,
        'is_new_user': isNewUser,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'email_verified': emailVerified,
        '_id': id,
        'profile_picture': profilePicture
      };
}

class Verification {
  final String? user_id;
  final String? status;
  final String? attachment;

  Verification({this.user_id, this.status, this.attachment});

  Verification.fromJson(Map<String, dynamic> json)
      : user_id = json['user_id'],
        status = json['status'],
        attachment = json['attachment'];

  Map<String, dynamic> toJson() =>
      {'user_id': user_id, 'status': status, 'attachment': attachment};
}

class UserFeedback {
  final String? userId;
  final String? userDisplayName;
  final String? likes;
  final String? improvements;

  UserFeedback(
      this.likes, this.improvements, this.userId, this.userDisplayName);

  UserFeedback.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userDisplayName = json['user_display_name'],
        likes = json['likes'],
        improvements = json['improvements'];

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_display_name': userDisplayName,
        'likes': likes,
        'improvements': improvements
      };
}
