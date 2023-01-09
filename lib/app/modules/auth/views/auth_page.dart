import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/helpers/show_snack_bar.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'HELP RIDE',
                style: GoogleFonts.antonio(
                  letterSpacing: 1.2,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: constraints.maxWidth > 800 ? 80 : 65,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              InkWell(
                onTap: () async {
                  try {
                    await authController.signInWithGoogle();
                    Modular.to.navigate('/home/');
                  } catch (e) {
                    showErrorSnackBar(message: e.toString(), context: context);
                  }
                },
                child: Container(
                  width: constraints.maxWidth > 800
                      ? constraints.maxWidth * 0.6
                      : constraints.maxWidth * 0.8,
                  decoration: BoxDecoration(
                    color: AppColors.grey2,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: AppColors.black.withOpacity(0.1),
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Fazer login com Google',
                        style: GoogleFonts.openSans(
                          color: AppColors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: constraints.maxWidth > 800 ? 32 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: constraints.maxWidth * 0.1,
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/800px-Google_%22G%22_Logo.svg.png',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
