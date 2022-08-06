import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/receivable/controllers/receivable_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/receivable/views/components/card_receivable.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/controllers/rides_controller.dart';
import 'package:help_ride_web/app/shared/components/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class ReceivablePage extends StatefulWidget {
  const ReceivablePage({Key? key}) : super(key: key);

  @override
  State<ReceivablePage> createState() => _ReceivablePageState();
}

class _ReceivablePageState extends State<ReceivablePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  Future setUserData() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final authController = context.read<AuthController>();
        final receivableController = context.read<ReceivableController>();
        if (!Modular.to.canPop()) {
          authController.status = Status.authenticated;
          Modular.to.navigate('/home/');
          return;
        }
        await Future.delayed(const Duration(seconds: 2)).then((value) async {
          if (authController.status == Status.unauthenticated) {
            Modular.to.navigate('/auth');
          }
          await receivableController
              .getReceivableRides(idUser: authController.userModel.id!)
              .whenComplete(() {
            setState(() {
              isLoading = false;
            });
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final receivableController = context.watch<ReceivableController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.02),
                Container(
                  width: constraints.maxWidth,
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          authController.status = Status.authenticated;
                          Modular.to.canPop()
                              ? Modular.to.pop()
                              : Modular.to.pushNamed('/home/');
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.primaryColor,
                          size: 28,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          'A receber',
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w700, fontSize: 24.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.015),
                isLoading || receivableController.status == RidesStatus.loading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          4,
                          (index) => const Padding(
                            padding: EdgeInsets.only(top: 12.0),
                            child: SkeletonCardReceivable(),
                          ),
                        ),
                      )
                    : receivableController.myReceveibleRides.isEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Você não possui pagamentos a receber',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(
                                  receivableController.myReceveibleRides.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: CardReceivable(
                                      ride: receivableController
                                          .myReceveibleRides[index],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              Text(
                                'Total a receber: R\$ ${receivableController.totalToReceive.toStringAsFixed(2)}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: AppColors.black),
                              )
                            ],
                          ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SkeletonCardReceivable extends StatelessWidget {
  const SkeletonCardReceivable({Key? key}) : super(key: key);

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
        child: Shimmer.fromColors(
          baseColor: AppColors.grey.withOpacity(0.3),
          highlightColor: AppColors.grey2.withOpacity(0.34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Skeleton(
                    color: AppColors.white.withOpacity(0.6),
                    height: 10,
                    width: constraints.maxWidth * 0.15,
                    radius: 8,
                  ),
                  const SizedBox(width: 8),
                  Skeleton(
                    color: AppColors.white.withOpacity(0.6),
                    height: 12,
                    width: constraints.maxWidth * 0.25,
                    radius: 8,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Skeleton(
                color: AppColors.white.withOpacity(0.6),
                height: 18,
                width: constraints.maxWidth * 0.2,
                radius: 8,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    });
  }
}
