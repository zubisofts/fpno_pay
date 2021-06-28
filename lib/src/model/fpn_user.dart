import 'dart:convert';

import 'package:equatable/equatable.dart';

class FPNUser extends Equatable {
  final String id;
  final String appNo;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String address;
  final String department;
  final String programme;
  final String school;
  final String photo;
  final bool isAdmin;
  final int createdAt;
  FPNUser({
    required this.id,
    required this.appNo,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.department,
    required this.programme,
    required this.school,
    required this.photo,
    required this.isAdmin,
    required this.createdAt,
  });

  FPNUser copyWith({
    String? id,
    String? appNo,
    String? firstName,
    String? lastName,
    String? gender,
    String? email,
    String? phoneNumber,
    String? address,
    String? department,
    String? programme,
    String? school,
    String? photo,
    bool? isAdmin,
    int? createdAt,
  }) {
    return FPNUser(
      id: id ?? this.id,
      appNo: appNo ?? this.appNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      department: department ?? this.department,
      programme: programme ?? this.programme,
      school: school ?? this.school,
      photo: photo ?? this.photo,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appNo': appNo,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'department': department,
      'programme': programme,
      'school': school,
      'photo': photo,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
    };
  }

  factory FPNUser.fromMap(Map<String, dynamic> map) {
    return FPNUser(
      id: map['id'],
      appNo: map['appNo'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      gender: map['gender'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      department: map['department'],
      programme: map['programme'],
      school: map['school'],
      photo: map['photo'],
      isAdmin: map['isAdmin'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FPNUser.fromJson(String source) => FPNUser.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      appNo,
      firstName,
      lastName,
      gender,
      email,
      phoneNumber,
      address,
      department,
      programme,
      school,
      photo,
      isAdmin,
      createdAt,
    ];
  }
}
