import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fpno_pay/src/model/fee.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/repository/data_repo.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc({required this.dataService}) : super(DataInitial());

  late DataService dataService;

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is FetchUserDetailsEvent) {
      yield* _mapFetchUserDetailsEvent(event.uid);
    }

    if (event is UpdateUserPhotoEvent) {
      yield* _mapUpdateUserPhotoEventToState(event.user, event.photo);
    }

    if (event is FetchFeeDataEvent) {
      yield* _mapFetchFeeDataEventToState(
          event.programme, event.session, event.type);
    }

    if (event is MakePaymentEvent) {
      yield* _mapMakePaymentEventToState(
          event.paymentData, event.context, event.card);
    }

    if (event is FetchPaymentsEvent) {
      yield* _mapFetchPaymentsEventToState(event.paymentType, event.userId);
    }

    if (event is PaymentsFetchedEvent) {
      yield PaymentsFetchedState(event.payments);
    }

    if (event is FetchAllUserPaymentsEvent) {
      yield* _mapFetchAllUserPaymentsEventToState(event.type);
    }

    if (event is AllUserPaymentsFetchedEvent) {
      yield AllPaymentsFetchState(event.payments);
    }

    if (event is UserDetailsFetchedEvent) {
      yield UserDetailsFetchedState(event.user);
    }

    if (event is SearchUserPaymentsEvent) {
      yield* _mapSearchUserPaymentsEventToState(event.query);
    }

    if (event is AddNewFeeEvent) {
      yield* _mapAddNewFeeEventToState(event.fee);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<DataState> _mapFetchUserDetailsEvent(String uid) async* {
    yield UserDetailsLoadingState();
    dataService.user.listen((user) {
      add(UserDetailsFetchedEvent(user));
    });
    // if (response is FPNUser) {
    //   yield UserDetailsFetchedState(response);
    // }

    // if (response is FirebaseException) {
    //   yield UserDetailsErrorState(response.message!);
    // }
  }

  Stream<DataState> _mapUpdateUserPhotoEventToState(user, File photo) async* {
    yield UpdateUserPhotoLoadingState();
    var res = await dataService.updateUserPhoto(user: user, photo: photo);
    if (!res.error) {
      yield UserPhotoUpdatedState(res.data);
    } else {
      yield UpdateUserPhotoFailureState(res.data);
    }
  }

  Stream<DataState> _mapFetchFeeDataEventToState(
      String programme, String session, String type) async* {
    yield FetchFeeLoadingState();
    var response = await dataService.fetchFee(
        programme: programme, type: type, session: session);
    if (!response.error) {
      yield FeeDataFetchedState(fee: response.data);
    } else {
      yield FetchFeeErrorState(error: response.data);
    }
  }

  Stream<DataState> _mapMakePaymentEventToState(
      paymentData, context, card) async* {
    yield PaymentLoadingState();
    var response = await dataService.makePayment(paymentData, context, card);
    if (!response.error) {
      yield PaymentSuccessState(response.data);
    } else {
      yield PaymentErrorState(response.data);
    }
  }

  Stream<DataState> _mapFetchPaymentsEventToState(
      PaymentType paymentType, String userId) async* {
    yield FetchPaymentsLoadingState();
    dataService.fetchPayments(paymentType, userId).listen((payments) {
      add(PaymentsFetchedEvent(payments));
    });
  }

  Stream<DataState> _mapFetchAllUserPaymentsEventToState(
      PaymentType type) async* {
    dataService.fetchAllUserPayments(type).listen((payments) {
      add(AllUserPaymentsFetchedEvent(payments));
    });
  }

  Stream<DataState> _mapSearchUserPaymentsEventToState(String query) async* {
    dataService.searchUserPayments(query).listen((payments) {
      add(AllUserPaymentsFetchedEvent(payments));
    });
  }

  Stream<DataState> _mapAddNewFeeEventToState(Fee fee) async* {
    yield AddFeeLoadingSatate();
    var response = await dataService.addFee(fee: fee);
    if (!response.error) {
      yield FeeAddedState(response.data);
    } else {
      yield AddFeeErrorState(response.data);
    }
  }
}
