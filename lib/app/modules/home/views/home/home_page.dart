import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/helpers/show_snack_bar.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/pay/view/pay_page.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/controllers/rides_controller.dart';
import 'package:help_ride_web/app/modules/home/views/drawer/drawer.dart';
import 'package:help_ride_web/app/modules/home/views/home/components/add_ride_dialog.dart';
import 'package:help_ride_web/app/modules/home/views/home/components/ride_card.dart';
import 'package:help_ride_web/app/shared/components/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    authState();
  }

  Future authState() async {
    await Future.delayed(const Duration(seconds: 5)).then((_) async {
      var status = Modular.get<AuthController>().status;
      debugPrint(status.toString());
      while (status == Status.uninitialized) {
        if (status == Status.authenticated) {
          await Modular.get<RidesController>().getmyOpenRides(
              idUser: Modular.get<AuthController>().userModel.id!);
          setState(() {
            isLoading = false;
          });
        } else {
          Modular.to.navigate('/auth');
          throw 'Unauthenticated';
        }
      }
    });
  }

  Future<void> addRideDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return const AddRideModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final ridesController = context.watch<RidesController>();
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? Shimmer.fromColors(
                baseColor: AppColors.grey.withOpacity(0.2),
                highlightColor: AppColors.grey2.withOpacity(0.25),
                child: Skeleton(
                  color: AppColors.white.withOpacity(0.5),
                  height: 20,
                  width: 240,
                  radius: 4,
                ),
              )
            : Text(
                'Olá, ${authController.userModel.name ?? ''}',
                style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await ridesController.getmyOpenRides(
                  idUser: authController.userModel.id!);
              if (ridesController.status == RidesStatus.error) {
                showErrorSnackBar(
                    message:
                        'Não foi possível recarregar seus pagamentos pendentes',
                    context: context);
              }
            },
            icon: const Icon(Icons.replay_outlined),
          )
        ],
      ),
      drawer: isLoading
          ? Shimmer.fromColors(
              baseColor: AppColors.grey.withOpacity(0.2),
              highlightColor: AppColors.grey2.withOpacity(0.25),
              child: Skeleton(
                color: AppColors.white.withOpacity(0.5),
                height: 30,
                width: 30,
                radius: 3,
              ),
            )
          : const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await ridesController.getAllDrivers();
              await addRideDialog();
            } catch (e) {
              showErrorSnackBar(message: e.toString(), context: context);
            }
          },
          isExtended: true,
          child: const Icon(
            Icons.add,
            size: 36,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoading || ridesController.status == RidesStatus.loading
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  4,
                  (index) => const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: SkeletonCardRide(),
                  ),
                ),
              ),
            )
          : ridesController.myOpenRides.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Você não possui caronas pendentes',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: AppColors.primaryColor)),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    try {
                      await ridesController.getAllDrivers();
                      await addRideDialog();
                    } catch (e) {
                      showErrorSnackBar(
                          message: e.toString(), context: context);
                    }
                  },
                  child: ListView.builder(
                    itemCount: ridesController.myOpenRides.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: InkWell(
                        onTap: () async {
                          await authController
                              .getUserById(
                                  ridesController.myOpenRides[index].id!)
                              .then(
                                (driver) => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext _) {
                                    return PayPage(
                                      user: driver,
                                      ride: ridesController.myOpenRides[index],
                                    );
                                  },
                                ),
                              );
                        },
                        child: CardRide(
                          ride: ridesController.myOpenRides[index],
                        ),
                      ),
                    ),
                  )
                  //  SingleChildScrollView(
                  //   physics: const BouncingScrollPhysics(),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     children: List.generate(
                  //       ridesController.myOpenRides.length,
                  //       (index) => Padding(
                  //         padding: const EdgeInsets.only(top: 12.0),
                  //         child: CardRide(
                  //             ride: ridesController.myOpenRides[index]),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ),
    );
  }
}

class SkeletonCardRide extends StatelessWidget {
  const SkeletonCardRide({Key? key}) : super(key: key);

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
            children: [
              const SizedBox(height: 8),
              Skeleton(
                color: AppColors.white.withOpacity(0.6),
                height: 8,
                width: constraints.maxWidth * 0.3,
                radius: 8,
              ),
              const SizedBox(height: 12),
              Skeleton(
                color: AppColors.white.withOpacity(0.6),
                height: 16,
                width: constraints.maxWidth * 0.65,
                radius: 8,
              ),
              const SizedBox(height: 12),
              Skeleton(
                color: AppColors.white.withOpacity(0.6),
                height: 12,
                width: constraints.maxWidth * 0.5,
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
