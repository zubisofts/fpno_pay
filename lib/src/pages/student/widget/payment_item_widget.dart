import 'package:flutter/material.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/pages/student/reciept_preview_page.dart';
import 'package:fpno_pay/src/util/my_utils.dart';
import 'package:intl/intl.dart';

class PaymentListItemWidget extends StatelessWidget {
  final PaymentData paymentData;

  const PaymentListItemWidget({Key? key, required this.paymentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "₦",
    );
    return Card(
        elevation: 6.0,
        // margin: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${paymentData.level}',
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            '${paymentData.semester} Semester',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        '${AppUtils.getDateFromTimestamp(paymentData.timestamp)} Semester',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/images/wallet.png',
                    width: 50,
                  )
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currencyFormatter.format(paymentData.amount)}',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            RecieptPreviewPage(paymentData: paymentData),
                      ));
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: Text(
                      'View Receipt',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
