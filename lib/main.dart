import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpno_pay/src/blocs/app/app_bloc.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/pages/auth/login_page.dart';
import 'package:fpno_pay/src/pages/intro/splashscreen.dart';
import 'package:fpno_pay/src/repository/auth_repo.dart';
import 'package:fpno_pay/src/repository/data_repo.dart';
import 'package:fpno_pay/src/util/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  // Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService _authService = AuthService();
  DataService _dataService = DataService();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<AppBloc>(
        create: (BuildContext context) => AppBloc(),
      ),
      BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
                authService: _authService,
              )),
      BlocProvider<DataBloc>(
          create: (context) => DataBloc(
                dataService: _dataService,
              )),
    ], child: AppBase());
  }
}

class AppBase extends StatefulWidget {
  @override
  _AppBaseState createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  @override
  void initState() {
    context.read<AppBloc>().add(GetThemeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        bool isDarkTheme = false;
        if (state is ThemeRetrievedState) {
          isDarkTheme = state.isDarkTheme;
        }
        return MaterialApp(
          title: 'FPNO Pay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
        );
      },
    );
  }
}
