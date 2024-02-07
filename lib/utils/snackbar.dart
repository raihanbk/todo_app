import 'package:flutter/material.dart';

void showFailureMessage(BuildContext context, {required String msg}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

void showSuccessMessage(BuildContext context, {required String msg}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
