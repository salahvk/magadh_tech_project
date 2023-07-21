import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:magadh_tech/config/route_manager.dart';
import 'package:magadh_tech/data/repositories/login_request.dart';
import 'package:magadh_tech/utils/asset_manager.dart';
import 'package:magadh_tech/utils/color_manager.dart';
import 'package:magadh_tech/utils/style_manager.dart';
import 'package:multi_state_button/multi_state_button.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_countdown/slide_countdown.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final MultiStateButtonController multiStateButtonController =
      MultiStateButtonController(initialStateName: _submit);
  static const String _submit = "Verify OTP";
  static const String _loading = "Loading";
  static const String _success = "Success";
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? verificationId;
  String verificationcode = '';
  bool smsReceived = false;
  bool? pinVerified;
  bool userNameAv = false;

  final defaultPinTheme = PinTheme(
    width: 46,
    height: 46,
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ColorManager.background,
    ),
    decoration: BoxDecoration(
      // color: ColorManager.background,
      border: Border.all(color: ColorManager.background),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: ColorManager.background,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          colors: [ColorManager.whiteText, Color.fromARGB(255, 226, 221, 221)],
        )),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: ColorManager.grayDark,
                    radius: size.width * 0.3,
                    child: LottieBuilder.asset(
                      ImageAssets.enterOtp,
                      width: size.width * 0.45,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
                    child: Text(
                      'OTP Verification',
                      style: getBoldtStyle(
                          color: ColorManager.background, fontSize: 22),
                    ),
                  ),
                  Text(
                    'Enter the otp send to 9084070327',
                    style: getRegularStyle(
                        color: ColorManager.grayLight, fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: Text(
                      'Waiting for the OTP',
                      style: getBoldtStyle(
                          color: ColorManager.background, fontSize: 12),
                    ),
                  ),

                  //* Pinput start
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Pinput(
                      length: 6,
                      controller: controller,
                      // autofocus: true,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) async {
                        // print(pin);
                        // try {
                        //   await FirebaseAuth.instance
                        //       .signInWithCredential(PhoneAuthProvider.credential(
                        //           verificationId: verificationcode, smsCode: pin))
                        //       .then((value) async {
                        //     if (value.user != null) {
                        //       print(value.user);
                        //       print(value.credential);
                        //       print(value.hashCode);
                        //       print('Pass to home');
                        //       setState(() {
                        //         pinVerified = true;
                        //       });
                        //     }
                        //   });
                        // } catch (e) {
                        //   print(e);
                        //   showSnackBar("Invalid OTP!", context,
                        //       icon: Icons.format_list_numbered_outlined,
                        //       color: Colors.red);
                        // }
                        // pinVerified == true ? await getUserDetails() : null;
                        // userNameAv
                        // ?
                        await LoginImp(context: context).getUsers();
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, Routes.homeScreen, (route) => false);
                        Navigator.pushNamed(context, Routes.homeScreen);
                      },
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsRetrieverApi,
                    ),
                  ),
                  //* Pinput end
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MultiStateButton(
                          multiStateButtonController:
                              multiStateButtonController,
                          buttonStates: [
                            //submit state
                            ButtonState(
                              stateName: _submit,
                              child: const FittedBox(
                                child: Text(
                                  _submit,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  // color: ColorManager.disabledColor,
                                  borderRadius: BorderRadius.circular(
                                size.height * 0.05,
                              )),
                              textStyle: getSemiBoldtStyle(
                                color: ColorManager.background,
                              ),
                              size: Size(size.height * .26, 58),
                              color: Colors.blue,
                              onPressed: () {},
                            ),
                            //loading state
                            ButtonState(
                              stateName: _loading,
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                color: ColorManager.primary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(48)),
                              ),
                              size: const Size(45, 45),
                              onPressed: () {},
                            ),
                            //success button
                            ButtonState(
                              stateName: _success,
                              alignment: Alignment.center,
                              child: Lottie.asset('assets/created.json',
                                  fit: BoxFit.fill, repeat: false),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 17, 184, 62),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(48)),
                              ),
                              size: const Size(45, 45),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Didn't receive the OTP?",
                    style: getRegularStyle(
                        color: ColorManager.grayLight, fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend',
                        style: getRegularStyle(
                            color: ColorManager.grayLight, fontSize: 12),
                      ),
                      const SlideCountdown(
                        duration: Duration(seconds: 60),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //*  phone number authentication start

  // signup() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   print('Your phone number is ${widget.phoneNo}');

  //   await auth.verifyPhoneNumber(
  //       phoneNumber: '+91 ${widget.phoneNo}',
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential).then((value) async {
  //           if (value.user != null) {
  //             print('User logged in');
  //           }
  //         });
  //         print('credential ${credential.smsCode}');
  //         if (credential.smsCode != null) {
  //           setState(() {
  //             smsReceived = true;
  //           });
  //         }
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print(e.message);
  //         print(e.code);
  //       },
  //       codeSent: (verificationId, int? resendToken) async {
  //         print('This is verificaiton id $verificationId');
  //         print('This is resend token $resendToken');
  //         String smsCode = '';
  //         if (mounted) {
  //           setState(() {
  //             verificationcode = verificationId;
  //           });
  //         }
  //         PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //             verificationId: verificationId, smsCode: smsCode);
  //         print('This is SmsCode ${credential.smsCode}');
  //         print(credential.smsCode);
  //       },
  //       timeout: const Duration(seconds: 60),
  //       codeAutoRetrievalTimeout: (verificationid) {
  //         setState(() {
  //           verificationcode = verificationid;
  //         });
  //       });
  // }
  //*  phone number authentication end

  // getUserDetails() async {
  //   final provider = Provider.of<Data>(context, listen: false);
  //   final user = FirebaseAuth.instance.currentUser;
  //   print('Get user details');
  //   print(user?.phoneNumber);
  //   print('Login number');
  //   print(user?.uid);

  //   try {
  //     print('user place and name getting');

  //     await FirebaseFirestore.instance
  //         .collection("users data")
  //         .where("email", isEqualTo: "${user?.phoneNumber}")
  //         .get()
  //         .then((value) {
  //       value.docs.forEach((result) {
  //         print(result.get('name'));
  //         final userName = result.get('name');
  //         final place = result.get('place');
  //         if (userName != null) {
  //           print("username not null");
  //           provider.changePlace(place);

  //           setState(() {
  //             userNameAv = true;
  //           });
  //         } else {
  //           print("username is null");
  //         }
  //       });
  //     });
  //     print('user place and name ended');
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }
}
