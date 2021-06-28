part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}

// FetchUserState
class UserDetailsFetchedState extends DataState {
  final FPNUser user;

  UserDetailsFetchedState(this.user);

  @override
  List<Object> get props => [user];
}

class UserDetailsLoadingState extends DataState {}

class UserDetailsErrorState extends DataState {
  final String error;

  UserDetailsErrorState(this.error);
}

// End of UetchUserDetailsState
class UpdateUserPhotoLoadingState extends DataState {}

class UserPhotoUpdatedState extends DataState {
  final String message;

  UserPhotoUpdatedState(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateUserPhotoFailureState extends DataState {
  final String error;

  UpdateUserPhotoFailureState(this.error);

  @override
  List<Object> get props => [error];
}

class FeeDataFetchedState extends DataState {
  final Fee fee;

  FeeDataFetchedState({required this.fee});

  @override
  List<Object> get props => [fee];
}

class FetchFeeErrorState extends DataState {
  final String error;
  FetchFeeErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class FetchFeeLoadingState extends DataState {}

class PaymentLoadingState extends DataState {}

class PaymentErrorState extends DataState {
  final String error;

  PaymentErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class PaymentSuccessState extends DataState {
  final String message;

  PaymentSuccessState(this.message);
  @override
  List<Object> get props => [message];
}

class PaymentsFetchedState extends DataState {
  final List<PaymentData> payments;

  PaymentsFetchedState(this.payments);

  @override
  List<Object> get props => [payments];
}

class FetchPaymentsErrorState extends DataState {
  final String error;

  FetchPaymentsErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class FetchPaymentsLoadingState extends DataState {}

class FetchAllPaymentsLoadingState extends DataState {}

class FetchAllPaymentsErrorState extends DataState {
  final String error;

  FetchAllPaymentsErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AllPaymentsFetchState extends DataState {
  final List<PaymentData> payments;

  AllPaymentsFetchState(this.payments);

  @override
  List<Object> get props => [payments];
}

class FeeAddedState extends DataState {
  final String message;

  FeeAddedState(this.message);

  @override
  List<Object> get props => [message];
}

class AddFeeErrorState extends DataState {
  final String error;

  AddFeeErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AddFeeLoadingSatate extends DataState{}
