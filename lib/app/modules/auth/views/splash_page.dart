import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    authState();
  }

  Future authState() async {
    await Future.delayed(const Duration(seconds: 5)).then((_) {
      var status = Modular.get<AuthController>().status;
      debugPrint(status.toString());
      if (status == Status.unauthenticated) {
        Modular.to.navigate('/auth');
      } else if (status == Status.authenticated) {
        Modular.to.navigate('/home/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.discreteCircle(
                  color: AppColors.grey3,
                  size: 50.0,
                  secondRingColor: AppColors.primaryColor,
                  thirdRingColor: AppColors.primaryColor.withOpacity(.8)),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  'Buscando suas informações',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400, fontSize: 16.0),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
