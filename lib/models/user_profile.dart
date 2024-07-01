import 'dart:convert';

class UserProfile {
  final String uid;
  final String ufname;
  final String ulname;
  final String telno;
  final String address;
  final String email;

  UserProfile(
      {required this.uid,
      required this.ufname,
      required this.ulname,
      required this.telno,
      required this.address,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'ufname': ufname,
      'ulname': ulname,
      'telno': telno,
      'address': address,
      'email': email
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      ufname: map['ufname'] ?? '',
      ulname: map['ulname'] ?? '',
      telno: map['telno'] ?? '',
      address: map['address'] ?? '',
      email: map['email'] ?? '',
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        uid: json['uid'],
        ufname: json['ufname'],
        ulname: json['ulname'],
        telno: json['telno'],
        address: json['address'],
        email: json['email']);
  }

  String toJson() => json.encode(toMap());
}
