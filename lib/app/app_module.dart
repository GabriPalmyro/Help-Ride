import 'package:flutter_modular/flutter_modular.dart';
import 'package:help_ride_web/app/modules/auth/auth_module.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: AuthModule()),
      ];
}
