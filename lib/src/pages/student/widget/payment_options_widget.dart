import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';

import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/pages/student/invoice_page.dart';
import 'package:fpno_pay/src/util/constants.dart';
import 'package:fpno_pay/src/util/my_utils.dart';

class PaymentOptionsWidget extends StatefulWidget {
  final PaymentType paymentType;
  final FPNUser user;

  PaymentOptionsWidget({
    Key? key,
    required this.user,
    required this.paymentType,
  }) : super(key: key);

  @override
  _PaymentOptionsWidgetState createState() => _PaymentOptionsWidgetState();
}

class _PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {
  String selectedLevel = '';

  String selectedSession = '';

  List<String> HNDLevels = ["HND I", "HND II"];

  List<String> NDLevels = ["ND I", "ND II"];

  String selectedSemester = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${typeValues.reverse[widget.paymentType]}',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          DropdownButtonFormField<String>(
              onChanged: (value) {
                selectedLevel = value!;
              },
              decoration: Constants.inputDecoration(context)
                  .copyWith(hintText: 'Select Year'),
              dropdownColor: Theme.of(context).cardColor,
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.onPrimary),
              items: (widget.user.programme.split(" ").first == "HND"
                      ? HNDLevels
                      : NDLevels)
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
                selectedSemester = value!;
              },
              decoration: Constants.inputDecoration(context)
                  .copyWith(hintText: 'Select Semester'),
              dropdownColor: Theme.of(context).cardColor,
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.onPrimary),
              items: AppUtils.semesters
                  .map((semester) => DropdownMenuItem(
                      value: semester,
                      child: Text(
                        semester,
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
                  fontSize: 14, color: Theme.of(context).colorScheme.onPrimary),
              items: AppUtils.sessions
                  .map((ss) => DropdownMenuItem(
                      value: ss,
                      child: Text(
                        ss,
                      )))
                  .toList()),
          BlocBuilder<DataBloc, DataState>(
            builder: (context, state) {
              return SizedBox(
                height: 16.0,
              );
            },
          ),
          BlocConsumer<DataBloc, DataState>(
            listener: (context, state) {
              if (state is FetchFeeErrorState) {
                AppUtils.showErrorDialog(context, state.error, onClose: () {
                  Navigator.of(context).pop();
                });
              }

              if (state is FeeDataFetchedState) {
                // AppUtils.showSuccessDialog(context, state.fee.toJson(),
                //     onClose: () {
                //   Navigator.of(context).pop();
                // });
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoicePage(
                        user: widget.user,
                        fee: state.fee,
                        level:selectedLevel,
                        semester:selectedSemester,
                        type:widget.paymentType
                      ),
                    ));
              }
            },
            builder: (context, state) {
              return MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                elevation: 1.0,
                color: Theme.of(context).colorScheme.secondary,
                disabledColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is FetchFeeLoadingState
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: SpinKitDualRing(
                              color: Colors.white,
                              lineWidth: 2,
                              size: 18.0,
                            ),
                          )
                        : SizedBox.shrink(),
                    Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: state is FetchFeeLoadingState
                    ? null
                    : () {
                        if (selectedLevel.isEmpty) {
                          AppUtils.showErrorDialog(
                              context, "Please select your departmental level",
                              onClose: () {
                            Navigator.of(context).pop();
                          });
                          return;
                        } else if (selectedSemester.isEmpty) {
                          AppUtils.showErrorDialog(
                              context, "Please select your semester",
                              onClose: () {
                            Navigator.of(context).pop();
                          });
                          return;
                        } else if (selectedSession.isEmpty) {
                          AppUtils.showErrorDialog(
                              context, "Please select your session",
                              onClose: () {
                            Navigator.of(context).pop();
                          });
                          return;
                        }
                        context.read<DataBloc>().add(FetchFeeDataEvent(
                            programme: widget.user.programme,
                            session: selectedSession,
                            type: typeValues.reverse[widget.paymentType]!));
                      },
              );
            },
          )
        ],
      ),
    );
  }
}
