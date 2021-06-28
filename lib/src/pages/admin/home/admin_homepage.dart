import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fpno_pay/src/blocs/app/app_bloc.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/fee.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/pages/admin/dahsboard/admin_dashboard.dart';
import 'package:fpno_pay/src/pages/student/acceptance_fees_page.dart';
import 'package:fpno_pay/src/pages/student/microsoft_fee_page.dart';
import 'package:fpno_pay/src/pages/student/profile/profile_page.dart';
import 'package:fpno_pay/src/pages/student/school_fees_page.dart';
import 'package:fpno_pay/src/pages/student/tedc_feePage.dart';
import 'package:fpno_pay/src/util/constants.dart';
import 'package:fpno_pay/src/util/my_utils.dart';

final ValueNotifier<FPNUser?> userNotifier = ValueNotifier(null);

class AdminHomePage extends StatefulWidget {
  final String userId;

  const AdminHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  FPNUser? user;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(
    //     Theme.of(context).appBarTheme.systemOverlayStyle!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Theme.of(context)
        .appBarTheme
        .systemOverlayStyle!
        .copyWith(statusBarColor: Colors.transparent));
    context.read<DataBloc>().add(FetchUserDetailsEvent(widget.userId));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // drawer: ValueListenableBuilder<FPNUser?>(
      //     valueListenable: userNotifier,
      //     builder: (context, user, child) {
      //       return Drawer(
      //         child: Container(
      //           color: Colors.white,
      //           child: DrawerWidget(
      //             user: user!,
      //           ),
      //         ),
      //       );
      //       // if (user != null) {
      //       //   return DrawerWidget(
      //       //     user: user,
      //       //   );
      //       // } else {
      //       //   return Container(
      //       //     color: Colors.white,
      //       //   );
      //       // }
      //     }),
      body: BlocConsumer<DataBloc, DataState>(
        buildWhen: (previous, current) => current is UserDetailsFetchedState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UserDetailsFetchedState) {
            userNotifier.value = state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 34.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // AnimatedIcon(
                    //   icon: AnimatedIcons.menu_close,
                    //   progress: null,),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                      ),
                    ),
                    Text('Admin Dashboard',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        // GFIconBadge(
                        //   child: GFIconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.notifications,
                        //         color: Theme.of(context).iconTheme.color),
                        //     type: GFButtonType.transparent,
                        //   ),
                        //   counterChild: GFBadge(
                        //     child: Text("2"),
                        //   ),
                        // ),
                        PopupMenuButton(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              // onTap: () {
                              //   context.read<AuthBloc>().add(LogoutEvent());
                              // },
                              borderRadius: BorderRadius.circular(50),
                              // child: SizedBox.shrink(),
                              child: CircleAvatar(
                                radius: 16.0,
                                backgroundImage: CachedNetworkImageProvider(
                                  state.user.photo,
                                ),
                              ),
                            ),
                          ),
                          // initialValue: 0,
                          onSelected: (value) {
                            if (value == 0) {
                              showAddFeeDialog(context);
                            } else if (value == 1) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(user: state.user),
                              ));
                            } else {
                              context.read<AuthBloc>().add(LogoutUserEvent());
                            }
                          },
                          itemBuilder: (context) => [
                            // PopupMenuItem(
                            //   value: 0,
                            //   textStyle: TextStyle(
                            //       color: Theme.of(context).colorScheme.onPrimary),
                            //   child: Text(
                            //     'Settngs',
                            //   ),
                            // ),
                            PopupMenuItem(
                              value: 0,
                              textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              child: Text('Add New Fee'),
                            ),
                            PopupMenuItem(
                              value: 1,
                              textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              child: Text('Profile'),
                            ),
                            PopupMenuItem(
                              value: 2,
                              textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              child: Text('Logout'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(child: AdminDashboard())
              ],
            );
          }
          return Center(
            child: SpinKitDualRing(
                size: 32.0,
                lineWidth: 2,
                color: Theme.of(context).colorScheme.secondary),
          );
        },
      ),
    );
  }

  void showAddFeeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: NewFeeForm(),
      ),
    );
  }
}

class NewFeeForm extends StatefulWidget {
  const NewFeeForm({Key? key}) : super(key: key);

  @override
  _NewFeeFormState createState() => _NewFeeFormState();
}

class _NewFeeFormState extends State<NewFeeForm> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String selectedProgramme = '';

  String selectedSession = '';

  var amountTextController = TextEditingController();

  var feetTypes = ["Acceptance Fee", "School Fee", "TEDC Fee", "Microsoft Fee"];

  String selectedType = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            // Pressing space in the field will now move to the next field.
            LogicalKeySet(LogicalKeyboardKey.enter): const NextFocusIntent(),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                      onChanged: (value) {
                        selectedType = value!;
                      },
                      decoration: Constants.inputDecoration(context)
                          .copyWith(hintText: 'Select Fee Type'),
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      items: feetTypes
                          .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type,
                              )))
                          .toList()),
                  SizedBox(
                    height: 16.0,
                  ),
                  DropdownButtonFormField<String>(
                      onChanged: (value) {
                        selectedProgramme = value!;
                      },
                      decoration: Constants.inputDecoration(context)
                          .copyWith(hintText: 'Select Programme'),
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      items: (AppUtils.programmes)
                          .map((programme) => DropdownMenuItem(
                              value: programme,
                              child: Text(
                                programme,
                              )))
                          .toList()),
                  SizedBox(
                    height: 16.0,
                  ),
                  DropdownButtonFormField<String>(
                      onChanged: (value) {
                        selectedSession = value!;
                      },
                      decoration: Constants.inputDecoration(context)
                          .copyWith(hintText: 'Select Session'),
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      items: AppUtils.sessions
                          .map((ss) => DropdownMenuItem(
                              value: ss,
                              child: Text(
                                ss,
                              )))
                          .toList()),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    validator:
                        RequiredValidator(errorText: "Please enter an amount"),
                    onChanged: (v) {},
                    controller: amountTextController,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    inputFormatters: [CurrencyTextInputFormatter(symbol: '₦')],
                    cursorHeight: 24,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    decoration: Constants.inputDecoration(context).copyWith(
                        hintText: 'Fee amount',
                        prefixIcon: Icon(Icons.money, color: Colors.blueGrey)),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFFf1675e)),
                        ),
                      ),
                      BlocListener<DataBloc, DataState>(
                        listenWhen: (previous, current) =>
                            current is FeeAddedState ||
                            current is AddFeeErrorState ||
                            current is AddFeeLoadingSatate,
                        listener: (context, state) {
                          if (state is FeeAddedState) {
                            Navigator.of(context).pop();
                            AppUtils.showSuccessDialog(context, state.message,
                                onClose: () {
                              Navigator.of(context)..pop()..pop();
                            });
                          }

                          if (state is AddFeeErrorState) {
                            Navigator.of(context).pop();
                            AppUtils.showErrorDialog(context, state.error,
                                onClose: () => Navigator.of(context).pop());
                          }

                          if (state is AddFeeLoadingSatate) {
                            AppUtils.showLoaderDialog(context, 'Adding fee');
                          }
                        },
                        child: TextButton(
                          style: TextButton.styleFrom(),
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              if (selectedType.isEmpty) {
                                AppUtils.showErrorDialog(
                                    context, "You must select payment type.",
                                    onClose: () {
                                  Navigator.of(context).pop();
                                });
                              } else if (selectedProgramme.isEmpty) {
                                AppUtils.showErrorDialog(
                                    context, "You must select a programme.",
                                    onClose: () {
                                  Navigator.of(context).pop();
                                });
                              } else if (selectedSession.isEmpty) {
                                AppUtils.showErrorDialog(
                                    context, "You must select a session.",
                                    onClose: () {
                                  Navigator.of(context).pop();
                                });
                              } else {
                                int amount = int.parse(amountTextController.text
                                    .replaceAll('₦', '')
                                    .replaceAll(',', '')
                                    .replaceAll('.', ''));
                                context.read<DataBloc>().add(AddNewFeeEvent(Fee(
                                    id: '',
                                    name: selectedType,
                                    amount: amount,
                                    type: selectedType,
                                    session: selectedSession,
                                    programme: selectedProgramme)));
                              }
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
