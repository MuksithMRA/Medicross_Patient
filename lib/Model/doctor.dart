import 'dart:convert';

class Doctor {
  String fullName;
  String specialization;
  String city;
  bool availability;
  String email;
  String phone;
  String? profilePic;
  dynamic uid;
  // ignore: non_constant_identifier_names
  double hourly_rate;
  String type;

  Doctor({
    required this.fullName,
    required this.specialization,
    required this.city,
    required this.availability,
    required this.email,
    required this.phone,
    this.profilePic,
    required this.uid,
    // ignore: non_constant_identifier_names
    required this.hourly_rate,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'specialization': specialization,
      'city': city,
      'availability': availability,
      'email': email,
      'phone': phone,
      'profilePic': profilePic,
      'uid': uid,
      'hourly_rate': hourly_rate.toString(),
      'type': type,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      fullName: map['fullName'] ?? '',
      specialization: map['specialization'] ?? '',
      city: map['city'] ?? '',
      availability: map['availability'] ?? false,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profilePic: map['profilePic'],
      uid: map['uid'],
      hourly_rate: double.parse(map['hourly_rate']??'0.0'),
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));
}
