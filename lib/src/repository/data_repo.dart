import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/model/api_response.dart';
import 'package:fpno_pay/src/model/fee.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/repository/payment_repository.dart';
import 'package:fpno_pay/src/util/constants.dart';
import 'package:fpno_pay/src/util/pdf_util.dart';
import 'package:uuid/uuid.dart';

class DataService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<FPNUser> get user => _firebaseFirestore
      .collection('users')
      .doc(AuthBloc.uid)
      .snapshots()
      .map((doc) => FPNUser.fromMap(doc.data()!));

  Future<dynamic> getUserInfo({
    required String userId,
  }) async {
    try {
      DocumentSnapshot doc =
          await _firebaseFirestore.collection('users').doc(userId).get();
      return FPNUser.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return e;
    }
  }

  Future<dynamic> saveUserInfo({
    required FPNUser user,
  }) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      // await _firebaseFirestore.collection("wallets")
      return user;
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return e.message;
    }
  }

  Future<dynamic> updateUserPhoto({
    required FPNUser user,
    required File photo,
  }) async {
    try {
      ApiResponse res = await saveUserPhoto(user.id, photo);
      if (res.error) {
        return ApiResponse(data: res.data, error: true);
      }

      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update({"photo": res.data});

      // await _firebaseFirestore.collection("wallets")
      return ApiResponse(
          data: "Profile photo successfully updated", error: false);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return ApiResponse(data: e.message, error: true);
    }
  }

  Future<ApiResponse> pay(
      int amount, BuildContext context, PaymentCard card) async {
    PaystackPlugin paystackPlugin = PaystackPlugin();
    await paystackPlugin.initialize(publicKey: Constants.PAYSTACK_PUBLIC_API);
    try {
      Uuid referenceKey = Uuid();
      String ref = referenceKey.v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': new DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      });

      Charge charge = Charge()
        ..amount = amount * 100
        ..reference = '$ref'
        ..card = card
        ..currency = 'NGN'
        ..putMetaData("name", "NI Trades")
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = 'zubitex40@email.com'
        ..putCustomField('Charged From', 'NI Trades');

      // CheckoutResponse response =
      //     await paystackPlugin.chargeCard(context, charge: charge);

      CheckoutResponse response = await paystackPlugin.chargeCard(
        context,
        charge: charge,
      );

      print('Transaction Response: ${response.status}');

      if (response.status) {
        return ApiResponse(data: ref, error: false);
      } else {
        return ApiResponse(data: ref, error: true);
      }
    } catch (ex) {
      return ApiResponse(data: ex, error: true);
    }
  }

  Future<ApiResponse> saveUserPhoto(String id, File photo) async {
    try {
      var task = await FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child('$id')
          .putFile(photo);

      var url = await task.ref.getDownloadURL();
      // await file.delete();
      return ApiResponse(data: url, error: false);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return ApiResponse(data: e.message, error: true);
    }
  }

  Future<ApiResponse> fetchFee(
      {required String programme, required type, required session}) async {
    try {
      var queryDocs = await _firebaseFirestore
          .collection('fees')
          .where('programme', isEqualTo: programme)
          .where('session', isEqualTo: session)
          .where('type', isEqualTo: type)
          .get();

      if (queryDocs.docs.isEmpty) {
        return ApiResponse(
            data: "Sorry, we couldn't find any data related to your request.",
            error: true);
      }
      var doc = queryDocs.docs.last;
      return ApiResponse(data: Fee.fromMap(doc.data()), error: false);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return ApiResponse(data: e.code, error: true);
    }
  }

  Future<ApiResponse> addFee({required Fee fee}) async {
    try {
      var docs = await _firebaseFirestore.collection("fees").get();
      var duplicates = docs.docs
          .map((snapshot) => Fee.fromMap(snapshot.data()))
          .where((f) =>
              f.programme == fee.programme &&
              f.session == fee.session &&
              f.type == fee.type)
          .toList();
      if (duplicates.isNotEmpty) {
        print(duplicates.first.toJson());
        return ApiResponse(
            data: "There's a record of this data already existing",
            error: true);
      }

      var ref = _firebaseFirestore.collection('fees').doc();
      await ref.set(fee.copyWith(id: ref.id).toMap());
      return ApiResponse(data: "Successfully added fee", error: false);
    } on FirebaseException catch (e) {
      debugPrint('Error:${e.code}');
      return ApiResponse(data: e.code, error: true);
    } on SocketException catch (se) {
      return ApiResponse(data: se.message, error: true);
    }
  }

  Future<ApiResponse> makePayment(
      PaymentData paymentData, BuildContext context, PaymentCard card) async {
    try {
      var docRef = _firebaseFirestore.collection("payments").doc();
      ApiResponse payRes = await PaymentRepository()
          .pay(paymentData.amount, context, card, docRef.id);
      if (payRes.error) {
        return ApiResponse(data: payRes.data, error: true);
      }

      await docRef.set(
          paymentData.copyWith(id: docRef.id, refernceNo: docRef.id).toMap());
      return ApiResponse(data: docRef.id, error: false);
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }

  Stream<List<PaymentData>> fetchPayments(
      PaymentType paymentType, String userId) {
    if (paymentType == PaymentType.All) {
      return _firebaseFirestore
          .collection("payments")
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PaymentData.fromMap(doc.data()))
              .toList());
    }

    return _firebaseFirestore
        .collection("payments")
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: typeValues.reverse[paymentType])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentData.fromMap(doc.data()))
            .toList());
  }

  Stream<List<PaymentData>> fetchAllUserPayments(PaymentType type) {
    if (type == PaymentType.All) {
      return _firebaseFirestore.collection("payments").snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => PaymentData.fromMap(doc.data()))
              .toList());
    }
    return _firebaseFirestore
        .collection("payments")
        .where('type', isEqualTo: typeValues.reverse[type])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentData.fromMap(doc.data()))
            .toList());
  }

  Future<Uint8List?> generateReciept(
      PaymentData paymentData, FPNUser user) async {
    try {
      var data = await generatePaymentReciept(paymentData, user);
      // final output = await getExternalStorageDirectory();
      // final file = File('${output!.path}/sample.pdf');
      // await file.writeAsBytes(data);
      return data;
    } catch (e) {
      return null;
    }
  }

  Stream<List<PaymentData>> searchUserPayments(String query) {
    return _firebaseFirestore.collection("payments").snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => PaymentData.fromMap(doc.data()))
            .where(
                (p) => p.refernceNo.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }
}
