import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/empty.svg',
              color: Theme.of(context).colorScheme.secondary,
              width: 150,
            ),
            // SizedBox(
            //   height: 16.0,
            // ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Oops! You seem not to have anything here...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blueGrey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
