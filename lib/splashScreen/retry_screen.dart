import 'package:flutter/material.dart';

class RetryPage extends StatelessWidget {
  const RetryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children:  const [
            Text("Please check your internet connection", style: TextStyle(
              fontSize: 20,
              fontFamily: "Brand-Regular",

            )),

          ],
        ),
      ),
    );
  }
}
