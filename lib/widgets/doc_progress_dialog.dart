import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class DocumentVerify extends StatelessWidget {
  DocumentVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 6.0,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(
                width: 26.0,
              ),
              const Text(
                "You will receive an email when we verify your documents and will be able to use your account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Timer.periodic(const Duration(seconds: 2), (timer) {
                      Phoenix.rebirth(context);
                    });
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(fontFamily: "Brand-regular"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
