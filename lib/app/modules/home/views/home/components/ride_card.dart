import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/models/ride_model.dart';

class CardRide extends StatelessWidget {
  final RideModel ride;
  const CardRide({Key? key, required this.ride}) : super(key: key);

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
        child: Column(
          children: [
            Text(
              'Total a pagar a:',
              style: GoogleFonts.openSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              ride.name!.toUpperCase(),
              style: GoogleFonts.openSans(
                color: AppColors.primaryColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'R\$ ${ride.totalToPay!.toStringAsFixed(2)} - ${ride.totalRides!} caronas',
              style: GoogleFonts.openSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }
}
