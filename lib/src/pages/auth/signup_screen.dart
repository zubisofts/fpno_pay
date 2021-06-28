import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/pages/auth/widget/gender_selection_widget.dart';
import 'package:fpno_pay/src/util/constants.dart';
import 'package:fpno_pay/src/util/my_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController fnameTextController = TextEditingController();
  TextEditingController lnameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController appNoTextController = TextEditingController();
  bool _formValidated = false;

  String gender = 'Male';

  String selectedDepartment = '';

  String selectedSchool = '';

  String selectedProgramme = '';

  void _validate() {
    // setState(() {
    _formValidated = _form.currentState!.validate();
    if (_formValidated) {
      _form.currentState!.save();
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(32.0),
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              // SvgPicture.asset('assets/images/mobile_login.svg',
              //     color: Theme.of(context).colorScheme.secondary,
              //     colorBlendMode: BlendMode.modulate,
              //     width: 200,
              //     semanticsLabel: 'A red up arrow'),
              SizedBox(height: 16.0),
              Text("Let's get started",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text(
                  'Create an account to FPNO Pay on unlock your way to seemless school fees paymentment journey',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).colorScheme.onPrimary)),
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
                        // Form.of(primaryFocus!.context!)!.save();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'This field is required'),
                            onChanged: (v) {
                              // _validate();
                            },
                            keyboardType: TextInputType.text,
                            controller: appNoTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'App No',
                                    prefixIcon: Icon(Icons.confirmation_number,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'This field is required'),
                            onChanged: (v) {
                              // _validate();
                            },
                            keyboardType: TextInputType.name,
                            controller: fnameTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'First Name',
                                    prefixIcon: Icon(Icons.person,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'This field is required'),
                            onChanged: (v) {
                              // _validate();
                            },
                            keyboardType: TextInputType.name,
                            controller: lnameTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'Last Name',
                                    prefixIcon: Icon(Icons.person,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          GenderSelectionWidget(
                              onGenderSelected: (selectedGender) {
                            gender = selectedGender;
                          }),
                          SizedBox(
                            height: 16.0,
                          ),
                          DropdownButtonFormField<String>(
                              onChanged: (value) {
                                selectedDepartment = value!;
                              },
                              decoration: Constants.inputDecoration(context)
                                  .copyWith(hintText: 'Select Department'),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              items: AppUtils.departments
                                  .map((dept) => DropdownMenuItem(
                                      value: dept, child: Text(dept)))
                                  .toList()),
                          SizedBox(
                            height: 16.0,
                          ),
                          DropdownButtonFormField<String>(
                              onChanged: (value) {
                                selectedSchool = value!;
                              },
                              isExpanded: true,
                              decoration: Constants.inputDecoration(context)
                                  .copyWith(hintText: 'Select School'),
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              // hint: Text(
                              //   'Select Category',
                              //   style: TextStyle(
                              //       color: Theme.of(context).colorScheme.onPrimary),
                              // ),
                              items: AppUtils.schools
                                  .map((school) => DropdownMenuItem(
                                      value: school,
                                      child: Text(
                                        school,
                                      )))
                                  .toList()),
                          SizedBox(
                            height: 16.0,
                          ),
                          DropdownButtonFormField<String>(
                              onChanged: (value) {
                                selectedProgramme = value!;
                              },
                              // // value: selectedCategory,
                              // validator: (v) {
                              //   if (v!.isEmpty) {
                              //     return 'Please select category';
                              //   }
                              // },
                              // dropdownColor: Theme.of(context).cardColor,
                              decoration: Constants.inputDecoration(context)
                                  .copyWith(hintText: 'Select Programme'),
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              // hint: Text(
                              //   'Select Category',
                              //   style: TextStyle(
                              //       color: Theme.of(context).colorScheme.onPrimary),
                              // ),
                              items: AppUtils.programmes
                                  .map((programme) => DropdownMenuItem(
                                      value: programme,
                                      child: Text(
                                        programme,
                                      )))
                                  .toList()),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: 'This field is required'),
                            onChanged: (v) {
                              // _validate();
                            },
                            keyboardType: TextInputType.streetAddress,
                            controller: addressTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'Address',
                                    prefixIcon: Icon(Icons.person,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "This field is required";
                              }
                            },
                            onChanged: (v) {
                              _validate();
                            },
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            controller: phoneTextController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'Phone Number',
                                    prefixIcon: Icon(Icons.phone,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "This field is required"),
                              EmailValidator(
                                  errorText: "Please enter a valid email")
                            ]),
                            onChanged: (v) {
                              _validate();
                            },
                            controller: emailTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            cursorHeight: 24,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
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
                              // _validate();
                            },
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                            controller: passwordTextController,
                            cursorColor:
                                Theme.of(context).colorScheme.secondary,
                            obscureText: true,
                            cursorHeight: 24.0,
                            decoration: Constants.inputDecoration(context)
                                .copyWith(
                                    hintText: 'Password',
                                    prefixIcon: Icon(Icons.lock,
                                        color: Colors.blueGrey)),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is SignupUserErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${state.error}')));
                              }

                              if (state is UserSignedUpState) {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        title: 'Congratualtions',
                                        body: Text(
                                          'Account created successfully!',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        dismissOnBackKeyPress: false,
                                        dismissOnTouchOutside: false,
                                        btnOkText: 'Got It!',
                                        dialogBackgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        btnOkColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        btnOkOnPress: () {
                                          // Navigator.of(context).pop();
                                          // Navigator.of(context).pushReplacement(
                                          //     MaterialPageRoute(
                                          //   builder: (context) => HomePage(userId: '',),
                                          // ));
                                        },
                                        padding: EdgeInsets.all(16.0))
                                    .show();

                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //     content: Text(
                                //         'Your account has been created successfully')));

                              }
                            },
                            builder: (context, state) {
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
                                      borderRadius: BorderRadius.circular(8.0)),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  // Theme.of(context).colorScheme.secondary,
                                  onPressed: state is SignUpLoadingState
                                      ? null
                                      : () {
                                          if (_form.currentState!.validate()) {
                                            if (selectedDepartment.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Please select your department$selectedDepartment')));
                                            } else if (selectedSchool.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Please select your school')));
                                            } else if (selectedProgramme
                                                .isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Please select your programme')));
                                            } else {
                                              context.read<AuthBloc>().add(
                                                    SignUpEvent(
                                                        user: FPNUser(
                                                            id: "",
                                                            firstName: fnameTextController
                                                                .text,
                                                            lastName:
                                                                lnameTextController
                                                                    .text,
                                                            email:
                                                                emailTextController
                                                                    .text,
                                                            phoneNumber:
                                                                phoneTextController
                                                                    .text,
                                                            photo: gender == 'Male'
                                                                ? 'https://firebasestorage.googleapis.com/v0/b/ni-trades.appspot.com/o/images%2Fbusinessman-131964752420034311.png?alt=media&token=9943056f-97e3-485f-9ddc-846f7eda8e6f'
                                                                : 'https://firebasestorage.googleapis.com/v0/b/ni-trades.appspot.com/o/images%2Fbusinesswoman-131964752427078920.png?alt=media&token=6ed9d82b-69e6-4145-bbfb-82df150ab4ab',
                                                            address:
                                                                addressTextController
                                                                    .text,
                                                            gender: gender,
                                                            createdAt: DateTime
                                                                    .now()
                                                                .millisecondsSinceEpoch,
                                                            appNo:
                                                                appNoTextController
                                                                    .text,
                                                            school:
                                                                selectedSchool,
                                                            department:
                                                                selectedDepartment,
                                                            programme:
                                                                selectedProgramme, 
                                                                isAdmin: false),
                                                        password:
                                                            passwordTextController
                                                                .text,
                                                                ),
                                                  );
                                            }
                                          }
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (state is SignUpLoadingState)
                                          ? SpinKitDualRing(
                                              size: 24,
                                              lineWidth: 2,
                                              color: Colors.white)
                                          : SizedBox.shrink(),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Text(
                                          (state is SignUpLoadingState)
                                              ? 'Creating Account'
                                              : 'Create Account',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ));
                            },
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Already have an account? Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
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
    );
  }
}
