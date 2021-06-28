import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/pages/auth/signup_screen.dart';
import 'package:fpno_pay/src/util/constants.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool _formValidated = false;
  bool isPasswordVisible = true;

  void _validate() {
    setState(() {
      _formValidated = _form.currentState!.validate();
      if (_formValidated) {
        _form.currentState!.save();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     Theme.of(context).appBarTheme.systemOverlayStyle!);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
                  // SizedBox(height: 16.0),
                  Text('Welcome',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      'Login to get started making your school payments seemless today on FPNO Pay',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                  SizedBox(height: 32.0),
                  Form(
                    child: Shortcuts(
                      shortcuts: <LogicalKeySet, Intent>{
                        // Pressing space in the field will now move to the next field.
                        LogicalKeySet(LogicalKeyboardKey.enter):
                            const NextFocusIntent(),
                      },
                      child: FocusTraversalGroup(
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: _form,
                          onChanged: () {
                            Form.of(primaryFocus!.context!)!.save();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                validator: EmailValidator(
                                    errorText: "Please enter a valid email"),
                                onChanged: (v) {
                                  _validate();
                                },
                                controller: emailTextController,
                                cursorColor:
                                    Theme.of(context).colorScheme.secondary,
                                cursorHeight: 24,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                                decoration: Constants.inputDecoration(context)
                                    .copyWith(
                                        hintText: 'Email Address',
                                        prefixIcon: Icon(Icons.email,
                                            color: Colors.blueGrey)),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'password is required'),
                                  MinLengthValidator(5,
                                      errorText:
                                          'Password must be at least 5 digits long'),
                                ]),
                                onChanged: (v) {
                                  _validate();
                                },
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                                controller: passwordTextController,
                                cursorColor:
                                    Theme.of(context).colorScheme.secondary,
                                obscureText: isPasswordVisible,
                                cursorHeight: 24.0,
                                decoration:
                                    Constants.inputDecoration(context).copyWith(
                                  hintText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blueGrey,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: !isPasswordVisible
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Colors.grey,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //             ForgotPasswordScreen()));
                                    },
                                    child: Text('Forgot password?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                if (state is LoginUserErrorState) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('${state.error}'),
                                  ));
                                }
                                if (state is UserLoggedInState) {
                                  // Navigator.of(context).pushReplacement(
                                  //   PageTransition(
                                  //       child: HomePage(),
                                  //       type: PageTransitionType.rotate),
                                  // );
                                }
                              }, builder: (context, state) {
                                return MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    elevation: 1.0,
                                    disabledColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 18.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    // Theme.of(context).colorScheme.secondary,
                                    onPressed: state is LoginUserLoadingState
                                        ? null
                                        : () {
                                            context.read<AuthBloc>().add(
                                                LoginUserEvent(
                                                    email: emailTextController
                                                        .text,
                                                    password:
                                                        passwordTextController
                                                            .text));
                                          },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        state is LoginUserLoadingState
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SpinKitDualRing(
                                                      size: 24,
                                                      lineWidth: 2,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 16.0,
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink(),
                                        Text('Login',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ));
                              }),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push((PageTransition(
                                        child: SignupScreen(),
                                        type: PageTransitionType.leftToRight,
                                      )));
                                    },
                                    child: Text(
                                        "Don't have an account? Create one here",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is LoginUserLoadingState) {
                return InkWell(
                  onTap: null,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              }
              return SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
