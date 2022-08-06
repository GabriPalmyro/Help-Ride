import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/controllers/rides_controller.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            curve: Curves.bounceIn,
            child: Column(
              children: [
                Text(
                  'Help Ride Web App',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: AppColors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    AppTexts.versionApp,
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Perfil'),
            leading: const Icon(Icons.person),
            onTap: () {
              Modular.to.pushNamed('profile');
            },
          ),
          ListTile(
            title: const Text('Histórico'),
            leading: const Icon(Icons.history),
            onTap: () async {
              var id = Modular.get<AuthController>().userModel.id!;
              await Modular.get<RidesController>()
                  .getMyHistoricOfRides(idUser: id);
              Modular.to.pushNamed('historic');
            },
          ),
          if (authController.userModel.isDriver!) ...[
            ListTile(
              title: const Text('A receber'),
              leading: const Icon(Icons.monetization_on_rounded),
              onTap: () {
                Modular.to.pushNamed('receivable');
              },
            ),
          ],
          ListTile(
            title: const Text('Deslogar'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await Modular.get<AuthController>().signOut();
              Modular.to.navigate('/auth');
            },
          ),
        ],
      ),
    );
  }
}
