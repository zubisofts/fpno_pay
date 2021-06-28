import 'package:flutter/material.dart';
import 'package:fpno_pay/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then(
        (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Wrapper(),
            )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
            SizedBox(
              height: 32.0,
            ),
            Text(
              'FPNO Pay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                // fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
