// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:magadh_tech/config/route_manager.dart';
import 'package:magadh_tech/data/providers/data_provider.dart';
import 'package:magadh_tech/data/repositories/login_request.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ImagePicker _picker = ImagePicker();
  bool loading = false;
  String? imagePath;
  XFile? imageFile;

  selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      imagePath = image.path;
      imageFile = image;
    });
    final provider = Provider.of<DataProvider>(context, listen: false);

    provider.imageFile = File(imagePath!);
  }

  logOUtFunction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.landingScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    final profileData = provider.loginVerifyModel?.user;

    return Container(
        decoration: const BoxDecoration(
          color: ColorManager.errorRed,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: imageFile != null
                          ? Image.file(
                              File(imagePath ?? ''),
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              width: 90,
                              height: 90,
                              imageUrl:
                                  "https://flutter.magadh.co/${profileData?.image}",
                              errorWidget: (context, url, error) {
                                return Container(
                                  color: ColorManager.grayDark,
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 2,
                      child: InkWell(
                        onTap: () {
                          selectImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 1,
                                blurRadius: 3,
                                // offset: const Offset(2, 2.5),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: ColorManager.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              profileData?.name ?? '',
              style:
                  getRegularStyle(color: ColorManager.textColor, fontSize: 14),
            ),
            Text(
              profileData?.email ?? '',
              style:
                  getRegularStyle(color: ColorManager.textColor, fontSize: 14),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.mapScreen);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Change Location",
                  style: getSemiBoldtStyle(
                      color: ColorManager.background, fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (imagePath == null) {
                  showTopSnackBar(
                    Overlay.of(context),
                    const SizedBox(
                      height: 50,
                      child: CustomSnackBar.error(
                        icon: Icon(
                            Icons.signal_wifi_connected_no_internet_4_outlined),
                        iconPositionLeft: 20,
                        iconPositionTop: -25,
                        message: "Upload an image",
                      ),
                    ),
                  );
                  return;
                }
                await LoginImp(context: context).updateProfile();
              },
              child: Text(
                "Update Profile",
                style: getSemiBoldtStyle(
                    color: ColorManager.background, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: logOUtFunction,
              child: Text(
                "Logout",
                style: getSemiBoldtStyle(
                    color: ColorManager.background, fontSize: 16),
              ),
            ),
          ],
        ));
  }
}
