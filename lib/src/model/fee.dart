import 'dart:convert';

import 'package:equatable/equatable.dart';

class Fee extends Equatable {
  final String id;
  final String name;
  final int amount;
  final String type;
  final String session;
  final String programme;

  Fee({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.session,
    required this.programme,
  });

  Fee copyWith({
    String? id,
    String? name,
    int? amount,
    String? type,
    String? session,
    String? programme,
  }) {
    return Fee(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      session: session ?? this.session,
      programme: programme ?? this.programme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type,
      'session': session,
      'programme': programme
    };
  }

  factory Fee.fromMap(Map<String, dynamic> map) {
    return Fee(
        id: map['id'],
        name: map['name'],
        amount: map['amount'],
        type: map['type'],
        session: map['session'],
        programme: map['programme']);
  }

  String toJson() => json.encode(toMap());

  factory Fee.fromJson(String source) => Fee.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, amount, type, session, programme];
}

// enum FeeType { AcceptanceFee, SchoolFee, TEDC, Microsoft }

// final typeValues = EnumValues({
//   "Acceptance Fee": FeeType.AcceptanceFee,
//   "School Fee": FeeType.SchoolFee,
//   "TEDC Fee": FeeType.TEDC,
//   "Microsoft Fee": FeeType.Microsoft,
// });

// class EnumValues<T> {
//   late Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => new MapEntry(v, k));
//     return reverseMap;
//   }
// }
