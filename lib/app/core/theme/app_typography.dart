import 'package:flutter/material.dart';
import 'package:help_ride_web/app/core/core.dart';

class AppTypography {
  static TextStyle? bodyText(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1;
  }

  static TextStyle small(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 22);
  }

  static TextStyle bodyTextBold(BuildContext context, {double fontSize = 18}) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: fontSize);
  }

  static TextStyle tabBarStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        );
  }

  static TextStyle titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
          fontSize: 24,
        );
  }
}
