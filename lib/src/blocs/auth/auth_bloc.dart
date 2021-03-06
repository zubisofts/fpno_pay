import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpno_pay/src/model/api_response.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    _userSubscription = authService.authUser.listen(
      (firebaseUser) => add(AuthStateChangedEvent(firebaseUser)),
    );
  }

  late StreamSubscription _userSubscription;
  static String? uid;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignUpEvent) {
      yield* _mapSignUpEventToState(event.user, event.password);
    }

    if (event is AuthStateChangedEvent) {
      yield* _mapAuthStateChangedEventToState(event.user);
    }

    if (event is LoginUserEvent) {
      yield* _mapLoginUserEventToState(event.email, event.password);
    }

    if (event is LogoutUserEvent) {
      await authService.logoutUser();
    }

    if (event is SendPasswordResetLink) {
      yield* _mapSendPasswordResetLinkToState(event.email);
    }
  }

  Stream<AuthState> _mapSignUpEventToState(
      FPNUser user, String password) async* {
    yield SignUpLoadingState();
    var res = await authService.signUpUser(user: user, password: password);
    if (res.error == null) {
      uid = res.data!.id;
      yield UserSignedUpState(res.data!);
    } else {
      yield SignupUserErrorState(res.error!);
    }
  }

  Stream<AuthState> _mapLoginUserEventToState(
      String email, String password) async* {
    yield LoginUserLoadingState();
    var res = await authService.loginUserWithEmailAndPassword(email, password);
    if (res.error == null) {
      uid = res.data!.id;
      yield UserLoggedInState(res.data!);
    } else {
      yield LoginUserErrorState(res.error!);
    }
  }

  Stream<AuthState> _mapAuthStateChangedEventToState(User? user) async* {
    yield AuthUserChangedState(
        user != null
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
        user);
    if (user != null) {
      uid = user.uid;
    }
  }


  Stream<AuthState> _mapSendPasswordResetLinkToState(String email) async*{
     yield SendPasswordResetLinkLoadingState();
    ApiResponse response = await AuthService().sendPasswordResetLink(email);
    if (response.error) {
      yield SendPasswordResetLinkFailureState(response.data);
    } else {
      yield PasswordResetLinkSentState();
    }
  }
}
