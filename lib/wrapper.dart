import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/pages/admin/home/admin_homepage.dart';
import 'package:fpno_pay/src/pages/auth/login_page.dart';
import 'package:fpno_pay/src/pages/student/home/homepage.dart';

import 'src/blocs/data/data_bloc.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUserChangedState) {
          if (state.status == AuthenticationStatus.authenticated) {
            if (state.user!.email == "admin@gmail.com") {
              return AdminHomePage(userId: state.user!.uid);
            }
            return StudentHomePage(userId: state.user!.uid);
          } else {
            return LoginPage();
          }
        }
        return LoginPage();
      },
    );
  }
}

class UserLevelWrapper extends StatefulWidget {
  final String id;
  const UserLevelWrapper({Key? key, required this.id}) : super(key: key);

  @override
  _UserLevelWrapperState createState() => _UserLevelWrapperState();
}

class _UserLevelWrapperState extends State<UserLevelWrapper> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchUserDetailsEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      buildWhen: (previous, current) => current is UserDetailsFetchedState,
      builder: (context, state) {
        if (state is UserDetailsFetchedState) {
          if (state.user.isAdmin) {
            return AdminHomePage(userId: widget.id);
          } else {
            return StudentHomePage(userId: state.user.id);
          }
        }
        return Container();
      },
    );
  }
}
