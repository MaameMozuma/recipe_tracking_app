import 'dart:convert';

class UserProfile {
  final String username;
  final String height;
  final String weight;
  final String dob;
  final String telno;
  final String email;

  UserProfile(
      {required this.weight,
      required this.username,
      required this.height,
      required this.telno,
      required this.dob,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
      'dob': dob,
      'telno': telno,
      'email': email,
      'username': username,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'] ?? '',
      telno: map['telno'] ?? '',
      email: map['email'] ?? '',
      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      dob: map['dob'] ?? '',
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      telno: json['telno'],
      email: json['email'],
      height: json['height'],
      weight: json['weight'],
      dob: json['dob'],
      username: json['username'],
    );
  }

  String toJson() => json.encode(toMap());
}
