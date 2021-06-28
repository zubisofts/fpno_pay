import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/repository/data_repo.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class RecieptPreviewPage extends StatefulWidget {
  final PaymentData paymentData;

  const RecieptPreviewPage({Key? key, required this.paymentData})
      : super(key: key);

  @override
  _RecieptPreviewPageState createState() => _RecieptPreviewPageState();
}

class _RecieptPreviewPageState extends State<RecieptPreviewPage> {
  @override
  void initState() {
    context
        .read<DataBloc>()
        .add(FetchUserDetailsEvent(widget.paymentData.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FPNO Reciept Viewer',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: BlocConsumer<DataBloc, DataState>(
        buildWhen: (previous, current) =>
            current is UserDetailsLoadingState ||
            current is UserDetailsErrorState ||
            current is UserDetailsFetchedState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UserDetailsFetchedState) {
            return FutureBuilder<Uint8List?>(
              future:
                  DataService().generateReciept(widget.paymentData, state.user),
              builder: (context, snapshot) {
                // PdfPageFormat pageFormat = PdfPageFormat(
                //     MediaQuery.of(context).size.width,
                //     MediaQuery.of(context).size.height);
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Error loading preview',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    );
                  }
                  return PdfPreview(
                      initialPageFormat: PdfPageFormat.a4,
                      build: (format) {
                        // print(format);
                        return snapshot.data!;
                      });
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitDualRing(
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32.0,
                        lineWidth: 3,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        'Loading Preview',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
