import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:help_ride_web/app/app_module.dart';
import 'package:help_ride_web/app/app_widget.dart';
import 'package:help_ride_web/app/helpers/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization;
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
