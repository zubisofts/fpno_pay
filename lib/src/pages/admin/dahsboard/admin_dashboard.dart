import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/pages/admin/fees_page.dart';
import 'package:fpno_pay/src/pages/student/widget/empty_widget.dart';
import 'package:fpno_pay/src/pages/student/widget/payment_item_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchAllUserPaymentsEvent(PaymentType.All));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16.0),
      child: BlocBuilder<DataBloc, DataState>(
        buildWhen: (previous, current) =>
            current is FetchAllPaymentsLoadingState ||
            current is AllPaymentsFetchState,
        builder: (context, state) {
          int numOfAcceptancePayments = 0;
          int numOfSchoolFeePayments = 0;
          int numOfTedcPayments = 0;
          int numOfMSPayments = 0;
          List<PaymentData> recentPayments = [];

          if (state is AllPaymentsFetchState) {
            List<PaymentData> payments = state.payments;
            recentPayments = state.payments.take(5).toList();
            numOfAcceptancePayments = payments
                .where((payment) => payment.type == "Acceptance Fee")
                .length;

            numOfSchoolFeePayments = payments
                .where((payment) => payment.type == "School Fee")
                .length;

            numOfTedcPayments =
                payments.where((payment) => payment.type == "TEDC Fee").length;

            numOfMSPayments = payments
                .where((payment) => payment.type == "Microsoft Fee")
                .length;
          }
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Activities',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Card(
                        elevation: 0.0,
                        color: Color(0xFF479797).withOpacity(0.2),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.event_seat_outlined,
                                color: Color(0xFF479797),
                              ),
                              Center(
                                child: Text(
                                  '$numOfAcceptancePayments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      color: Color(0xFF479797)),
                                ),
                              ),
                              Text(
                                'Acceptance Fees',
                                style: TextStyle(color: Color(0xFF479797)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        color: Color(0xFFf1675e).withOpacity(0.2),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                color: Color(0xFFf1675e),
                              ),
                              Center(
                                child: Text(
                                  '$numOfSchoolFeePayments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      color: Color(0xFFf1675e)),
                                ),
                              ),
                              Text(
                                'School Fees',
                                style: TextStyle(color: Color(0xFFf1675e)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.wysiwyg_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              Center(
                                child: Text(
                                  '$numOfTedcPayments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              Text(
                                'TEDC Fees',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0.0,
                        color: Colors.purple.withOpacity(0.2),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.account_tree_outlined,
                                color: Colors.purple,
                              ),
                              Center(
                                child: Text(
                                  '$numOfMSPayments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      color: Colors.purple),
                                ),
                              ),
                              Text(
                                'Microsoft Fees',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Payments',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FeesPage(),
                            ));
                          },
                          child: Text(
                            'View More',
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  recentPayments.isNotEmpty
                      ? Expanded(
                          child: ListView(
                            // shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: recentPayments
                                .map((p) =>
                                    PaymentListItemWidget(paymentData: p))
                                .toList(),
                          ),
                        )
                      : Center(child: EmptyWidget())
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
