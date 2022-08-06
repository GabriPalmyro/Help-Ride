import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:help_ride_web/app/core/theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Help Ride',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
