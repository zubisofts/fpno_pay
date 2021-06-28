// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fpno_pay/src/model/api_response.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/repository/data_repo.dart';
import 'package:fpno_pay/src/util/auth_error_handler.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<ApiResponse<FPNUser, String>> signUpUser({
    required FPNUser user,
    required String password,
  }) async {
    try {
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      FPNUser mUser = await DataService()
          .saveUserInfo(user: user.copyWith(id: userCredential.user!.uid));
      return ApiResponse(data: mUser, error: null);
    } on FirebaseAuthException catch (ex) {
      return ApiResponse(
          data: null,
          error: ExceptionHandler.generateExceptionMessage(
              ExceptionHandler.handleException(ex)));
    }
  }

  Future<ApiResponse> sendPasswordResetLink(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return ApiResponse(data: "Sent Successfully", error: false);
    } on FirebaseException catch (e) {
      return ApiResponse(data: '${e.message}', error: false);
    }
  }

  Future<void> logoutUser() async {
    try {
      _firebaseAuth.signOut();
    } on FirebaseException catch (e) {}
  }

  Stream<User?> get authUser {
    return _firebaseAuth.authStateChanges();
  }

  Future<ApiResponse<FPNUser, String>> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FPNUser user =
          await DataService().getUserInfo(userId: userCredential.user!.uid);
      return ApiResponse(data: user, error: null);
    } on FirebaseException catch (ex) {
      debugPrint('Login Error:${ex.code}');
      return ApiResponse(
          data: null,
          error: ExceptionHandler.generateExceptionMessage(
              ExceptionHandler.handleException(ex)));
    }
  }


}
