import 'package:flutter/material.dart';
import 'package:magadh_tech/config/route_manager.dart';
import 'package:magadh_tech/utils/asset_manager.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initFun();
  }

  initFun() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final String? token = prefs.getString('access_token');
      // final BuildContext myContext = context;
      await Future.delayed(const Duration(seconds: 3));
      // if (token == null) {
        Navigator.pushReplacementNamed(context, Routes.landingScreen);
      // } else {
      //   await FetchEmployeesData.getData(myContext);
      //   await FetchDesignations.getData(myContext);
      //   Navigator.pushReplacementNamed(context, Routes.homeScreen);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // Lottie.asset(ImageAssets.splashLottie),
            Image.asset(ImageAssets.splashImage),
            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Text(
                "Magadh Tech",
                style: getSemiBoldtStyle(
                    fontSize: 20, color: ColorManager.whiteText),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 430),
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: ColorManager.primary,
                  )),
            )
          ],
        ),
      ),
    );
  }
}