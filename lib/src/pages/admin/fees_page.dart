import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/pages/student/widget/empty_widget.dart';
import 'package:fpno_pay/src/pages/student/widget/payment_item_widget.dart';
import 'package:fpno_pay/src/util/constants.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({Key? key}) : super(key: key);

  @override
  _FeesPageState createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  var txtSearchTextController = TextEditingController();

  // late FPNUser _user;

  @override
  void initState() {
    // _user = userNotifier.value!;
    context.read<DataBloc>().add(FetchAllUserPaymentsEvent(PaymentType.All));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payments',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        elevation: 0.0,
        actions: [
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
                child:
                    IconButton(onPressed: null, icon: Icon(Icons.filter_list)),
              ),
            ),
            // initialValue: 0,
            onSelected: (value) {
              if (value == 0) {
                context
                    .read<DataBloc>()
                    .add(FetchAllUserPaymentsEvent(PaymentType.AcceptanceFee));
              } else if (value == 1) {
                context
                    .read<DataBloc>()
                    .add(FetchAllUserPaymentsEvent(PaymentType.SchoolFee));
              } else if (value == 2) {
                context
                    .read<DataBloc>()
                    .add(FetchAllUserPaymentsEvent(PaymentType.TEDC));
              } else if (value == 3) {
                context
                    .read<DataBloc>()
                    .add(FetchAllUserPaymentsEvent(PaymentType.Microsoft));
              } else {
                context
                    .read<DataBloc>()
                    .add(FetchAllUserPaymentsEvent(PaymentType.All));
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
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                child: Text('Acceptance Fee'),
              ),
              PopupMenuItem(
                value: 1,
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                child: Text('School Fees'),
              ),
              PopupMenuItem(
                value: 2,
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                child: Text('TEDC Fees'),
              ),
              PopupMenuItem(
                value: 3,
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                child: Text('Microsoft Fees'),
              ),
              PopupMenuItem(
                value: 4,
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                child: Text('All Fees'),
              )
            ],
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                validator: RequiredValidator(
                    errorText: "Please enter reciept ref no."),
                onChanged: (v) {
                  context.read<DataBloc>().add(SearchUserPaymentsEvent(v));
                },
                controller: txtSearchTextController,
                cursorColor: Theme.of(context).colorScheme.secondary,
                cursorHeight: 24,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                decoration: Constants.inputDecoration(context).copyWith(
                    hintText: 'Search payment by Ref No.',
                    suffixIcon: Icon(Icons.search, color: Colors.blueGrey)),
              ),
            ),
            Expanded(
                child: BlocBuilder<DataBloc, DataState>(
              buildWhen: (previous, current) =>
                  current is AllPaymentsFetchState ||
                  current is FetchAllPaymentsLoadingState,
              builder: (context, state) {
                if (state is FetchAllPaymentsLoadingState) {
                  return Center(
                    child: SpinKitDualRing(
                      color: Theme.of(context).colorScheme.secondary,
                      size: 32.0,
                      lineWidth: 3.0,
                    ),
                  );
                }
                if (state is AllPaymentsFetchState) {
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
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: FloatingActionButton.extended(
            //     onPressed: () {
            //       showPaymentOptionDialog(context);
            //     },
            //     backgroundColor: Color(0xFF479797),
            //     label: Text(
            //       'Add New',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     icon: Icon(
            //       Icons.add,
            //       color: Colors.white,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // void showPaymentOptionDialog(BuildContext context) {
  //   showBarModalBottomSheet(
  //     context: context,
  //     backgroundColor: Theme.of(context).cardColor,
  //     expand: false,
  //     builder: (context) => PaymentOptionsWidget(
  //         paymentType: PaymentType.AcceptanceFee, user: _user),
  //   );
  // }
}
