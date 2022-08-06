import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/helpers/show_snack_bar.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/controllers/rides_controller.dart';

class AddRideModal extends StatefulWidget {
  const AddRideModal({Key? key}) : super(key: key);

  @override
  State<AddRideModal> createState() => _AddRideModalState();
}

class _AddRideModalState extends State<AddRideModal> {
  int? idDriverSelected;
  int qntdPass = 2;
  bool isCompleteRide = true;

  @override
  Widget build(BuildContext context) {
    var ridesController = context.read<RidesController>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: const Text('Adicionar carona'),
      content: SizedBox(
        height: width > 800 ? height * 0.55 : height * 0.35,
        width: width > 800 ? width * 0.65 : width * 0.85,
        child: Column(
          children: [
            DropdownButton<int>(
              isExpanded: true,
              hint: const AutoSizeText(
                'Escolha seu motorista',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                ),
              ),
              value: idDriverSelected,
              items: List.generate(
                ridesController.drivers.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ridesController.drivers[index].name!,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              onChanged: (int? newValue) {
                setState(() {
                  idDriverSelected = newValue!;
                });
              },
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Quantidade de pessoas (com motorista):',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  fontSize: 14.0, fontWeight: FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (qntdPass - 1 >= 2) {
                        qntdPass--;
                      }
                    });
                  },
                  icon: const CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.remove,
                        color: AppColors.white,
                      )),
                ),
                Text(
                  qntdPass.toString(),
                  style: GoogleFonts.openSans(
                      fontSize: 24.0, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (qntdPass + 1 <= 5) {
                        qntdPass++;
                      }
                    });
                  },
                  icon: const CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.add_outlined,
                        color: AppColors.white,
                      )),
                )
              ],
            ),
            SizedBox(height: height * 0.01),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey3,
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
              child: CheckboxListTile(
                value: isCompleteRide,
                onChanged: (newBool) {
                  setState(() {
                    isCompleteRide = newBool!;
                  });
                },
                title: const Text(
                  'Ida e Volta',
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            try {
              var idUser = Modular.get<AuthController>().userModel.id!;

              if (idDriverSelected == null) {
                showErrorSnackBar(
                    message: 'Escolha o motorista para continuar',
                    context: context);
                return Future.delayed(Duration.zero);
              } else if (ridesController.drivers[idDriverSelected!].id ==
                  idUser) {
                showErrorSnackBar(
                    message: 'NÃO ESCOLHE VOCÊ MESMO NÃO PORRA FILHA DA PUTA',
                    context: context);
                return Future.delayed(Duration.zero);
              }

              await ridesController.addRide(
                  idUser: idUser,
                  driver: ridesController.drivers[idDriverSelected!],
                  passengers: qntdPass,
                  isCompleteRide: isCompleteRide);

              await ridesController.getmyOpenRides(idUser: idUser);

              Modular.to.pop();
              showSucessSnackBar(
                  message: 'Carona contabilizada com sucesso',
                  context: context);
            } catch (e) {
              showErrorSnackBar(message: e.toString(), context: context);
            }
          },
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Icon(
              Icons.save_alt_rounded,
              size: 28.0,
            ),
          ),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              'Adicionar',
              style: GoogleFonts.openSans(
                  fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
