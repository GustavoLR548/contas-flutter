import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(
              height: 25,
            ),
            CircularProgressIndicator(
              strokeWidth: 5.0,
            )
          ],
        ),
      ),
    );
  }
}
