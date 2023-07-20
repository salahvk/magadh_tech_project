import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:magadh_tech/controllers/text_controllers.dart';
import 'package:magadh_tech/presentation/screens/otp_screen.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  bool loading = false;
  bool isChecked = false;
  var focusNode = FocusNode();

  void getOtp() {
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
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return const OtpScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: ColorManager.gradient2,
        body: SingleChildScrollView(
      child: Container(
          height: size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [ColorManager.gradient1, ColorManager.gradient2],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          )),
          child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.08, right: size.width * 0.08),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * 0.11,
                              bottom: size.height * 0.02),
                          child: Text(
                            'Welcome Friend!',
                            style: getRegularStyle(
                                color: ColorManager.background, fontSize: 16),
                          ),
                        ),
                        Text(
                          'Verify your mobile number\nthrough OTP!',
                          style: getRegularStyle(
                              color: ColorManager.background, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.04,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Phone Number',
                                style: getBoldtStyle(
                                    color: ColorManager.background,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // * phone number field start
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * 0.01,
                              bottom: size.height * 0.02),
                          child: Container(
                            // width: size.width * 0.8,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                                color: ColorManager.whiteText,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: PhoneNoController.phoneController,
                                  keyboardType: TextInputType.number,
                                  focusNode: focusNode,
                                  maxLength: 10,
                                  style: getRegularStyle(
                                      color: ColorManager.grayDark,
                                      fontSize: 14),
                                  onSubmitted: (value) {
                                    // FocusScope.of(context).requestFocus(focusNode);
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefix: Text('+91 ',
                                        style: getRegularStyle(
                                            color: ColorManager.grayDark,
                                            fontSize: 14)),
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // * phone number field end
                        GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            getOtp();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: size.height / 35,
                                bottom: size.height * 0.04),
                            height: size.height / 17,
                            width: size.width / 1.2,
                            decoration: BoxDecoration(
                                color: ColorManager.errorRed,
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Center(
                              child: loading == false
                                  ? Text("Request OTP",
                                      style: TextStyle(
                                          fontSize: size.height / 51,
                                          fontFamily: "Open",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))
                                  : Container(
                                      child: const CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: const Divider(
                                  color: Colors.black,
                                  height: 50,
                                )),
                          ),
                          Text("Or continue with",
                              style: getRegularStyle(
                                  color: ColorManager.grayDark)),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 10.0),
                                child: const Divider(
                                  color: Colors.black,
                                  height: 50,
                                )),
                          ),
                        ]),
                        Padding(
                            padding: EdgeInsets.only(top: size.height * 0.05),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    color: ColorManager.whiteText,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      child: Container(
                                        width: size.width * 0.82,
                                        height: size.height * 0.06,
                                        decoration: const BoxDecoration(),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.google,
                                              color: ColorManager.errorRed,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Google',
                                              style: getRegularStyle(
                                                  color:
                                                      ColorManager.background,
                                                  fontSize: 16),
                                            )
                                          ],
                                        )),
                                      ),
                                      onTap: () {
                                        // Navigator.pushNamed(context, Routes.signInRoute);
                                      },
                                    ),
                                  )
                                ])),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create an account with ',
                              style: getRegularStyle(
                                  color: ColorManager.background, fontSize: 12),
                            ),
                            GestureDetector(
                              child: Text(
                                'Email Address',
                                style: getRegularStyle(
                                    color: Colors.blue, fontSize: 12),
                              ),
                              onTap: () {
                                // Navigator.pushReplacementNamed(
                                //     context, Routes.signUpRoute);
                              },
                            )
                          ],
                        ),
                      ])))),
    ));
  }
}
