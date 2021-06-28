import 'dart:convert';

import 'package:equatable/equatable.dart';

class PaymentData extends Equatable {
  final String id;
  final String userId;
  final String level;
  final String type;
  final String purpose;
  final String session;
  final String semester;
  final String paymentMethod;
  final int amount;
  final String refernceNo;
  final int timestamp;
  PaymentData({
    required this.id,
    required this.userId,
    required this.level,
    required this.type,
    required this.purpose,
    required this.session,
    required this.semester,
    required this.paymentMethod,
    required this.amount,
    required this.refernceNo,
    required this.timestamp,
  });

  PaymentData copyWith({
    String? id,
    String? userId,
    String? level,
    String? type,
    String? purpose,
    String? session,
    String? semester,
    String? paymentMethod,
    int? amount,
    String? refernceNo,
    int? timestamp,
  }) {
    return PaymentData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      level: level ?? this.level,
      type: type ?? this.type,
      purpose: purpose ?? this.purpose,
      session: session ?? this.session,
      semester: semester ?? this.semester,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      refernceNo: refernceNo ?? this.refernceNo,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'level': level,
      'type': type,
      'purpose': purpose,
      'session': session,
      'semester': semester,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'refernceNo': refernceNo,
      'timestamp': timestamp,
    };
  }

  factory PaymentData.fromMap(Map<String, dynamic> map) {
    return PaymentData(
      id: map['id'],
      userId: map['userId'],
      level: map['level'],
      type: map['type'],
      purpose: map['purpose'],
      session: map['session'],
      semester: map['semester'],
      paymentMethod: map['paymentMethod'],
      amount: map['amount'],
      refernceNo: map['refernceNo'],
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentData.fromJson(String source) => PaymentData.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      userId,
      level,
      type,
      purpose,
      session,
      semester,
      paymentMethod,
      amount,
      refernceNo,
      timestamp,
    ];
  }
}

enum PaymentType { AcceptanceFee, SchoolFee, TEDC, Microsoft, All }

final typeValues = EnumValues({
  "Acceptance Fee": PaymentType.AcceptanceFee,
  "School Fee": PaymentType.SchoolFee,
  "TEDC Fee": PaymentType.TEDC,
  "Microsoft Fee": PaymentType.Microsoft,
  "All": PaymentType.All
});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => new MapEntry(v, k));
    return reverseMap;
  }
}
