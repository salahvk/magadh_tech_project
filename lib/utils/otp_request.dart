import 'package:flutter/material.dart';
import 'package:magadh_tech/controllers/text_controllers.dart';
import 'package:magadh_tech/data/failures/main_failures.dart';
import 'package:magadh_tech/data/repositories/login_request.dart';
import 'package:magadh_tech/presentation/screens/otp_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void getOtp(BuildContext context) async {
  final phoneNo = PhoneNoController.phoneController.text;
  if (phoneNo.isEmpty || phoneNo.length < 10) {
    showTopSnackBar(
      Overlay.of(context),
      const SizedBox(
        height: 50,
        child: CustomSnackBar.error(
          icon: Icon(Icons.phone_android),
          iconPositionLeft: 20,
          iconPositionTop: -25,
          message: "Please enter a valid number!",
        ),
      ),
    );
    return;
  }
  final loginRes = await LoginImp().userLogin();
  loginRes.fold((failure) {
    failure == const MainFailure.serverFailure()
        ? showTopSnackBar(
            Overlay.of(context),
            const SizedBox(
              height: 50,
              child: CustomSnackBar.error(
                icon: Icon(Icons.people),
                iconPositionLeft: 20,
                iconPositionTop: -25,
                message: "User Details Not Found",
              ),
            ),
          )
        : showTopSnackBar(
            Overlay.of(context),
            const SizedBox(
              height: 50,
              child: CustomSnackBar.error(
                icon: Icon(Icons.signal_wifi_connected_no_internet_4_outlined),
                iconPositionLeft: 20,
                iconPositionTop: -25,
                message: "Check Your Connection",
              ),
            ),
          );
  }, (success) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return const OtpScreen();
    }));
    showTopSnackBar(
      Overlay.of(context),
      SizedBox(
        height: 50,
        child: CustomSnackBar.success(
          icon: const Icon(Icons.done),
          iconRotationAngle: 0,
          iconPositionLeft: 20,
          iconPositionTop: -25,
          message: success.otp.toString(),
        ),
      ),
    );
  });
}
