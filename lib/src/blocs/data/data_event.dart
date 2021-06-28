part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetailsEvent extends DataEvent {
  final String uid;

  FetchUserDetailsEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class UserDetailsFetchedEvent extends DataEvent {
  final FPNUser user;

  UserDetailsFetchedEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserPhotoEvent extends DataEvent {
  final FPNUser user;
  final File photo;

  UpdateUserPhotoEvent(this.user, this.photo);

  @override
  List<Object> get props => [user, photo];
}

class PaymentEvent extends DataEvent {
  final PaymentData paymentData;
  final PaymentCard card;
  final BuildContext context;

  PaymentEvent(this.paymentData, this.card, this.context);

  @override
  List<Object> get props => [paymentData, card, context];
}

class FetchUserPaymentsEvent extends DataEvent {
  final String userId;

  FetchUserPaymentsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class FetchFeeDataEvent extends DataEvent {
  final String programme;
  final String session;
  final String type;

  FetchFeeDataEvent(
      {required this.programme, required this.session, required this.type});

  @override
  List<Object> get props => [programme, session, type];
}

class MakePaymentEvent extends DataEvent {
  final PaymentData paymentData;
  final BuildContext context;
  final PaymentCard card;

  MakePaymentEvent(this.paymentData, this.context, this.card);

  @override
  List<Object> get props => [paymentData, context, card];
}

class FetchPaymentsEvent extends DataEvent {
  final PaymentType paymentType;
  final String userId;

  FetchPaymentsEvent({required this.paymentType, required this.userId});

  @override
  List<Object> get props => [paymentType, userId];
}

class PaymentsFetchedEvent extends DataEvent {
  final List<PaymentData> payments;

  PaymentsFetchedEvent(this.payments);

  @override
  List<Object> get props => [payments];
}

class FetchAllUserPaymentsEvent extends DataEvent {
  final PaymentType type;

  FetchAllUserPaymentsEvent(this.type);

  @override
  List<Object> get props => [type];
}

class AllUserPaymentsFetchedEvent extends DataEvent {
  final List<PaymentData> payments;

  AllUserPaymentsFetchedEvent(this.payments);

  @override
  List<Object> get props => [payments];
}

class SearchUserPaymentsEvent extends DataEvent {
  final String query;

  SearchUserPaymentsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class AddNewFeeEvent extends DataEvent {
  final Fee fee;

  AddNewFeeEvent(this.fee);

  @override
  List<Object> get props => [fee];
}
