import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/helpers/show_snack_bar.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/controllers/rides_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/models/ride_model.dart';

class CardRideHistoric extends StatefulWidget {
  final RideModel ride;
  const CardRideHistoric({Key? key, required this.ride}) : super(key: key);

  @override
  State<CardRideHistoric> createState() => _CardRideHistoricState();
}

class _CardRideHistoricState extends State<CardRideHistoric> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.grey3,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        margin: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carona do dia: ${widget.ride.rideDate!}',
                  style: GoogleFonts.openSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Motorista: ",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.ride.name!.toUpperCase(),
                      style: GoogleFonts.openSans(
                        color: AppColors.primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.ride.isCompleteRide! ? "Ida e Volta" : "Somente Ida",
                  style: GoogleFonts.openSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${widget.ride.passenger} pessoas",
                  style: GoogleFonts.openSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'R\$ ${widget.ride.totalToPay!.toStringAsFixed(2)}',
                  style: GoogleFonts.openSans(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 5,
              child: IconButton(
                onPressed: () async {
                  Widget cancelaButton = TextButton(
                    child: Text(
                      "Cancelar",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w400, fontSize: 15.0),
                    ),
                    onPressed: () {
                      Modular.to.pop();
                    },
                  );
                  Widget continuaButton = TextButton(
                    child: Text(
                      "Excluir",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w400, fontSize: 15.0),
                    ),
                    onPressed: () async {
                      try {
                        var id = Modular.get<AuthController>().userModel.id!;
                        await Modular.get<RidesController>().deleteRide(
                            idUser: id,
                            idRide: widget.ride.id!,
                            rideValue: widget.ride.totalToPay!,
                            idDriver: widget.ride.driverId!);
                        Modular.to.pop();
                        showSucessSnackBar(
                            message: 'Carona excluida com sucesso',
                            context: context);
                      } catch (e) {
                        showErrorSnackBar(
                            message: e.toString(), context: context);
                      }
                    },
                  );
                  //configura o AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text(
                      "Excluir carona",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500, fontSize: 18.0),
                    ),
                    content: Text(
                      "Deseja realmente excluir essa carona?",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w400, fontSize: 14.0),
                    ),
                    actions: [
                      cancelaButton,
                      continuaButton,
                    ],
                  );
                  //exibe o diálogo
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.red,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
