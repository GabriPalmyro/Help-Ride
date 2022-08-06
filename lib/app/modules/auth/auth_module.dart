import 'package:flutter_modular/flutter_modular.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/auth/views/auth_page.dart';
import 'package:help_ride_web/app/modules/auth/views/splash_page.dart';
import 'package:help_ride_web/app/modules/home/home_module.dart';
import 'package:help_ride_web/app/shared/services/shared_local_preferences.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory((i) => SharedLocalStorageService()),
        Bind.singleton((i) => AuthController.init(i()))
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const SplashPage()),
        ChildRoute('/auth', child: (_, __) => const AuthPage()),
        ModuleRoute('/home', module: HomeModule())
      ];
}
