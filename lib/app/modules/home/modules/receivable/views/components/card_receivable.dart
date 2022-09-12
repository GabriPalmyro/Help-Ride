import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/helpers/show_snack_bar.dart';
import 'package:help_ride_web/app/modules/home/modules/receivable/controllers/receivable_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/models/ride_model.dart';

class CardReceivable extends StatefulWidget {
  final RideModel ride;
  const CardReceivable({Key? key, required this.ride}) : super(key: key);

  @override
  State<CardReceivable> createState() => _CardReceivableState();
}

class _CardReceivableState extends State<CardReceivable> {
  @override
  Widget build(BuildContext context) {
    final receivableController = Modular.get<ReceivableController>();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Passageiro: ",
                      style: GoogleFonts.openSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AutoSizeText(
                      widget.ride.name!.toUpperCase(),
                      style: GoogleFonts.openSans(
                        color: AppColors.primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'R\$ ${widget.ride.totalToPay!.toStringAsFixed(2)}',
                  style: GoogleFonts.openSans(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -5,
              right: 0,
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
                      "Confirmar",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w400, fontSize: 15.0),
                    ),
                    onPressed: () async {
                      try {
                        Modular.to.pop();
                        String message = await receivableController
                            .closeOpenPaymentToReceive(
                                idReceiver: widget.ride.id!,
                                idPassenger: widget.ride.passengerId!);
                        showErrorSnackBar(message: message, context: context);
                      } catch (e) {
                        showErrorSnackBar(
                            message: e.toString(), context: context);
                      }
                    },
                  );
                  //configura o AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text(
                      "Confirmar Pagamento",
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w500, fontSize: 18.0),
                    ),
                    content: Text(
                      "Deseja confirmar o pagamento de ${widget.ride.name} e zerar suas caronas com você?",
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
                  Icons.money_off_csred_rounded,
                  color: AppColors.sucessSnackBar,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
