import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fpno_pay/src/model/fee.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/pages/payment/widgets/checkout_widget.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InvoicePage extends StatelessWidget {
  final FPNUser user;
  final Fee fee;
  final level;
  final semester;
  final PaymentType type;

  InvoicePage(
      {Key? key,
      required this.user,
      required this.fee,
      required this.level,
      required this.semester,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      decimalDigits: 2,
      name: "₦",
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Fee Invoice',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.photo,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SpinKitDualRing(
                          size: 24.0,
                          lineWidth: 2,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Divider(
                height: 0.1,
                color: Colors.blueGrey[400],
              ),
              SizedBox(height: 16.0),
              Text('Application Number',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${user.appNo}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Full Name',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${user.firstName} ${user.lastName}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Email',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${user.email}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Department',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              SizedBox(width: 16.0),
              Text('${user.department}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('School',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${user.school}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Session',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${fee.session}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Payment For',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${fee.programme}-${fee.name}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Payment Type',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('FPN ${fee.programme} ${fee.name}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Text('Amount',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              // SizedBox(height: 16.0),
              Text('${currencyFormatter.format(fee.amount)}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0)),
              SizedBox(height: 16.0),
              Divider(
                height: 0.1,
                color: Colors.blueGrey[400],
              ),
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)..pop();
                    showMaterialModalBottomSheet(
                      expand: false,
                      context: context,
                      builder: (context) => CheckoutWidget(
                          paymentType: type,
                          fee: fee,
                          user: user,
                          semester: semester,
                          level: level),
                    );
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      backgroundColor: Theme.of(context).colorScheme.secondary),
                  child: Text('Proceed to Payment'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
