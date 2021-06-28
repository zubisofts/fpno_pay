import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/pages/student/widget/empty_widget.dart';
import 'package:fpno_pay/src/pages/student/home/homepage.dart';
import 'package:fpno_pay/src/pages/student/widget/payment_item_widget.dart';
import 'package:fpno_pay/src/pages/student/widget/payment_options_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SchoolFeePage extends StatefulWidget {
  const SchoolFeePage({Key? key}) : super(key: key);

  @override
  _SchoolFeePageState createState() => _SchoolFeePageState();
}

class _SchoolFeePageState extends State<SchoolFeePage> {
  late FPNUser _user;

  @override
  void initState() {
    _user = userNotifier.value!;
    context.read<DataBloc>().add(FetchPaymentsEvent(
        paymentType: PaymentType.SchoolFee, userId: AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: BlocBuilder<DataBloc, DataState>(
            buildWhen: (previous, current) =>
                current is FetchPaymentsLoadingState ||
                current is PaymentsFetchedState,
            builder: (context, state) {
              if (state is FetchPaymentsLoadingState) {
                return Center(
                  child: SpinKitDualRing(
                    color: Theme.of(context).colorScheme.secondary,
                    size: 32.0,
                    lineWidth: 3.0,
                  ),
                );
              }
              if (state is PaymentsFetchedState) {
                List<PaymentData> payments = state.payments;
                if (payments.isNotEmpty) {
                  return ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, index) =>
                        PaymentListItemWidget(paymentData: payments[index]),
                  );
                } else {
                  return Center(child: EmptyWidget());
                }
              }
              return Container();
            },
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                showPaymentOptionDialog(context);
              },
              backgroundColor: Color(0xFF479797),
              label: Text(
                'Add New',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showPaymentOptionDialog(BuildContext context) {
    showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      expand: false,
      builder: (context) =>
          PaymentOptionsWidget(paymentType: PaymentType.SchoolFee, user: _user),
    );
  }
}
