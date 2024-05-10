import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/global.dart';
import '../../user/screen/home_screen.dart';
import '../repository/auth_repository.dart';
import '../screen/otp_verification.dart';

final authControllerProvider = NotifierProvider<AuthController,bool>(() {
  return AuthController();
});


class AuthController extends Notifier<bool> {
  @override
  bool build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  void phoneSignIn({
    required BuildContext context,
    required String phoneNumber,
  })  async {
    state =true;
    final user=await _authRepository.phoneSignIn(phoneNumber);
    state =false;
    user.fold((l) => showMessage(context, text:l.message,color: Colors.red),
            (r) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          OtpVerificationScreen(phoneNumber: phoneNumber,),));
            });
  }

  void verifyOtp({
    required BuildContext context,
    required String code,
  })  async {
    state =true;
    final user=await _authRepository.verifyOtp(code);
    state =false;
    user.fold((l) => showMessage(context, text:l.message,color: Colors.red),
            (r) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false);
      showMessage(context, text:"Login Successfully..!",color: Colors.green);
            });
  }
}