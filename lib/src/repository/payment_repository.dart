import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fpno_pay/src/model/api_response.dart';
import 'package:fpno_pay/src/model/bank.dart';
import 'package:fpno_pay/src/model/time_api.dart';
import 'package:fpno_pay/src/util/constants.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaymentRepository {
  Future<ApiResponse> verifyAccount(
      String accountNumber, String bankCode) async {
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.paystack.co/bank/resolve?account_number=$accountNumber&bank_code=$bankCode'),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${Constants.PAYSTACK_SECRETE}',
          });

      var d = jsonDecode(response.body);
      if (d['status']) {
        return ApiResponse(data: d['data']['account_name'], error: false);
      } else {
        return ApiResponse(data: d['message'], error: true);
      }
    } catch (e) {
      return ApiResponse(data: "An error occured!", error: true);
    }
  }

// Create transfer recipient
  Future<ApiResponse> createTransferRecipient(
      {required String name,
      required String accountNumber,
      required String bankCode,
      String currency = "NGN"}) async {
    try {
      var response = await http
          .post(Uri.parse('https://api.paystack.co/transferrecipient'), body: {
        'name': name,
        'account_number': accountNumber,
        'bank_code': bankCode,
        'currency': currency,
        'type': 'nuban'
      }, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Constants.PAYSTACK_SECRETE}',
      });

      var d = jsonDecode(response.body);
      if (d['status']) {
        return ApiResponse(data: d, error: false);
      } else {
        return ApiResponse(data: d['message'], error: true);
      }
    } catch (e) {
      return ApiResponse(data: "An error occured!", error: true);
    }
  }

  // Initiate transfer
  Future<ApiResponse> initiatePaymentTransfer(
      {required String source,
      required String amount,
      required String recipient,
      required String reason}) async {
    try {
      var response =
          await http.post(Uri.parse('https://api.paystack.co/transfer'), body: {
        'source': source,
        'amount': amount,
        'recipient': recipient,
        'reason': reason,
      }, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Constants.PAYSTACK_SECRETE}',
      });

      var d = jsonDecode(response.body);
      if (d['status']) {
        return ApiResponse(data: d, error: false);
      } else {
        return ApiResponse(data: d['message'], error: true);
      }
    } catch (e) {
      return ApiResponse(data: "An error occured!", error: true);
    }
  }

// Try to make a transfer
// This returns a verification OTP to continue with transaction
  Future<ApiResponse> makeTransfer(
      {required String name,
      required String accountNumber,
      required String bankCode,
      required String amount,
      String source = "balance",
      String currency = "NGN"}) async {
    try {
      ApiResponse res1 = await verifyAccount(accountNumber, bankCode);
      if (!res1.error) {
        ApiResponse res2 = await createTransferRecipient(
            name: name, accountNumber: accountNumber, bankCode: bankCode);

        if (!res2.error) {
          ApiResponse res3 = await initiatePaymentTransfer(
              source: source,
              amount: amount,
              recipient: res2.data['data']['recipient_code'],
              reason: "Investment widthdrawal");

          if (!res3.error) {
            return res3;
          } else {
            return res3;
          }
        } else {
          return res2;
        }
      } else {
        return res1;
      }
    } catch (e) {
      return ApiResponse(data: e.toString(), error: true);
    }
  }

  Future<List<Bank>> get getBankList async {
    String json = await rootBundle.loadString('assets/files/bank_list.json');
    var data = bankListFromJson(json);
    return data.data;
  }

  Future<ApiResponse> get getCurrentTime async {
    try {
      final response = await http.get(
        Uri.parse('https://world-clock.p.rapidapi.com/json/gmt/now'),
        headers: {
          'content-type': 'application/json',
          'Access-Control-Allow-Origin': 'true',
          'x-rapidapi-key':
              '62a3289a18mshae4f62227441f27p1e1607jsn952d6b5a04ca',
          'x-rapidapi-host': 'world-clock.p.rapidapi.com',
          'useQueryString': 'true'
        },
      );
      if (response.statusCode == 200) {
        TimeApi time = TimeApi.fromJson(jsonDecode(response.body));
        return ApiResponse(data: time, error: false);
      } else {
        return ApiResponse(data: 'Network error', error: true);
      }
    } on SocketException catch (_) {
      return ApiResponse(data: 'Network error', error: true);
    } catch (e) {
      print(e);
      return ApiResponse(
          data: 'Unable to fetch data at the moment', error: true);
    }
  }

  Future<ApiResponse> pay(
      int amount, BuildContext context, PaymentCard card, String ref) async {
    PaystackPlugin paystackPlugin = PaystackPlugin();
    await paystackPlugin.initialize(publicKey: Constants.PAYSTACK_PUBLIC_API);
    try {
      // Uuid referenceKey = Uuid();
      // String ref = referenceKey.v4(options: {
      //   'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
      //   'clockSeq': 0x1234,
      //   'mSecs': DateTime.now().millisecondsSinceEpoch,
      //   'nSecs': 5678
      // });

      Charge charge = Charge()
        ..amount = amount * 100
        ..reference = '$ref'
        ..card = card
        ..currency = 'NGN'
        ..putMetaData("name", "FPNO Pay")
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = 'zubitex40@email.com'
        ..putCustomField('Charged From', 'FPNO Pay');

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
}
