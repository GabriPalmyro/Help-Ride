// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_ride_web/app/core/core.dart';
import 'package:help_ride_web/app/modules/auth/controllers/auth_controller.dart';
import 'package:help_ride_web/app/shared/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pixCodeController = TextEditingController();
  TextEditingController twoPeopleController = TextEditingController();
  TextEditingController threePeopleController = TextEditingController();
  TextEditingController fourPeopleController = TextEditingController();
  TextEditingController fivePeopleController = TextEditingController();
  bool isDriver = false;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  Future setUserData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var status = Modular.get<AuthController>().status;
      if (status == Status.authenticated) {
        nameController.text = Modular.get<AuthController>().userModel.name!;
        emailController.text = Modular.get<AuthController>().userModel.email!;
        pixCodeController.text =
            Modular.get<AuthController>().userModel.pixCode!;
        twoPeopleController.text =
            Modular.get<AuthController>().userModel.priceTwoPeople!.toString();
        threePeopleController.text = Modular.get<AuthController>()
            .userModel
            .priceThreePeople!
            .toString();
        fourPeopleController.text =
            Modular.get<AuthController>().userModel.priceFourPeople!.toString();
        fivePeopleController.text =
            Modular.get<AuthController>().userModel.priceFivePeople!.toString();
        isDriver = Modular.get<AuthController>().userModel.isDriver!;
        setState(() {
          isLoading = false;
        });
      } else {
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          if (status == Status.unauthenticated) {
            Modular.to.navigate('/auth');
          }
          nameController.text = Modular.get<AuthController>().userModel.name!;
          emailController.text = Modular.get<AuthController>().userModel.email!;
          pixCodeController.text =
              Modular.get<AuthController>().userModel.pixCode!;
          twoPeopleController.text = Modular.get<AuthController>()
              .userModel
              .priceTwoPeople!
              .toString();
          threePeopleController.text = Modular.get<AuthController>()
              .userModel
              .priceThreePeople!
              .toString();
          fourPeopleController.text = Modular.get<AuthController>()
              .userModel
              .priceFourPeople!
              .toString();
          fivePeopleController.text = Modular.get<AuthController>()
              .userModel
              .priceFivePeople!
              .toString();
          isDriver = Modular.get<AuthController>().userModel.isDriver!;
          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var authController = context.watch<AuthController>();
    return isLoading
        ? LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              body: SizedBox(
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
                        'Carregando suas informações...',
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w400, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
            );
          })
        : LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
                body: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              authController.status = Status.authenticated;
                              Modular.to.canPop()
                                  ? Modular.to.pop()
                                  : Modular.to.pushNamed('/home/');
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                          ),
                          Text(
                            'Perfil',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w700, fontSize: 24.0),
                          ),
                          IconButton(
                            onPressed: () {
                              if (authController.status != Status.editing) {
                                setState(() {
                                  authController.status = Status.editing;
                                });
                              } else {
                                setState(() {
                                  authController.status = Status.authenticated;
                                });
                                nameController.text =
                                    authController.userModel.name!;
                                emailController.text =
                                    authController.userModel.email!;
                                pixCodeController.text =
                                    authController.userModel.pixCode!;
                                twoPeopleController.text = authController
                                    .userModel.priceTwoPeople!
                                    .toString();
                                threePeopleController.text = authController
                                    .userModel.priceThreePeople!
                                    .toString();
                                fourPeopleController.text = authController
                                    .userModel.priceFourPeople!
                                    .toString();
                                fivePeopleController.text = authController
                                    .userModel.priceFivePeople!
                                    .toString();
                                isDriver = authController.userModel.isDriver!;
                              }
                            },
                            icon: Icon(
                              authController.status == Status.editing
                                  ? Icons.edit_off
                                  : Icons.edit,
                              color: authController.status == Status.editing
                                  ? AppColors.red
                                  : AppColors.primaryColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            authController.userModel.photo!,
                            fit: BoxFit.cover,
                            scale: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      TextField(
                        controller: nameController,
                        enabled: authController.status == Status.editing,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      TextField(
                        controller: emailController,
                        enabled: authController.status == Status.editing,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        child: CheckboxListTile(
                          value: isDriver,
                          onChanged: (newBool) {
                            if (authController.status == Status.editing) {
                              setState(() {
                                isDriver = newBool!;
                              });
                            }
                          },
                          title: Text(
                            'Motorista',
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      if (isDriver) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              controller: pixCodeController,
                              enabled: authController.status == Status.editing,
                              decoration: InputDecoration(
                                  helperText: 'Insira o seu código pix'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.005),
                            TextField(
                              controller: twoPeopleController,
                              enabled: authController.status == Status.editing,
                              decoration: InputDecoration(
                                  helperText: 'Preço com duas pessoas'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.005),
                            TextField(
                              controller: threePeopleController,
                              enabled: authController.status == Status.editing,
                              decoration: InputDecoration(
                                  helperText: 'Preço com três pessoas'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.005),
                            TextField(
                              controller: fourPeopleController,
                              enabled: authController.status == Status.editing,
                              decoration: InputDecoration(
                                  helperText: 'Preço com quatro pessoas'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.005),
                            TextField(
                              controller: fivePeopleController,
                              enabled: authController.status == Status.editing,
                              decoration: InputDecoration(
                                  helperText: 'Preço com cinco pessoas'),
                            ),
                          ],
                        )
                      ],
                      SizedBox(height: constraints.maxHeight * 0.03),
                      if (authController.status == Status.editing) ...[
                        ElevatedButton.icon(
                          onPressed: () async {
                            await authController.updateProfileUser(
                              userModelNew: UserModel(
                                id: authController.userModel.id,
                                name: nameController.text,
                                email: emailController.text,
                                photo: authController.userModel.photo,
                                pixCode: pixCodeController.text,
                                isDriver: isDriver,
                                priceTwoPeople:
                                    double.tryParse(twoPeopleController.text),
                                priceThreePeople:
                                    double.tryParse(threePeopleController.text),
                                priceFourPeople:
                                    double.tryParse(fourPeopleController.text),
                                priceFivePeople:
                                    double.tryParse(fivePeopleController.text),
                              ),
                            );

                            Modular.to.canPop()
                                ? Modular.to.pop()
                                : Modular.to.pushNamed('/home/');
                          },
                          icon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(
                              Icons.save_alt_rounded,
                              size: 32,
                            ),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 5.0),
                            child: Text(
                              'Salvar',
                              style: GoogleFonts.openSans(
                                  fontSize: 18.0, fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                      SizedBox(height: constraints.maxHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ));
          });
  }
}
