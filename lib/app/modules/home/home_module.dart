import 'package:flutter_modular/flutter_modular.dart';
import 'package:help_ride_web/app/modules/home/modules/profile/controllers/profile_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/profile/views/profile_page.dart';
import 'package:help_ride_web/app/modules/home/modules/receivable/controllers/receivable_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/receivable/views/receivable_page.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/controllers/rides_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/views/rides_page.dart';
import 'package:help_ride_web/app/modules/home/views/home/home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton((i) => ProfileController()),
        Bind.singleton((i) => RidesController()),
        Bind.singleton((i) => ReceivableController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => const HomePage()),
        ChildRoute('/profile',
            child: (_, __) => const ProfilePage(),
            transition: TransitionType.rightToLeft),
        ChildRoute('/profile',
            child: (_, __) => const ProfilePage(),
            transition: TransitionType.rightToLeft),
        ChildRoute('/historic',
            child: (_, __) => const RidePage(),
            transition: TransitionType.rightToLeft),
        ChildRoute('/receivable',
            child: (_, __) => const ReceivablePage(),
            transition: TransitionType.rightToLeft),
      ];
}
