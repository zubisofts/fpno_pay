import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/model/payment.dart';
import 'package:fpno_pay/src/util/my_utils.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

Future<Uint8List> generatePaymentReciept(
    PaymentData paymentData, FPNUser user) async {
  PdfPageFormat pageFormat = PdfPageFormat.a4;

  final personalDetails = <ItemContent>[
    ItemContent('APP No', user.appNo),
    ItemContent('Payment Ref', paymentData.refernceNo),
    ItemContent('Full Name', '${user.firstName} ${user.lastName}'),
    ItemContent('Sex', user.gender),
    ItemContent('Phone Number', user.phoneNumber),
    ItemContent('Address', user.address),
  ];

  final paymentDetails = <ItemContent>[
    ItemContent(
        'Amount Paid', '${_formatCurrency(paymentData.amount.toDouble())}'),
    ItemContent('Purpose Of Payment', paymentData.purpose),
    ItemContent('Level', '${paymentData.level}'),
    ItemContent('Session', paymentData.session),
    ItemContent('Date Of Payment',
        '${AppUtils.getDateFromTimestamp(paymentData.timestamp)}'),
    ItemContent('Method Of Payment', paymentData.paymentMethod),
  ];

  final reciept = Reciept(
    invoiceNumber: '982347',
    personalDetails: personalDetails,
    paymentDetails: paymentDetails,
    customerName: '${user.firstName} ${user.lastName}',
    customerAddress: '${user.address}',
    paymentInfo: '${paymentData.purpose}',
    tax: .15,
    baseColor: PdfColors.blue600,
    accentColor: PdfColors.blueGrey900,
  );

  return await reciept.buildPdf(
      pageFormat, paymentData.type, user.photo, paymentData.refernceNo);
}

class Reciept {
  Reciept({
    required this.personalDetails,
    required this.paymentDetails,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<ItemContent> personalDetails;
  final List<ItemContent> paymentDetails;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  // double get _total =>
  //     itemContents.map<double>((p) => p.total).reduce((a, b) => a + b);

  // double get _grandTotal => _total * (1 + tax);

  var neklogo;

  var _profileImage;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat, String title,
      String imgUrl, String refId) async {
    // Create a PDF document.
    final doc = pw.Document();

    neklogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/neklogo.png')).buffer.asUint8List(),
    );

    final ByteData imgData =
        await NetworkAssetBundle(Uri.parse(imgUrl)).load("");
    final Uint8List imgProfileData = imgData.buffer.asUint8List();

    _profileImage = pw.MemoryImage(imgProfileData);

    // var fbold = await PdfGoogleFonts.poppinsBold();
    // var fRegular = await PdfGoogleFonts.poppinsRegular();
    // var fItalic = await PdfGoogleFonts.poppinsItalic();

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        // pageTheme: await _buildTheme(pageFormat, fRegular, fbold, fItalic),
        // header: (context) => _buildHeader(context),
        // footer: (context) => _buildFooter(context, refId),
        build: (context) => [
          _buildHeader(context),
          pw.Center(
            child: pw.Text(
              '$title Reciept'.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 18,
                lineSpacing: 5,
                color: _darkColor,
              ),
            ),
          ),
          pw.SizedBox(height: 16.0),
          _contentPersonalDetailsTable(context),
          pw.SizedBox(height: 20),
          _contentPaymentDetailsTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context, refId),
          // _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Center(
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(flex: 4, child: pw.Image(neklogo)),
              pw.SizedBox(width: 24.0),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      width: 65,
                      height: 90,
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("#ffe4fe"),
                      ),
                      child: pw.Image(_profileImage, fit: pw.BoxFit.cover)))
            ],
          ),
        ),
        pw.SizedBox(height: 24.0)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context, String refId) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  Future<pw.PageTheme> _buildTheme(PdfPageFormat pageFormat, pw.Font base,
      pw.Font bold, pw.Font italic) async {
    // var img = await File('assets/images/logo.png').readAsBytes();
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      // buildBackground: (context) => pw.FullPage(
      //   ignoreMargins: true,
      // child: pw.Image(pw.MemoryImage(img)),
      // ),
    );
  }

  // pw.Widget _contentHeader(pw.Context context) {
  //   return pw.Row(
  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //     children: [
  //       pw.Expanded(
  //         child: pw.Container(
  //           margin: const pw.EdgeInsets.symmetric(horizontal: 20),
  //           height: 70,
  //           child: pw.FittedBox(
  //             child: pw.Text(
  //               'Total: ${_formatCurrency(_grandTotal)}',
  //               style: pw.TextStyle(
  //                 color: baseColor,
  //                 fontStyle: pw.FontStyle.italic,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       pw.Expanded(
  //         child: pw.Row(
  //           children: [
  //             pw.Container(
  //               margin: const pw.EdgeInsets.only(left: 10, right: 10),
  //               height: 70,
  //               child: pw.Text(
  //                 'Invoice to:',
  //                 style: pw.TextStyle(
  //                   color: _darkColor,
  //                   fontWeight: pw.FontWeight.bold,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //             pw.Expanded(
  //               child: pw.Container(
  //                 height: 70,
  //                 child: pw.RichText(
  //                     text: pw.TextSpan(
  //                         text: '$customerName\n',
  //                         style: pw.TextStyle(
  //                           color: _darkColor,
  //                           fontWeight: pw.FontWeight.bold,
  //                           fontSize: 12,
  //                         ),
  //                         children: [
  //                       const pw.TextSpan(
  //                         text: '\n',
  //                         style: pw.TextStyle(
  //                           fontSize: 5,
  //                         ),
  //                       ),
  //                       pw.TextSpan(
  //                         text: customerAddress,
  //                         style: pw.TextStyle(
  //                           fontWeight: pw.FontWeight.normal,
  //                           fontSize: 10,
  //                         ),
  //                       ),
  //                     ])),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  pw.Widget _contentFooter(pw.Context context, String refId) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // pw.SizedBox(height: 8.0),
              pw.Center(
                  child: pw.Container(
                height: 60,
                width: 60,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: 'Reference No# $refId',
                  drawText: false,
                ),
              )),
              pw.SizedBox(height: 8.0),
              pw.Center(
                child: pw.Text(
                  'Thank you for choosing Federal Polytechnic Nekede.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              )
              // pw.Container(
              //   margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
              //   child: pw.Text(
              //     'Payment Info:',
              //     style: pw.TextStyle(
              //       color: baseColor,
              //       fontWeight: pw.FontWeight.bold,
              //     ),
              //   ),
              // ),
              // pw.Text(
              //   paymentInfo,
              //   style: const pw.TextStyle(
              //     fontSize: 8,
              //     lineSpacing: 5,
              //     color: _darkColor,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentPersonalDetailsTable(pw.Context context) {
    const tableHeaders = [
      'Personal Details',
      '',
      // 'Price',
      // 'Quantity',
      // 'Total'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      oddRowDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#eeeeee")),
      headerHeight: 20,
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        // 2: pw.Alignment.centerRight,
        // 3: pw.Alignment.center,
        // 4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 12,
      ),
      rowDecoration: pw.BoxDecoration(
          // border: pw.Border(
          //   bottom: pw.BorderSide(
          //     color: accentColor,
          //     width: .5,
          //   ),
          // ),
          ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        personalDetails.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => personalDetails[row].getIndex(col),
        ),
      ),
    );
  }

  pw.Widget _contentPaymentDetailsTable(pw.Context context) {
    const tableHeaders = [
      'Payment Details',
      '',
      // 'Price',
      // 'Quantity',
      // 'Total'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 20,
      oddRowDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#eeeeee")),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        // 2: pw.Alignment.centerRight,
        // 3: pw.Alignment.center,
        // 4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 12,
      ),
      // rowDecoration: pw.BoxDecoration(
      //   border: pw.Border(
      //     bottom: pw.BorderSide(
      //       color: accentColor,
      //       width: .5,
      //     ),
      //   ),
      // ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        paymentDetails.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => paymentDetails[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    decimalDigits: 0,
    name: "NGN ",
  );
  return '${currencyFormatter.format(amount)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

class ItemContent {
  const ItemContent(
    this.title,
    this.content,
  );

  final String title;
  final String content;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return title;
      case 1:
        return content;
      case 2:
    }
    return '';
  }
}
