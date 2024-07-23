import 'dart:convert';

class UserProfile {
  final String username;
  final String height;
  final String weight;
  final String dob;
  final String telno;
  final String email;
  final String fcmtoken;
  final dynamic profile_pic_url;

  UserProfile(
      {required this.weight,
      required this.username,
      required this.height,
      required this.telno,
      required this.dob,
      required this.email,
      required this.fcmtoken,
      this.profile_pic_url});

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
      'dob': dob,
      'phone_number': telno,
      'email': email,
      'username': username,
      'fcmtoken': fcmtoken,
      'profile_pic_url': profile_pic_url
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'] ?? '',
      telno: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      dob: map['dob'] ?? '',
      fcmtoken: map['fcmtoken'] ?? '',
      profile_pic_url: map['profile_pic_url'] ?? '',
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        telno: json['phone_number'],
        email: json['email'],
        height: json['height'],
        weight: json['weight'],
        dob: json['dob'],
        username: json['username'],
        fcmtoken: json['fcmtoken'],
        profile_pic_url: json['profile_pic_url']);
  }

  String toJson() => json.encode(toMap());
}
