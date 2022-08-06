import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';

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
    await Future.delayed(const Duration(seconds: 3), () {
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
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Inicializando App...',
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
