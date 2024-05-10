import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../controller/auth_controller.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timer = StateProvider<Timer?>((ref) => null);
  final _countDown = StateProvider<int>((ref) => 59);
  final _canResend = StateProvider<bool>((ref) => false);

  void startTimer() {
    ref.watch(_timer.notifier).state = Timer.periodic(const Duration(seconds: 1), (timer) {
      final countDown = ref.watch(_countDown.notifier).state;
      if (countDown > 0) {
        ref.watch(_countDown.notifier).update((value) => value - 1);
      } else {
        ref.read(_canResend.notifier).update((value) => true);
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    final canResend = ref.watch(_canResend.notifier).state;
    if (canResend) {
      ref.read(_countDown.notifier).update((value) => 59);
      ref.read(_canResend.notifier).update((value) => false);
      startTimer();
    }
  }

  var code = '';

  void verifyOtp(String codes) {
    ref.read(authControllerProvider.notifier).verifyOtp(context: context, code: codes);
  }

  void phoneVerification() {
    ref.read(authControllerProvider.notifier).phoneSignIn(context: context, phoneNumber: "+91${widget.phoneNumber}");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>startTimer());
    super.initState();
  }

  @override
  void dispose() {
    ref.watch(_timer.notifier).state?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countDown = ref.watch(_countDown);
    final canResend = ref.watch(_canResend);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(w * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/Group.png", height: h * 0.15),
                SizedBox(height: h * 0.03),
                const Row(
                  children: [
                    Text(
                      "OTP Verification",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.04,
                ),
                Text(
                  "Enter the verification code we just sent to your number +91********${widget.phoneNumber.substring(widget.phoneNumber.length - 2)}",
                  style: TextStyle(fontSize: w * 0.04),
                ),
                SizedBox(
                  height: h * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.035, right: w * 0.035),
                  child: Pinput(
                    // focusedPinTheme:PinTheme(
                    //   height: h * 0.05,
                    //   width: w,
                    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(w * 0.03), border: Border.all(color: Colors.black)),
                    // ) ,
                    followingPinTheme: PinTheme(
                      height: h * 0.05,
                      width: w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(w * 0.03), border: Border.all(color: Colors.black)),
                    ),
                    validator: (value) {
                      if (value?.length != 6) {
                        return 'Please enter OTP';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      code = value;
                    },
                    length: 6,
                  ),
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                Text(
                  "${countDown.toString()} Sec",
                  style: const TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: h * 0.015,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t Get OTP? ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      canResend
                          ? TextSpan(
                          text: 'Resend',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              phoneVerification();
                              resendOtp();
                            },
                          style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue))
                          : const TextSpan(
                        text: 'Resend',
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      verifyOtp(code);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(w * 0.9, h * 0.065),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.08)),
                  ),
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: w * 0.045, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

