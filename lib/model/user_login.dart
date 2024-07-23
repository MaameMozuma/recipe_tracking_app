import 'dart:convert';

class UserLogin {
  final String username;
  final String password;
  final String fcmtoken;

  UserLogin(
      {required this.username, required this.password, required this.fcmtoken});

  Map<String, dynamic> toMap() {
    return {'fcmtoken': fcmtoken, 'username': username, 'password': password};
  }

  factory UserLogin.fromMap(Map<String, dynamic> map) {
    return UserLogin(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      fcmtoken: map['fcmtoken'] ?? '',
    );
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      password: json['password'],
      fcmtoken: json['fcmtoken'],
      username: json['username'],
    );
  }
  String toJson() => json.encode(toMap());
}
