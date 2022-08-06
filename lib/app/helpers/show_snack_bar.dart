import 'package:flutter/material.dart';
import 'package:help_ride_web/app/core/core.dart';

void showErrorSnackBar(
    {required String message, required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: AppColors.red,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSucessSnackBar(
    {required String message, required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: AppColors.sucessSnackBar,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showMessageSnackBar(
    {required String message, required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: AppColors.messageSnackBar,
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
