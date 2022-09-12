import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/helpers/show_snack_bar.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/models/ride_model.dart';
import 'package:help_ride_web/app/shared/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayPage extends StatefulWidget {
  final UserModel user;
  final RideModel ride;
  const PayPage({Key? key, required this.user, required this.ride})
      : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  bool isLoading = true;
  bool isCopied = false;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  Future setUserData() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final authController = context.read<AuthController>();
        // final receivableController = context.read<ReceivableController>();
        if (!Modular.to.canPop()) {
          authController.status = Status.authenticated;
          Modular.to.navigate('/home/');
          return;
        }
        await Future.delayed(const Duration(seconds: 2)).then((value) async {
          if (authController.status == Status.unauthenticated) {
            Modular.to.navigate('/auth');
          }
          // await receivableController
          //     .getReceivableRides(idUser: authController.userModel.id!)
          //     .whenComplete(() {
          setState(() {
            isLoading = false;
          });
          // });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Scaffold(
        body: Container(
          height: height * 0.85,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.015),
              Container(
                height: 5,
                width: width * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.grey2),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Chave Pix',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: AppColors.black),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        textAlign: TextAlign.start,
                        controller:
                            TextEditingController(text: widget.user.pixCode),
                        readOnly: true,
                        style: GoogleFonts.roboto(
                            fontSize: 14, color: AppColors.black),
                        decoration: InputDecoration(
                          hintText: 'Código',
                          hintStyle: GoogleFonts.roboto(
                              fontSize: 14, color: AppColors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(
                                    ClipboardData(text: widget.user.pixCode))
                                .then((value) {
                              showSucessSnackBar(
                                  message: 'Código Pix copiado',
                                  context: context);
                              setState(() {
                                isCopied = true;
                              });
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isCopied
                                    ? AppColors.copiedColor
                                    : AppColors.primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  isCopied ? 'Copiado' : 'Copiar',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              QrImage(
                data: widget.user.pixCode!,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Total a pagar: R\$ ${widget.ride.totalToPay!.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: AppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
