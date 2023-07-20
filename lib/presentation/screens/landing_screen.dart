import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:magadh_tech/config/route_manager.dart';
import 'package:magadh_tech/utils/asset_manager.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';


class LandingScreen extends StatelessWidget {
    const LandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImageAssets.background,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            scale: 1,
          ),
          SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.1),
                            const Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ])),
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: LottieBuilder.asset(
                            ImageAssets.intro,repeat: true,
                            width: size.width * 0.9,
                            height: size.height * 0.5,
                          )),
                      Text(
                        'CREATIVE & SOFTWARE DEVELOPMENT COMPANY.',


                        textAlign: TextAlign.center,
                        style: getBoldtStyle(
                            color: ColorManager.whiteText, fontSize: 24),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20, bottom: size.height * 0.16),
                        child: Text(
                          'At Magadh Digital Solution Pvt Ltd, we’re passionate about demonstrating the tangible benefits that digital transformation can bring your business.',
                          textAlign: TextAlign.center,
                          style: getBoldtStyle(
                              color: ColorManager.grayExtraLight, fontSize: 12),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          Material(
                            borderRadius: BorderRadius.circular(10),
                                 color: ColorManager.whiteText,
                            child: InkWell(
                              child: Container(
                                width: size.width * 0.4,
                                height: size.height * 0.06,
                                decoration: const BoxDecoration(),
                                child: Center(
                                  child: Text(
                                    'Phone Number',
                                    style: getBoldtStyle(
                                        color: ColorManager.grayDark),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.phoneNoScreen);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}