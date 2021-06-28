import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/payment.dart';

class StudentDashbaord extends StatefulWidget {
  const StudentDashbaord({Key? key}) : super(key: key);

  @override
  _StudentDashbaordState createState() => _StudentDashbaordState();
}

class _StudentDashbaordState extends State<StudentDashbaord> {
  @override
  void initState() {
    context.read<DataBloc>().add(FetchPaymentsEvent(
        paymentType: PaymentType.All, userId: AuthBloc.uid!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              foregroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8.0)),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/card.jpeg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FPNO Pay',
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Payment made easy',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16.0,
                      bottom: 16.0,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Summary',
            style: TextStyle(
                fontSize: 16.0, color: Theme.of(context).colorScheme.onPrimary),
          ),
          SizedBox(
            height: 8.0,
          ),
          BlocBuilder<DataBloc, DataState>(
            buildWhen: (previous, current) =>
                current is FetchPaymentsLoadingState ||
                current is PaymentsFetchedState,
            builder: (context, state) {
              int numOfAcceptancePayments = 0;
              int numOfSchoolFeePayments = 0;
              int numOfTedcPayments = 0;
              int numOfMSPayments = 0;
              if (state is PaymentsFetchedState) {
                List<PaymentData> payments = state.payments;
                numOfAcceptancePayments = payments
                    .where((payment) => payment.type == "Acceptance Fee")
                    .length;

                numOfSchoolFeePayments = payments
                    .where((payment) => payment.type == "School Fee")
                    .length;

                numOfTedcPayments = payments
                    .where((payment) => payment.type == "TEDC Fee")
                    .length;

                numOfMSPayments = payments
                    .where((payment) => payment.type == "Microsoft Fee")
                    .length;
              }
              return Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  physics: BouncingScrollPhysics(),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
